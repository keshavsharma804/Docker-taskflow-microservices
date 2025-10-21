from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2
from psycopg2.extras import RealDictCursor
import redis
import pika
import json
import os
import time

app = Flask(__name__)
CORS(app)

# Database connection
def get_db():
    return psycopg2.connect(
        host=os.getenv('DB_HOST', 'db'),
        database=os.getenv('DB_NAME', 'taskflow'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', 'password')
    )

# Redis connection
cache = redis.Redis(
    host=os.getenv('REDIS_HOST', 'redis'),
    port=6379,
    decode_responses=True
)

# Initialize database
def init_db():
    max_retries = 5
    for i in range(max_retries):
        try:
            conn = get_db()
            cur = conn.cursor()
            cur.execute('''
                CREATE TABLE IF NOT EXISTS tasks (
                    id SERIAL PRIMARY KEY,
                    title VARCHAR(255) NOT NULL,
                    description TEXT,
                    status VARCHAR(50) DEFAULT 'pending',
                    priority VARCHAR(20) DEFAULT 'medium',
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ''')
            conn.commit()
            cur.close()
            conn.close()
            print("✅ Database initialized successfully!")
            break
        except Exception as e:
            print(f"❌ Database connection attempt {i+1}/{max_retries} failed: {e}")
            time.sleep(2)

# Health check
@app.route('/health')
def health():
    try:
        # Check database
        conn = get_db()
        conn.close()
        db_status = "healthy"
    except:
        db_status = "unhealthy"
    
    try:
        # Check Redis
        cache.ping()
        redis_status = "healthy"
    except:
        redis_status = "unhealthy"
    
    return jsonify({
        'status': 'healthy',
        'database': db_status,
        'redis': redis_status
    })

# Get all tasks
@app.route('/api/tasks', methods=['GET'])
def get_tasks():
    # Try cache first
    cached = cache.get('all_tasks')
    if cached:
        return jsonify({'tasks': json.loads(cached), 'source': 'cache'})
    
    # Get from database
    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM tasks ORDER BY created_at DESC')
    tasks = cur.fetchall()
    cur.close()
    conn.close()
    
    # Cache the result
    cache.setex('all_tasks', 60, json.dumps(tasks, default=str))
    
    return jsonify({'tasks': tasks, 'source': 'database'})

# Create task
@app.route('/api/tasks', methods=['POST'])
def create_task():
    data = request.json
    
    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute(
        'INSERT INTO tasks (title, description, priority) VALUES (%s, %s, %s) RETURNING *',
        (data['title'], data.get('description', ''), data.get('priority', 'medium'))
    )
    task = cur.fetchone()
    conn.commit()
    cur.close()
    conn.close()
    
    # Invalidate cache
    cache.delete('all_tasks')
    
    # Send to message queue for background processing
    try:
        connection = pika.BlockingConnection(
            pika.ConnectionParameters(host=os.getenv('RABBITMQ_HOST', 'rabbitmq'))
        )
        channel = connection.channel()
        channel.queue_declare(queue='task_queue', durable=True)
        channel.basic_publish(
            exchange='',
            routing_key='task_queue',
            body=json.dumps({'task_id': task['id'], 'action': 'created'}),
            properties=pika.BasicProperties(delivery_mode=2)
        )
        connection.close()
    except Exception as e:
        print(f"Message queue error: {e}")
    
    return jsonify({'task': task, 'message': 'Task created successfully'}), 201

# Update task
@app.route('/api/tasks/<int:task_id>', methods=['PUT'])
def update_task(task_id):
    data = request.json
    
    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute(
        'UPDATE tasks SET status = %s WHERE id = %s RETURNING *',
        (data['status'], task_id)
    )
    task = cur.fetchone()
    conn.commit()
    cur.close()
    conn.close()
    
    # Invalidate cache
    cache.delete('all_tasks')
    
    return jsonify({'task': task, 'message': 'Task updated successfully'})

# Delete task
@app.route('/api/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    conn = get_db()
    cur = conn.cursor()
    cur.execute('DELETE FROM tasks WHERE id = %s', (task_id,))
    conn.commit()
    cur.close()
    conn.close()
    
    # Invalidate cache
    cache.delete('all_tasks')
    
    return jsonify({'message': 'Task deleted successfully'})

# Stats endpoint
@app.route('/api/stats')
def stats():
    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''
        SELECT 
            status,
            COUNT(*) as count
        FROM tasks
        GROUP BY status
    ''')
    stats = cur.fetchall()
    cur.close()
    conn.close()
    
    return jsonify({'stats': stats})

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)

import pika
import json
import time
import os

def process_task(task_data):
    print(f"📋 Processing task: {task_data}")
    # Simulate work
    time.sleep(2)
    print(f"✅ Task {task_data['task_id']} processed successfully!")

def main():
    max_retries = 5
    for i in range(max_retries):
        try:
            connection = pika.BlockingConnection(
                pika.ConnectionParameters(host=os.getenv('RABBITMQ_HOST', 'rabbitmq'))
            )
            channel = connection.channel()
            channel.queue_declare(queue='task_queue', durable=True)
            
            print('🔄 Worker started. Waiting for messages...')
            
            def callback(ch, method, properties, body):
                task_data = json.loads(body)
                process_task(task_data)
                ch.basic_ack(delivery_tag=method.delivery_tag)
            
            channel.basic_qos(prefetch_count=1)
            channel.basic_consume(queue='task_queue', on_message_callback=callback)
            
            channel.start_consuming()
            break
        except Exception as e:
            print(f"❌ Connection attempt {i+1}/{max_retries} failed: {e}")
            time.sleep(5)

if __name__ == '__main__':
    main()

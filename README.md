# TaskFlow - Microservices Task Management Application

![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)
![Python](https://img.shields.io/badge/Python-3.11-3776AB?logo=python)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-4169E1?logo=postgresql)
![Redis](https://img.shields.io/badge/Redis-7-DC382D?logo=redis)
![RabbitMQ](https://img.shields.io/badge/RabbitMQ-3-FF6600?logo=rabbitmq)

A production-ready microservices application demonstrating modern containerization practices, inter-service communication, caching strategies, message queuing, and API gateway patterns.

## 🏗️ Architecture

TaskFlow consists of 7 microservices orchestrated with Docker Compose:

- **Frontend** - Responsive React UI
- **API Gateway** - Nginx reverse proxy with load balancing  
- **Backend API** - Flask REST API with PostgreSQL
- **Worker Service** - Background job processor with RabbitMQ
- **PostgreSQL** - Persistent data storage
- **Redis** - Caching layer (30-second TTL)
- **RabbitMQ** - Message queue for async tasks

## 🚀 Features

✅ Complete CRUD operations for task management  
✅ Real-time caching with Redis  
✅ Asynchronous task processing via message queue  
✅ Health monitoring endpoints  
✅ Resource limits and optimization  
✅ Non-root user security  
✅ Multi-stage Docker builds  
✅ Production-ready configuration  

## 📋 Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Docker Compose v2.0+
- 4GB+ RAM allocated to Docker
- Ports available: 80, 5432, 6379, 5672, 15672

## 🔧 Quick Start

### 1. Clone the repository
\\\powershell
git clone https://github.com/keshavsharma804/Docker-taskflow-microservices.git
cd taskflow-microservices
\\\

### 2. Start all services
\\\powershell
docker-compose up -d
\\\

### 3. Verify services are running
\\\powershell
docker-compose ps
\\\

### 4. Access the application
- **Web UI:** http://localhost
- **API Endpoint:** http://localhost/api/tasks
- **Health Check:** http://localhost/health
- **RabbitMQ UI:** http://localhost:15672 (guest/guest)

## 🐳 Docker Images on Docker Hub

Pull pre-built images:
\\\powershell
docker pull keshavsharma804/taskflow-frontend:1.0.0
docker pull keshavsharma804/taskflow-backend:1.0.0
docker pull keshavsharma804/taskflow-worker:1.0.0
docker pull keshavsharma804/taskflow-nginx:1.0.0
\\\

## 📊 Service Details

| Service | Port | Technology | Resources | Purpose |
|---------|------|------------|-----------|---------|
| Frontend | 3000 | React | 256MB RAM, 0.5 CPU | User interface |
| Nginx | 80 | Nginx | 128MB RAM, 0.25 CPU | API Gateway |
| Backend | 5000 | Flask/Python | 512MB RAM, 1 CPU | REST API |
| Worker | - | Python | 256MB RAM, 0.5 CPU | Background jobs |
| PostgreSQL | 5432 | PostgreSQL 15 | 512MB RAM | Database |
| Redis | 6379 | Redis 7 | 256MB RAM | Cache |
| RabbitMQ | 5672, 15672 | RabbitMQ 3 | 512MB RAM | Message Queue |

## 🧪 API Testing

### Create a task
\\\powershell
\ = @{
    title = "Deploy Application"
    description = "Deploy TaskFlow to production"
    priority = "high"
    status = "pending"
} | ConvertTo-Json

Invoke-RestMethod -Uri http://localhost/api/tasks -Method POST -Body \ -ContentType "application/json"
\\\

### Get all tasks
\\\powershell
Invoke-RestMethod -Uri http://localhost/api/tasks
\\\

### Update a task
\\\powershell
\ = @{ status = "completed" } | ConvertTo-Json
Invoke-RestMethod -Uri http://localhost/api/tasks/1 -Method PUT -Body \ -ContentType "application/json"
\\\

### Delete a task
\\\powershell
Invoke-RestMethod -Uri http://localhost/api/tasks/1 -Method DELETE
\\\

## 📈 Monitoring

### View real-time stats
\\\powershell
docker stats
\\\

### View logs for specific service
\\\powershell
docker-compose logs -f backend
\\\

### Check service health
\\\powershell
curl http://localhost/health
\\\

## 🛠️ Development

### Build from source
\\\powershell
docker-compose build
\\\

### Build without cache
\\\powershell
docker-compose build --no-cache
\\\

### Scale backend service
\\\powershell
docker-compose up -d --scale backend=3
\\\

### Restart a service
\\\powershell
docker-compose restart backend
\\\

## 📦 Project Structure

\\\
taskflow-microservices/
├── frontend/
│   ├── Dockerfile
│   ├── index.html
│   └── .dockerignore
├── backend/
│   ├── Dockerfile
│   ├── app.py
│   ├── requirements.txt
│   └── .dockerignore
├── worker/
│   ├── Dockerfile
│   ├── worker.py
│   ├── requirements.txt
│   └── .dockerignore
├── nginx/
│   ├── Dockerfile
│   └── nginx.conf
├── database/
│   └── init.sql
├── docker-compose.yml
├── README.md
└── .gitignore
\\\

## 🔐 Security Features

✅ Non-root users in all containers  
✅ Resource limits (CPU/Memory)  
✅ Health check implementations  
✅ Read-only file systems where applicable  
✅ No privileged containers  
✅ Environment variable isolation  
✅ Secure secrets management  

## 🎯 Docker Best Practices Implemented

✅ Multi-stage builds for optimized images  
✅ Layer caching optimization  
✅ .dockerignore files to reduce context  
✅ Health checks for all services  
✅ Graceful shutdown handling  
✅ Named volumes for persistence  
✅ Custom networks for service isolation  
✅ Resource constraints  
✅ Dependency management with depends_on  

## 🧹 Cleanup

### Stop all services
\\\powershell
docker-compose down
\\\

### Remove volumes (⚠️ deletes all data)
\\\powershell
docker-compose down -v
\\\

### Clean up Docker system
\\\powershell
docker system prune -a --volumes
\\\

## 🐛 Troubleshooting

**Services not starting?**
\\\powershell
docker-compose logs service-name
\\\

**Port already in use?**
\\\powershell
docker ps
docker stop conflicting-container
\\\

**Database connection issues?**
\\\powershell
docker exec taskflow-microservices-db-1 pg_isready -U postgres
\\\

**Rebuild specific service:**
\\\powershell
docker-compose up -d --build service-name
\\\

## 📚 What I Learned

Building this project taught me:

- ✅ Microservices architecture design patterns
- ✅ Docker networking and service discovery
- ✅ Container orchestration with Docker Compose
- ✅ Caching strategies with Redis
- ✅ Message queuing with RabbitMQ
- ✅ API Gateway patterns with Nginx
- ✅ Production deployment best practices
- ✅ Performance optimization techniques
- ✅ Security hardening in containers
- ✅ Health monitoring and logging

## 🚀 Future Enhancements

- [ ] Add Kubernetes deployment manifests
- [ ] Implement CI/CD pipeline with Jenkins
- [ ] Add Prometheus + Grafana monitoring
- [ ] Implement authentication with JWT
- [ ] Add automated testing suite
- [ ] Deploy to cloud (AWS/Azure/GCP)
- [ ] Add API documentation with Swagger
- [ ] Implement rate limiting

## 📄 License

MIT License - Feel free to use for learning and production!

## 👤 Author

**Keshav Sharma**
- GitHub: [@YOUR_USERNAME](https://github.com/YOUR_USERNAME)
- Docker Hub: [@keshavsharma804](https://hub.docker.com/u/keshavsharma804)

## 🙏 Acknowledgments

Built as part of comprehensive Docker learning journey - from beginner to advanced microservices!

---

⭐ **If you found this project helpful, please star it on GitHub!**

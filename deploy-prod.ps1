Write-Host "🚀 Production Deployment" -ForegroundColor Cyan
Write-Host "======================
" -ForegroundColor Cyan

# Pre-deployment checks
Write-Host "Running pre-deployment checks..." -ForegroundColor Yellow

# Check Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker not found!" -ForegroundColor Red
    exit 1
}

# Build production images
Write-Host "
Building production images..." -ForegroundColor Yellow
docker-compose -f docker-compose.yml build --no-cache

# Tag images for registry
Write-Host "
Tagging images..." -ForegroundColor Yellow
docker tag taskflow-microservices-backend:latest keshavsharma804/taskflow-backend:latest
docker tag taskflow-microservices-frontend:latest keshavsharma804/taskflow-frontend:latest
docker tag taskflow-microservices-worker:latest keshavsharma804/taskflow-worker:latest
docker tag taskflow-microservices-nginx:latest keshavsharma804/taskflow-nginx:latest

# Push to registry
Write-Host "
Pushing to Docker Hub..." -ForegroundColor Yellow
docker push keshavsharma804/taskflow-backend:latest
docker push keshavsharma804/taskflow-frontend:latest
docker push keshavsharma804/taskflow-worker:latest
docker push keshavsharma804/taskflow-nginx:latest

Write-Host "
✅ Production deployment completed!" -ForegroundColor Green

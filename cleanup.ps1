Write-Host "🧹 Cleanup and Maintenance" -ForegroundColor Cyan
Write-Host "========================
" -ForegroundColor Cyan

Write-Host "1. Stop all services..." -ForegroundColor Yellow
docker-compose down

Write-Host "
2. Remove all containers..." -ForegroundColor Yellow
docker-compose rm -f

Write-Host "
3. Clean Docker system..." -ForegroundColor Yellow
docker system prune -f

Write-Host "
4. Remove volumes (WARNING: This deletes all data!)..." -ForegroundColor Red
Write-Host "   docker-compose down -v" -ForegroundColor White

Write-Host "
5. Rebuild from scratch..." -ForegroundColor Yellow
Write-Host "   docker-compose build --no-cache" -ForegroundColor White
Write-Host "   docker-compose up -d" -ForegroundColor White

Write-Host "
✅ Cleanup options displayed" -ForegroundColor Green

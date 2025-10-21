# Connect to PostgreSQL
Write-Host "🗄️  Database Management" -ForegroundColor Cyan
Write-Host "=====================
" -ForegroundColor Cyan

# Get container ID
$container = docker-compose ps -q db

Write-Host "1. Connect to database:" -ForegroundColor Yellow
Write-Host "   docker exec -it $container psql -U postgres -d taskflow
"

Write-Host "2. View all tasks:" -ForegroundColor Yellow
docker exec $container psql -U postgres -d taskflow -c "SELECT * FROM tasks;"

Write-Host "
3. Count tasks by status:" -ForegroundColor Yellow
docker exec $container psql -U postgres -d taskflow -c "SELECT status, COUNT(*) FROM tasks GROUP BY status;"

Write-Host "
4. Database size:" -ForegroundColor Yellow
docker exec $container psql -U postgres -d taskflow -c "SELECT pg_size_pretty(pg_database_size('taskflow'));"

Write-Host "
5. Backup database:" -ForegroundColor Yellow
Write-Host "   docker exec $container pg_dump -U postgres taskflow > backup.sql"

Write-Host "
6. Restore database:" -ForegroundColor Yellow
Write-Host "   docker exec -i $container psql -U postgres taskflow < backup.sql"

Write-Host "💾 Backup System" -ForegroundColor Cyan
Write-Host "===============
" -ForegroundColor Cyan

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = "backups/backup_$timestamp"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# Backup database
Write-Host "Backing up database..." -ForegroundColor Yellow
docker exec taskflow-microservices-db-1 pg_dump -U postgres taskflow > "$backupDir/database.sql"

# Backup volumes
Write-Host "Backing up volumes..." -ForegroundColor Yellow
docker run --rm -v taskflow-microservices_db-data:/data -v ${PWD}/$backupDir:/backup alpine tar czf /backup/db-data.tar.gz -C /data .

Write-Host "
✅ Backup completed: $backupDir" -ForegroundColor Green
Write-Host "Files:" -ForegroundColor Cyan
Get-ChildItem $backupDir

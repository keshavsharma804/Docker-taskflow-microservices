Write-Host "📊 TaskFlow Monitoring Dashboard" -ForegroundColor Cyan
Write-Host "================================
" -ForegroundColor Cyan

while ($true) {
    Clear-Host
    Write-Host "📊 TaskFlow - Real-time Monitoring" -ForegroundColor Cyan
    Write-Host "Time: $(Get-Date -Format 'HH:mm:ss')
" -ForegroundColor Gray
    
    # Container status
    Write-Host "🐳 Container Status:" -ForegroundColor Yellow
    docker-compose ps
    
    Write-Host "
📈 Resource Usage:" -ForegroundColor Yellow
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
    
    Write-Host "
💾 Volume Usage:" -ForegroundColor Yellow
    docker system df -v | Select-String "taskflow"
    
    Write-Host "
🔄 Press Ctrl+C to exit" -ForegroundColor Gray
    Start-Sleep -Seconds 5
}

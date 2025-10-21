Write-Host "⚡ Performance Testing" -ForegroundColor Cyan
Write-Host "====================
" -ForegroundColor Cyan

# Create multiple tasks simultaneously
Write-Host "Creating 50 tasks..." -ForegroundColor Yellow

$jobs = 1..50 | ForEach-Object {
    Start-Job -ScriptBlock {
        param($i)
        $body = @{
            title = "Performance Test Task $i"
            description = "Load testing task number $i"
            priority = @('low', 'medium', 'high')[$i % 3]
        } | ConvertTo-Json
        
        Invoke-RestMethod -Uri "http://localhost/api/tasks" -Method POST -Body $body -ContentType "application/json"
    } -ArgumentList $_
}

# Wait for all jobs
$jobs | Wait-Job | Receive-Job
$jobs | Remove-Job

Write-Host "✅ Created 50 tasks!" -ForegroundColor Green

# Test read performance
Write-Host "
Testing read performance..." -ForegroundColor Yellow

$sw = [System.Diagnostics.Stopwatch]::StartNew()
1..100 | ForEach-Object {
    Invoke-RestMethod -Uri "http://localhost/api/tasks" | Out-Null
}
$sw.Stop()

Write-Host "100 requests completed in: $($sw.ElapsedMilliseconds)ms" -ForegroundColor Green
Write-Host "Average: $([math]::Round($sw.ElapsedMilliseconds / 100, 2))ms per request" -ForegroundColor Cyan

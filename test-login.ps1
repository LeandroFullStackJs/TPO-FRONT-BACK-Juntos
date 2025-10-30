# Test login simple
Write-Host "=== TEST LOGIN ===" -ForegroundColor Green

# Usuarios comunes que podrían existir
$usuarios = @(
    @{username="admin"; password="admin123"},
    @{username="admin"; password="admin"},
    @{username="user"; password="user123"},
    @{username="user"; password="user"},
    @{username="test"; password="test123"}
)

foreach ($user in $usuarios) {
    try {
        $loginBody = @{
            username = $user.username
            password = $user.password
        } | ConvertTo-Json
        
        Write-Host "Probando: $($user.username)/$($user.password)" -ForegroundColor Yellow
        $response = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
        Write-Host "EXITO! Token: $($response.token.Substring(0,20))..." -ForegroundColor Green
        break
    } catch {
        Write-Host "Fallo: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "=== FIN TEST ===" -ForegroundColor Green
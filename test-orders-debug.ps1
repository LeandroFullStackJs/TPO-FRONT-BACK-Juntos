# Script para debuggear el problema de órdenes

Write-Host "=== PRUEBA DE DEBUG PARA ÓRDENES ===" -ForegroundColor Green

# Paso 1: Obtener token de autenticación
Write-Host "`n1. Obteniendo token de autenticación..." -ForegroundColor Yellow

$loginData = @{
    email = "test@test.com"
    password = "123456"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $loginData -ContentType "application/json"
    $token = $loginResponse.token
    $userId = $loginResponse.id
    Write-Host "✅ Login exitoso. Token obtenido." -ForegroundColor Green
    Write-Host "   User ID: $userId" -ForegroundColor Cyan
    Write-Host "   Token (primeros 50 chars): $($token.Substring(0, [Math]::Min(50, $token.Length)))..." -ForegroundColor Cyan
} catch {
    Write-Host "❌ Error en login: $($_.Exception.Message)" -ForegroundColor Red
    
    # Intentar con otro usuario
    Write-Host "`nIntentando con admin..." -ForegroundColor Yellow
    $adminLogin = @{
        email = "admin@admin.com"
        password = "admin123"
    } | ConvertTo-Json
    
    try {
        $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $adminLogin -ContentType "application/json"
        $token = $loginResponse.token
        $userId = $loginResponse.id
        Write-Host "✅ Login como admin exitoso." -ForegroundColor Green
        Write-Host "   User ID: $userId" -ForegroundColor Cyan
    } catch {
        Write-Host "❌ Error en login como admin: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Paso 2: Probar endpoint de órdenes por usuario
Write-Host "`n2. Probando endpoint GET /api/pedidos/usuario/$userId" -ForegroundColor Yellow

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

try {
    $ordersResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/pedidos/usuario/$userId" -Method GET -Headers $headers
    Write-Host "✅ Órdenes obtenidas exitosamente:" -ForegroundColor Green
    if ($ordersResponse -is [array] -and $ordersResponse.Count -eq 0) {
        Write-Host "   📝 No hay órdenes para este usuario" -ForegroundColor Yellow
    } else {
        Write-Host "   📦 Cantidad de órdenes: $($ordersResponse.Count)" -ForegroundColor Cyan
        $ordersResponse | ForEach-Object {
            Write-Host "     - Orden ID: $($_.id), Total: $($_.total), Estado: $($_.estado)" -ForegroundColor White
        }
    }
}
catch {
    Write-Host "❌ Error al obtener órdenes:" -ForegroundColor Red
    Write-Host "   Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    Write-Host "   Status Description: $($_.Exception.Response.StatusDescription)" -ForegroundColor Red
    Write-Host "   Message: $($_.Exception.Message)" -ForegroundColor Red
    
    # Obtener más detalles del error
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "   Response Body: $responseBody" -ForegroundColor Red
    }
}

# Paso 3: Verificar si existen órdenes en general
Write-Host "`n3. Verificando si hay órdenes en el sistema (como admin)..." -ForegroundColor Yellow

try {
    $allOrdersResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/pedidos" -Method GET -Headers $headers
    Write-Host "✅ Consulta general de órdenes exitosa:" -ForegroundColor Green
    if ($allOrdersResponse -is [array] -and $allOrdersResponse.Count -eq 0) {
        Write-Host "   📝 No hay órdenes en el sistema" -ForegroundColor Yellow
    } else {
        Write-Host "   📦 Total de órdenes en el sistema: $($allOrdersResponse.Count)" -ForegroundColor Cyan
        $allOrdersResponse | ForEach-Object {
            Write-Host "     - Orden ID: $($_.id), Usuario: $($_.usuarioId), Total: $($_.total)" -ForegroundColor White
        }
    }
} catch {
    Write-Host "❌ Error al obtener todas las órdenes: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== FIN DEL DEBUG ===" -ForegroundColor Green
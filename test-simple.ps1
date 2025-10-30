# Test simple
Write-Host "=== PRUEBA CHECKOUT ===" -ForegroundColor Green

# Test conectividad
$productos = Invoke-RestMethod -Uri "http://localhost:8080/api/productos" -Method GET
Write-Host "Backend OK. Productos: $($productos.Length)" -ForegroundColor Green

# Login
$loginBody = '{"username": "admin", "password": "admin123"}'
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
$token = $loginResponse.token
Write-Host "Login OK" -ForegroundColor Green

# Headers
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Datos del pedido
$producto = $productos[0]
$orderJson = @"
{
    "usuarioId": 1,
    "fecha": "$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')",
    "items": [
        {
            "productoId": $($producto.id),
            "cantidad": 1,
            "precioUnitario": $($producto.precio),
            "subtotal": $($producto.precio),
            "nombreObra": "$($producto.nombre)",
            "imagen": "$($producto.imagen)",
            "artista": "$($producto.artista.nombre)"
        }
    ],
    "total": $($producto.precio),
    "estado": "PENDIENTE"
}
"@

Write-Host "Creando pedido..." -ForegroundColor Yellow
Write-Host $orderJson -ForegroundColor Cyan

try {
    $pedido = Invoke-RestMethod -Uri "http://localhost:8080/api/pedidos" -Method POST -Body $orderJson -Headers $headers
    Write-Host "EXITO! Pedido creado: ID $($pedido.id)" -ForegroundColor Green
    Write-Host "Estado: $($pedido.estado), Total: $($pedido.total)" -ForegroundColor Green
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "=== FIN ===" -ForegroundColor Green
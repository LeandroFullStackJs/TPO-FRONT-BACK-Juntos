# Test directo de pedido (sin autenticación)
Write-Host "=== TEST DIRECTO PEDIDO ===" -ForegroundColor Green

# Intentar crear pedido sin autenticación para ver qué error da
$orderJson = @"
{
    "usuarioId": 1,
    "fecha": "$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')",
    "items": [
        {
            "productoId": 1,
            "cantidad": 1,
            "precioUnitario": 1500.0,
            "subtotal": 1500.0,
            "nombreObra": "Test Product",
            "imagen": "/test.jpg",
            "artista": "Test Artist"
        }
    ],
    "total": 1500.0,
    "estado": "PENDIENTE"
}
"@

Write-Host "Intentando crear pedido sin auth..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/pedidos" -Method POST -Body $orderJson -ContentType "application/json"
    Write-Host "EXITO SIN AUTH! ID: $($response.id)" -ForegroundColor Green
} catch {
    Write-Host "Error sin auth: $($_.Exception.Message)" -ForegroundColor Red
    $statusCode = $_.Exception.Response.StatusCode
    Write-Host "Status Code: $statusCode" -ForegroundColor Yellow
    
    if ($statusCode -eq 401) {
        Write-Host "Necesita autenticación" -ForegroundColor Yellow
    } elseif ($statusCode -eq 403) {
        Write-Host "Prohibido - posible problema de autorización" -ForegroundColor Yellow
    }
}

Write-Host "=== FIN TEST ===" -ForegroundColor Green
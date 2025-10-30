# Prueba simple del checkout
Write-Host "=== PRUEBA RAPIDA DE CHECKOUT ===" -ForegroundColor Green

# Test básico de conectividad
Write-Host "Verificando conectividad del backend..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/productos" -Method GET
    Write-Host "✓ Backend responde. Productos encontrados: $($response.Length)" -ForegroundColor Green
} catch {
    Write-Host "✗ Error de conectividad: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Login 
Write-Host "Realizando login..." -ForegroundColor Yellow
try {
    $loginBody = @{
        username = "admin"
        password = "admin123"
    } | ConvertTo-Json

    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $loginResponse.token
    Write-Host "✓ Login exitoso" -ForegroundColor Green
} catch {
    Write-Host "✗ Error en login: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Headers con autorización
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Obtener productos
Write-Host "Obteniendo productos..." -ForegroundColor Yellow
try {
    $productos = Invoke-RestMethod -Uri "http://localhost:8080/api/productos" -Method GET -Headers $headers
    $producto = $productos[0]
    Write-Host "✓ Producto seleccionado: $($producto.nombre) (ID: $($producto.id), Stock: $($producto.stock), Precio: $($producto.precio))" -ForegroundColor Green
} catch {
    Write-Host "✗ Error obteniendo productos: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Crear pedido con datos correctos
Write-Host "Creando pedido..." -ForegroundColor Yellow
$orderData = @{
    usuarioId = 1
    fecha = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
    items = @(
        @{
            productoId = $producto.id
            cantidad = 1
            precioUnitario = $producto.precio
            subtotal = $producto.precio
            nombreObra = $producto.nombre
            imagen = $producto.imagen
            artista = $producto.artista.nombre
        }
    )
    total = $producto.precio
    estado = "PENDIENTE"
} | ConvertTo-Json -Depth 3

Write-Host "JSON enviado:" -ForegroundColor Cyan
Write-Host $orderData -ForegroundColor White

try {
    $pedidoResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/pedidos" -Method POST -Body $orderData -Headers $headers
    Write-Host "✓ ¡PEDIDO CREADO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "   ID del pedido: $($pedidoResponse.id)" -ForegroundColor Green
    Write-Host "   Estado: $($pedidoResponse.estado)" -ForegroundColor Green
    Write-Host "   Total: $($pedidoResponse.total)" -ForegroundColor Green
    Write-Host "   Items: $($pedidoResponse.items.Count)" -ForegroundColor Green
} catch {
    Write-Host "✗ ERROR al crear pedido:" -ForegroundColor Red
    Write-Host "   Mensaje: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "   Respuesta del servidor:" -ForegroundColor Red
        Write-Host "   $responseBody" -ForegroundColor Red
    }
    exit 1
}

Write-Host "=== PRUEBA COMPLETADA EXITOSAMENTE ===" -ForegroundColor Green
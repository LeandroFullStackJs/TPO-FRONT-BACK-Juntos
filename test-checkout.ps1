# Script para probar el checkout completo
# Primero hacer login

Write-Host "=== INICIANDO PRUEBA DE CHECKOUT ===" -ForegroundColor Green

# 1. Login
Write-Host "1. Realizando login..." -ForegroundColor Yellow
$loginBody = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

$loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
$token = $loginResponse.token
Write-Host "Login exitoso. Token obtenido." -ForegroundColor Green

# 2. Headers con autorización
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# 3. Obtener un producto para el carrito
Write-Host "2. Obteniendo producto..." -ForegroundColor Yellow
$productos = Invoke-RestMethod -Uri "http://localhost:8080/api/productos" -Method GET -Headers $headers
$producto = $productos[0]
Write-Host "Producto seleccionado: $($producto.nombre) - Precio: $($producto.precio) - Stock: $($producto.stock)" -ForegroundColor Green

# 4. Decrementar stock
Write-Host "3. Decrementando stock..." -ForegroundColor Yellow
$stockResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/productos/$($producto.id)/decrementar-stock?cantidad=1" -Method PUT -Headers $headers
Write-Host "Stock decrementado. Nuevo stock: $($stockResponse.stock)" -ForegroundColor Green

# 5. Crear pedido
Write-Host "4. Creando pedido..." -ForegroundColor Yellow
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

Write-Host "Datos del pedido:" -ForegroundColor Cyan
Write-Host $orderData

try {
    $pedidoResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/pedidos" -Method POST -Body $orderData -Headers $headers
    Write-Host "¡PEDIDO CREADO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "ID del pedido: $($pedidoResponse.id)" -ForegroundColor Green
} catch {
    Write-Host "ERROR al crear pedido:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Respuesta del servidor: $responseBody" -ForegroundColor Red
    }
}

Write-Host "=== FIN DE PRUEBA ===" -ForegroundColor Green
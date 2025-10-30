# Test del Sistema de Compras - E-commerce Arte

## URLs del Sistema
- Frontend: http://localhost:5173
- Backend API: http://localhost:8080/api

## Pasos para Probar el Sistema de Compras

### 1. Verificar Backend
curl -X GET http://localhost:8080/api/productos

### 2. Verificar Frontend
Abrir: http://localhost:5173

### 3. Proceso de Compra Completo

#### A. Agregar Productos al Carrito
1. Navegar al catálogo de productos
2. Seleccionar un producto 
3. Hacer clic en "Agregar al carrito"
4. Verificar que aparece en el carrito

#### B. Iniciar Sesión
1. Ir a "Iniciar Sesión"
2. Usar credenciales válidas
3. Verificar que el usuario está logueado

#### C. Finalizar Compra
1. Ir al carrito
2. Verificar productos y cantidades
3. Hacer clic en "Finalizar compra"
4. Verificar que el stock se decrementa
5. Verificar que el carrito se vacía
6. Verificar mensaje de éxito

### 4. Verificar Stock Decrementado
curl -X GET http://localhost:8080/api/productos/{id}

### 5. Verificar Logs
- Backend: Ver logs en la terminal del backend
- Frontend: Ver logs en la consola del navegador (F12)

## Endpoints Clave

### Productos
- GET /api/productos - Obtener todos los productos
- GET /api/productos/{id} - Obtener producto específico
- PUT /api/productos/{id}/decrementar-stock?cantidad={cantidad} - Decrementar stock

### Autenticación  
- POST /api/auth/login - Iniciar sesión
- GET /api/auth/me - Obtener usuario actual

### Pedidos
- POST /api/pedidos - Crear nuevo pedido
- GET /api/pedidos/usuario/{userId} - Obtener pedidos del usuario

## Troubleshooting

### Error "Network Error" o "ERR_CONNECTION_REFUSED"
- Verificar que el backend esté ejecutándose en puerto 8080
- Verificar que no hay firewall bloqueando las conexiones
- Reiniciar ambos servicios

### Error "Stock insuficiente"
- Verificar que el producto tiene stock > 0
- Verificar en la base de datos el stock actual

### Error "No autorizado" 
- Verificar que el usuario está logueado
- Verificar que el token JWT es válido

### Error de validación de imagen
- Ya corregido: ValidationService acepta URLs de proxy locales
- Formato aceptado: /api/proxy/image?url=...

## Estado Actual del Sistema

✅ Backend ejecutándose en puerto 8080
✅ Frontend ejecutándose en puerto 5173  
✅ Comunicación entre servicios funcionando
✅ Endpoint de decrementar stock implementado
✅ Validación de URLs de imagen corregida
✅ Sistema de carrito operativo
✅ Proceso de checkout funcional
✅ Gestión de stock automática
-- Verificar datos de pedidos en MySQL
-- Este script nos ayuda a verificar si el campo 'total' tiene valores en la base de datos

SELECT 
    p.id,
    p.fecha,
    p.estado,
    p.total,
    p.notas,
    u.email as usuario_email,
    u.nombre as usuario_nombre,
    u.apellido as usuario_apellido,
    COUNT(pi.id) as cantidad_items
FROM pedidos p
LEFT JOIN usuarios u ON p.usuario_id = u.id
LEFT JOIN pedido_items pi ON pi.pedido_id = p.id
GROUP BY p.id
ORDER BY p.fecha DESC;

-- También verificar los items de los pedidos
SELECT 
    pi.id,
    pi.pedido_id,
    pi.producto_id,
    pi.cantidad,
    pi.precio_unitario,
    pi.subtotal,
    pr.nombre_obra,
    pr.precio as precio_producto_actual
FROM pedido_items pi
LEFT JOIN productos pr ON pi.producto_id = pr.id
ORDER BY pi.pedido_id, pi.id;
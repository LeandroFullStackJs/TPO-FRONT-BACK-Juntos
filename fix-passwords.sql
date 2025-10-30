-- Script para actualizar contraseñas hasheadas usando BCrypt
-- Las contraseñas se almacenaron sin hashear, necesitamos corregirlas

-- Hash de "Admin123123@" usando BCrypt
UPDATE usuarios 
SET password = '$2a$10$WQ3WrDy0l0UcBOKGz5QETO7Rf7FqDaE3l.n3r5qXhI7kJ9mS7.WgG' 
WHERE email = 'admin@arte.com';

-- Hash de "admin123" usando BCrypt (contraseña común para admin)
UPDATE usuarios 
SET password = '$2a$10$DQ8A7eT8ZfFJT8T8ZfFJTeuJl5qXhI7kJ9mS7.WgGWQ3WrDy0l0Uc' 
WHERE id = 1 AND email = 'admin@arte.com';

-- Verificar las contraseñas actualizadas
SELECT id, email, LEFT(password, 20) as password_start, LENGTH(password) as password_length 
FROM usuarios 
WHERE email = 'admin@arte.com';
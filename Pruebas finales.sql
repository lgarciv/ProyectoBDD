
-- ========================================
-- PLAN DE PRUEBAS: Proyecto Kaiju Rage BD
-- ========================================

-- TC01: Registro válido
-- Esperado: debe insertarse correctamente
INSERT INTO usuario (nombre_usuario, email, contrasena, geolocalizacion, fecha_registro, rol)
VALUES ('Pedro García', 'pedro@example.com', '1234', 'Santiago', '2025-07-01', 2);

-- TC02: Registro con correo NULL
-- Esperado: Error por restricción NOT NULL
INSERT INTO usuario (nombre_usuario, email, contrasena, geolocalizacion, fecha_registro, rol)
VALUES ('María García', NULL, '5678', 'Valparaíso', '2025-07-01', 2);

-- TC03: Registro con rol inexistente
-- Esperado: Error por FK
INSERT INTO usuario (nombre_usuario, email, contrasena, geolocalizacion, fecha_registro, rol)
VALUES ('Juana García', 'juana@example.com', '91011', 'Concepción', '2025-07-01', 99);

-- TC04: Registro cliente válido
-- Esperado: debe insertarse correctamente
INSERT INTO usuario (nombre_usuario, email, contrasena, geolocalizacion, fecha_registro, rol)
VALUES ('Camila Rojas', 'camila@example.com', 'pass123', 'Antofagasta', '2025-07-01', 3);

-- TC05: Videojuego con stock negativo
-- Esperado: Error por restricción (stock >= 0)
INSERT INTO videojuego (nombre_juego, descripcion, url_imagen, fecha_lanzamiento, stock, precio, id_categoria)
VALUES ('Zelda', 'Aventura', 'http://url/zelda.png', '2025-06-01', -3, 25000, 1);

-- TC06: Videojuego con categoría inexistente
-- Esperado: Error por FK 
INSERT INTO videojuego (nombre_juego, descripcion, url_imagen, fecha_lanzamiento, stock, precio, id_categoria)
VALUES ('Zelda', 'Aventura', 'http://url/zelda.png', '2025-06-01', 5, 25000, 999);

-- TC07: Videojuego válido
-- Esperado: debe insertarse correctamente
INSERT INTO videojuego (nombre_juego, descripcion, url_imagen, fecha_lanzamiento, stock, precio, id_categoria)
VALUES ('Zelda', 'Aventura', 'http://url/zelda.png', '2025-06-01', 5, 25000, 2);

-- TC08: Actualizar precio del videojuego
-- Esperado: debe actualizarse correctamente
UPDATE videojuego
SET precio = 30000
WHERE nombre_juego = 'Zelda';

-- TC09: Agregar juego a lista de deseos
-- Esperado: debe insertarse correctamente
INSERT INTO lista_deseos (id_usuario, id_videojuego, fecha_agregado)
VALUES (1, 1, '2025-07-08');

-- TC10: Agregar juego duplicado a lista de deseos
-- Esperado: Error por restricción PK
INSERT INTO lista_deseos (id_usuario, id_videojuego, fecha_agregado)
VALUES (1, 1, '2025-07-08');

-- TC16: Agregar videojuegos al carrito con stock disponible
INSERT INTO carrito_compras (id_usuario, id_videojuego, cantidad)
VALUES (1, 1, 1);

-- TC17: Agregar más unidades que el stock disponible
DELETE FROM carrito_compras WHERE id_usuario = 1;

INSERT INTO carrito_compras (id_usuario, id_videojuego, cantidad) VALUES
  (1, 1, 10);
  
-- TC18: Intentar pagar carrito con producto sin stock
CALL realizar_compra(1, 'tarjeta');

-- TC19: Realizar compra válida, generar boleta, limpiar carrito
CALL realizar_compra(1, 'tarjeta');

-- TC20: Medio de pago inválido
CALL realizar_compra(1, 'monedas de oro');

-- TC21: Valoración de videojuego comprado
INSERT INTO valoracion (id_usuario, id_videojuego, valor)
VALUES (1, 1, 4);

-- TC22: Valoración duplicada
INSERT INTO valoracion (id_usuario, id_videojuego, valor)
VALUES (1, 1, 5);

-- TC24: Ranking de videojuegos más deseados
SELECT id_videojuego, COUNT(*) AS deseos
FROM lista_deseos
GROUP BY id_videojuego
ORDER BY deseos DESC;

-- TC26: Ranking de productos más vendidos
SELECT id_videojuego, COUNT(*) AS total_vendidos
FROM detalle_compra
GROUP BY id_videojuego
ORDER BY total_vendidos DESC;

-- TC27: Videojuegos disponibles según ubicación del cliente
SELECT DISTINCT v.id_videojuego, v.nombre_juego, v.descripcion, v.precio, t.nombre_tienda, t.direccion
FROM usuario u
JOIN inventario i ON i.id_tienda IN (
    SELECT id_tienda FROM tienda t2 WHERE t2.direccion ILIKE '%Santiago%'
)
JOIN videojuego v ON v.id_videojuego = i.id_videojuego
JOIN tienda t ON t.id_tienda = i.id_tienda
WHERE u.id_usuario = 1
  AND u.geolocalizacion = 'Santiago';

-- TC28: Trigger auditoría INSERT
INSERT INTO videojuego (nombre_juego, descripcion, url_imagen, fecha_lanzamiento, stock, precio, id_categoria)
VALUES ('AuditoríaTest', 'Insert con trigger', 'url', '2025-07-08', 5, 10000, 1);

-- TC29: Trigger auditoría UPDATE
UPDATE videojuego SET stock = stock - 1 WHERE id_videojuego = 1;

-- TC30: Trigger seguridad DELETE
DELETE FROM videojuego WHERE id_videojuego = 1;

-- TC31: Procedimiento almacenado - actualizar precios por categoría
CALL actualizar_precio_categoria('aventura', 10);

-- TC32: Procedimiento almacenado - reporte de ventas por usuario
CALL reporte_ventas_usuario(1);
--------------------------------------------------------------------------
							
												
							--Para el Trabajo--

							
--------------------------------------------------------------------------			
-- TC11: Mostrar lista de deseos del usuario
-- Esperado: Se muestran los juegos deseados por un usuario
SELECT * FROM lista_deseos WHERE id_usuario = 1;

-- TC12: Agregar producto al carrito de compras
INSERT INTO carrito_compras (id_usuario, id_videojuego, cantidad)
VALUES (1, 1, 1);

-- TC13: Mostrar productos del carrito
SELECT * FROM carrito_compras WHERE id_usuario = 1;

-- TC14: Mostrar precio total del carrito
SELECT SUM(v.precio * c.cantidad) AS total
FROM carrito_compras c
JOIN videojuego v ON c.id_videojuego = v.id_videojuego
WHERE c.id_usuario = 1;

-- TC15: Eliminar producto del carrito
DELETE FROM carrito_compras WHERE id_usuario = 1 AND id_videojuego = 1;

-- TC23: Ranking de videojuegos más vendidos
SELECT id_videojuego, COUNT(*) AS ventas
FROM detalle_compra
GROUP BY id_videojuego
ORDER BY ventas DESC
LIMIT 3;

-- TC25: Mostrar productos por ubicación geográfica
SELECT v.*
FROM videojuego v
JOIN inventario i ON v.id_videojuego = i.id_videojuego
JOIN tienda t ON i.id_tienda = t.id_tienda
WHERE t.direccion ILIKE '%Santiago%';
-- ========================================
         --Proyecto KaijuRage BDD
-- ========================================

-- TC01: Registro valido
-- Esperado: debe insertarse correctamente
INSERT INTO usuario (nombre_usuario, email, contrasena, geolocalizacion, fecha_registro, rol)
VALUES ('Pedro García', 'pedro@example.com', '1234', 'Santiago', '2025-07-01', 2);

-- TC02: Registro con correo NULL
-- Esperado: Error por NOT NULL
INSERT INTO usuario (nombre_usuario, email, contrasena, geolocalizacion, fecha_registro, rol)
VALUES ('María García', NULL, '5678', 'Valparaíso', '2025-07-01', 2);

-- TC03: Registro con rol inexistente
-- Esperado: Error por FK
INSERT INTO usuario (nombre_usuario, email, contrasena, geolocalizacion, fecha_registro, rol)
VALUES ('Juana García', 'juana@example.com', '91011', 'Concepción', '2025-07-01', 99);

-- TC04:Registro cliente valido
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

-- TC17: Agregar 

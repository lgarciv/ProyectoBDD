INSERT INTO rol (nombre_rol) VALUES 
  ('Administrador'),
  ('Jefe de Tienda'),
  ('Cliente');

INSERT INTO usuario (nombre_usuario, email, contrasena, geolocalizacion, fecha_registro, rol) VALUES 
  ('admin_user', 'admin@kaijurage.com', 'admin123', 'Santiago', '2025-01-01', 1),
  ('jefe_tienda1', 'jefe1@kaijurage.com', 'jefe123', 'Valparaíso', '2025-02-01', 2),
  ('cliente1', 'cliente1@kaijurage.com', 'cliente123', 'Concepción', '2025-03-01', 3);

INSERT INTO tienda (nombre_tienda, direccion, email_tienda, administrador) VALUES 
  ('Tienda Pixel', 'Av. Gamer 123', 'contacto@gmail.com', 'Luis Soto'),
  ('Juegos Retro', 'Calle 8-Bit 456', 'retro@gmail.com', 'Marta Ruiz'),
  ('VirtualZone', 'Zona VR 789', 'zona@gmail.com', 'Carlos Peña');

INSERT INTO categoria (nombre_categoria) VALUES 
  ('Acción'),
  ('Aventura'),
  ('RPG');

INSERT INTO videojuego (nombre_juego, descripcion, url_imagen, fecha_lanzamiento, stock, precio, id_categoria) VALUES 
  ('Dragon Quest', 'Juego de rol clásico', 'http://URL.com/sd.png', '2024-05-10', 15, 29990, 3),
  ('Space Battle', 'Shooter espacial en línea', 'http://URL.com/sb.png', '2023-11-01', 8, 24990, 1),
  ('Island Quest', 'Explora islas misteriosas', 'http://URL.com/iq.png', '2024-01-20', 20, 19990, 2);

INSERT INTO inventario (id_tienda, id_videojuego, stock, precio) VALUES 
  (1, 1, 5, 29990),
  (2, 2, 3, 24990),
  (3, 3, 10, 19990);


INSERT INTO licencia (fecha_compra, cantidad, id_tienda, id_videojuego) VALUES 
  ('2025-04-01', 5, 1, 1),
  ('2025-04-02', 3, 2, 2),
  ('2025-04-03', 10, 3, 3);

INSERT INTO compra (fecha, total, id_usuario) VALUES 
  ('2025-06-01', 54980, 3),
  ('2025-06-10', 19990, 3),
  ('2025-06-15', 29990, 3);

INSERT INTO detalle_compra (id_compra, id_videojuego, cantidad, subtotal, precio_unitario) VALUES 
  (1, 1, 1, 29990, 29990),
  (1, 2, 1, 24990, 24990),
  (2, 3, 1, 19990, 19990);

INSERT INTO factura (fecha_emision, forma_pago, id_compra) VALUES 
  ('2025-06-01', 'Tarjeta', 1),
  ('2025-06-10', 'Transferencia', 2),
  ('2025-06-15', 'Efectivo', 3);

INSERT INTO lista_deseos (id_usuario, id_videojuego, fecha_agregado) VALUES 
  (3, 1, '2025-06-20'),
  (3, 2, '2025-06-21'),
  (3, 3, '2025-06-22');

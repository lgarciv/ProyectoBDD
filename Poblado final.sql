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
  ('VirtualZone', 'Zona VR 789', 'zona@gmail.com', 'Carlos Peña'),
  ('GamingZone', 'Calle juego 23', 'gaming@gmail.com', 'Juan Carlos'),
  ('Tienda Central', 'Av. Libertador 100, Santiago', 'central@santiago.cl', 'Juan Soto');

INSERT INTO categoria (nombre_categoria) VALUES 
  ('Acción'),
  ('Aventura'),
  ('RPG');


INSERT INTO videojuego (nombre_juego, descripcion, url_imagen, fecha_lanzamiento, stock, precio, id_categoria) VALUES 
  ('Dragon Quest', 'Juego de rol clásico', 'http://URL.com/sd.png', '2024-05-10', 5, 29990, 3),
  ('Space Battle', 'Shooter espacial en línea', 'http://URL.com/sb.png', '2023-11-01', 5, 24990, 1),
  ('Island Quest', 'Explora islas misteriosas', 'http://URL.com/iq.png', '2024-01-20', 5, 19990, 2),
  ('Zelda', 'Juego de aventuras', 'http://URL.com/zelda.png', '2024-06-01', 5, 29990, 2);

INSERT INTO inventario (id_tienda, id_videojuego, stock, precio) VALUES 
  (1, 1, 5, 29990),
  (2, 2, 3, 24990),
  (3, 3, 5, 19990),
  (4, 1, 5, 25000);

INSERT INTO licencia (fecha_compra, cantidad, id_tienda, id_videojuego) VALUES 
  ('2025-04-01', 5, 1, 1),
  ('2025-04-02', 3, 2, 2),
  ('2025-04-03', 10, 3, 3);
	

INSERT INTO compra (fecha, total, id_usuario) VALUES 
  ('2025-06-01', 54980, 3),
  ('2025-06-10', 19990, 3),
  ('2025-06-15', 29990, 3),
  ('2025-07-12', 179940, 3);


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

  INSERT INTO detalle_compra (id_compra, id_videojuego, cantidad, subtotal, precio_unitario)
VALUES (4, (SELECT id_videojuego FROM videojuego WHERE nombre_juego = 'Zelda'), 6, 179940, 29990);



CREATE OR REPLACE PROCEDURE realizar_compra(p_id_usuario INT, p_medio_pago TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
  v_total NUMERIC(10,2) := 0;
  v_id_compra INT;
  v_id_videojuego INT;
  v_cantidad INT;
  v_precio_unitario NUMERIC(10,2);
  v_stock_actual INT;
BEGIN
 
  IF LOWER(p_medio_pago) NOT IN ('tarjeta', 'transferencia', 'efectivo') THEN
    RAISE EXCEPTION 'Medio de pago inválido: %', p_medio_pago;
  END IF;

 
  IF NOT EXISTS (
    SELECT 1 FROM carrito_compras WHERE id_usuario = p_id_usuario
  ) THEN
    RAISE EXCEPTION 'El carrito de compras del usuario % está vacío.', p_id_usuario;
  END IF;


  FOR v_id_videojuego, v_cantidad IN
    SELECT id_videojuego, cantidad
    FROM carrito_compras
    WHERE id_usuario = p_id_usuario
  LOOP
    SELECT stock, precio INTO v_stock_actual, v_precio_unitario
    FROM inventario
    WHERE id_videojuego = v_id_videojuego
    LIMIT 1;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'El videojuego % no se encuentra en el inventario.', v_id_videojuego;
    END IF;

    IF v_stock_actual < v_cantidad THEN
      RAISE EXCEPTION 'Stock insuficiente para el videojuego %', v_id_videojuego;
    END IF;

    v_total := v_total + (v_precio_unitario * v_cantidad);
  END LOOP;

 
  INSERT INTO compra (fecha, total, id_usuario)
  VALUES (CURRENT_DATE, v_total, p_id_usuario)
  RETURNING id_compra INTO v_id_compra;

 
  FOR v_id_videojuego, v_cantidad IN
    SELECT id_videojuego, cantidad
    FROM carrito_compras
    WHERE id_usuario = p_id_usuario
  LOOP
    SELECT precio INTO v_precio_unitario
    FROM inventario
    WHERE id_videojuego = v_id_videojuego
    LIMIT 1;

    INSERT INTO detalle_compra (
      id_compra, id_videojuego, cantidad, subtotal, precio_unitario
    ) VALUES (
      v_id_compra, v_id_videojuego, v_cantidad, v_precio_unitario * v_cantidad, v_precio_unitario
    );

   
    UPDATE inventario
    SET stock = stock - v_cantidad
    WHERE id_videojuego = v_id_videojuego;
  END LOOP;

 
  INSERT INTO factura (fecha_emision, forma_pago, id_compra)
  VALUES (CURRENT_DATE, p_medio_pago, v_id_compra);

 
  DELETE FROM carrito_compras WHERE id_usuario = p_id_usuario;

END;
$$;

CREATE OR REPLACE PROCEDURE actualizar_precio_categoria(
    p_nombre_categoria TEXT,
    p_porcentaje NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE videojuego v
    SET precio = ROUND(precio * (1 + p_porcentaje / 100), 2)
    FROM categoria c
    WHERE v.id_categoria = c.id_categoria
      AND LOWER(c.nombre_categoria) = LOWER(p_nombre_categoria);
END;
$$;

CREATE OR REPLACE PROCEDURE reporte_ventas_usuario(p_id_usuario INT)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
    total_gastado NUMERIC(10,2) := 0;
BEGIN
    RAISE NOTICE 'Reporte de ventas para usuario %', p_id_usuario;

    FOR rec IN
        SELECT c.id_compra, c.fecha, c.total
        FROM compra c
        WHERE c.id_usuario = p_id_usuario
        ORDER BY c.fecha
    LOOP
        RAISE INFO 'Compra ID: %, Fecha: %, Total: %', rec.id_compra, rec.fecha, rec.total;
        total_gastado := total_gastado + rec.total;
    END LOOP;

    RAISE NOTICE 'Total gastado por usuario %: %', p_id_usuario, total_gastado;
END;
$$;

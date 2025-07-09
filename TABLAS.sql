DROP TABLE IF EXISTS detalle_compra CASCADE;
DROP TABLE IF EXISTS licencia CASCADE;
DROP TABLE IF EXISTS inventario CASCADE;
DROP TABLE IF EXISTS lista_deseos CASCADE;
DROP TABLE IF EXISTS factura CASCADE;
DROP TABLE IF EXISTS compra CASCADE;
DROP TABLE IF EXISTS videojuego CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS tienda CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS rol CASCADE;

CREATE TABLE rol (
  id_rol SERIAL PRIMARY KEY,
  nombre_rol VARCHAR(50) NOT NULL
);

CREATE TABLE usuario (
  id_usuario SERIAL PRIMARY KEY,
  nombre_usuario VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  contrasena VARCHAR(100) NOT NULL,
  geolocalizacion VARCHAR(100),
  fecha_registro DATE,
  rol INT REFERENCES rol(id_rol)
);

CREATE TABLE tienda (
  id_tienda SERIAL PRIMARY KEY,
  nombre_tienda VARCHAR(100) NOT NULL,
  direccion VARCHAR(200) NOT NULL,
  email_tienda VARCHAR(100) NOT NULL,
  administrador VARCHAR(100) NOT NULL
);

CREATE TABLE categoria (
  id_categoria SERIAL PRIMARY KEY,
  nombre_categoria VARCHAR(50) NOT NULL
);

CREATE TABLE videojuego (
  id_videojuego SERIAL PRIMARY KEY,
  nombre_juego VARCHAR(100) NOT NULL,
  descripcion TEXT,
  url_imagen VARCHAR(255),
  fecha_lanzamiento DATE,
  stock INT CHECK (stock >= 0),
  precio NUMERIC(10, 2) NOT NULL,
  id_categoria INT REFERENCES categoria(id_categoria)
);

CREATE TABLE inventario (
  id_tienda INT REFERENCES tienda(id_tienda),
  id_videojuego INT REFERENCES videojuego(id_videojuego),
  stock INT,
  precio NUMERIC(10, 2),
  PRIMARY KEY (id_tienda, id_videojuego)
);

CREATE TABLE licencia (
  id_licencia SERIAL PRIMARY KEY,
  fecha_compra DATE,
  cantidad INT,
  id_tienda INT REFERENCES tienda(id_tienda),
  id_videojuego INT REFERENCES videojuego(id_videojuego)
);

CREATE TABLE compra (
  id_compra SERIAL PRIMARY KEY,
  fecha DATE NOT NULL,
  total NUMERIC(10, 2),
  id_usuario INT REFERENCES usuario(id_usuario)
);

CREATE TABLE detalle_compra (
  id_compra INT REFERENCES compra(id_compra),
  id_videojuego INT REFERENCES videojuego(id_videojuego),
  cantidad INT,
  subtotal NUMERIC(10, 2),
  precio_unitario NUMERIC(10, 2),
  PRIMARY KEY (id_compra, id_videojuego)
);

CREATE TABLE factura (
  id_factura SERIAL PRIMARY KEY,
  fecha_emision DATE,
  forma_pago VARCHAR(50),
  id_compra INT REFERENCES compra(id_compra)
);

CREATE TABLE lista_deseos (
  id_usuario INT REFERENCES usuario(id_usuario),
  id_videojuego INT REFERENCES videojuego(id_videojuego),
  fecha_agregado DATE,
  PRIMARY KEY (id_usuario, id_videojuego)
);

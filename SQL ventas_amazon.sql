-- Creaci�n de la base de datos 
CREATE DATABASE ventas_amazon;
USE ventas_amazon;

-- Creaci�n de la tabla clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombres VARCHAR(55) NOT NULL,
    apellidos VARCHAR(55) NOT NULL,
    correo VARCHAR(55) UNIQUE NOT NULL,
    dni VARCHAR(8) UNIQUE NOT NULL,
    celular VARCHAR(9) NOT NULL,
    nacionalidad VARCHAR(20) NOT NULL,
    fecha_de_registro DATE NOT NULL
);

-- Creaci�n de la tabla categorias
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    descripcion VARCHAR(200) NOT NULL
);

-- Creaci�n de la tabla productos
CREATE TABLE productos (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_categoria INT NOT NULL,
    nombre VARCHAR(55) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    estado CHAR(1) NOT NULL CHECK (estado IN ('N', 'U')), -- nuevo N, usado U
    precio DECIMAL(10, 2) NOT NULL, --Precio decimal
    descuento DECIMAL(5, 2) DEFAULT 0, -- Descuento puede ser 0
    stock INT NOT NULL,
    CONSTRAINT fk_categoria_producto FOREIGN KEY (id_categoria) REFERENCES categorias(id) ON DELETE CASCADE
);

-- Creaci�n de la tabla rese�as
CREATE TABLE rese�as (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    comentario VARCHAR(200) NOT NULL,
    calificacion INT NOT NULL CHECK (calificacion BETWEEN 1 AND 5), -- Calificaci�n entre 1 y 5
    CONSTRAINT fk_cliente_rese�a FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE,
    CONSTRAINT fk_producto_rese�a FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
);

-- Creaci�n de la tabla estados_pedidos
CREATE TABLE estados_pedidos (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(25) NOT NULL, -- entregado, pendiente, en proceso, cancelado, devoluci�n
    descripcion VARCHAR(200) NOT NULL
);

-- Creaci�n de la tabla transacciones
CREATE TABLE transacciones (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    metodo_de_pago VARCHAR(30) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    fecha_pago DATETIME,
    confirmacion BIT NOT NULL CHECK (confirmacion IN (0, 1)) -- Pago aceptado o rechazado
);

-- Creaci�n de la tabla pedidos
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL, 
    id_transaccion INT NOT NULL,
    id_estado_pedido INT NOT NULL,
    fecha_entrega DATE NOT NULL,
    pais VARCHAR(25) NOT NULL,
    ciudad VARCHAR(25) NOT NULL,
    direccion NVARCHAR(200) NOT NULL,
    codigo_postal INT NOT NULL,
    numero_seguimiento VARCHAR(50), 
    CONSTRAINT fk_cliente_pedido FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE,
    CONSTRAINT fk_transaccion_pedido FOREIGN KEY (id_transaccion) REFERENCES transacciones(id) ON DELETE CASCADE,
    CONSTRAINT fk_estado_pedido_pedido FOREIGN KEY (id_estado_pedido) REFERENCES estados_pedidos(id) ON DELETE CASCADE
);

-- Creaci�n de la tabla detalle_pedidos
CREATE TABLE detalle_pedidos (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0), --  la cantidad sea mayor que 0
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    CONSTRAINT fk_pedido_detalle_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id) ON DELETE CASCADE,
    CONSTRAINT fk_producto_detalle_pedido FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
);

-- Creaci�n de la tabla seguimiento_pedidos
CREATE TABLE seguimiento_pedidos (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_pedido INT NOT NULL,
    estado VARCHAR(50) NOT NULL, -- Estado del pedido (ej. "Enviado", "Entregado", "Cancelado")
    fecha_actualizacion DATETIME NOT NULL DEFAULT GETDATE(), -- Fecha de actualizaci�n
    descripcion VARCHAR(200), 
    CONSTRAINT fk_seguimiento_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id) ON DELETE CASCADE
);

--------------------------------------------------------
--------------------------------------------------------


-- Insertar algunas categor�as
INSERT INTO categorias (nombre, descripcion)
VALUES 
('Electr�nica', 'Dispositivos electr�nicos y gadgets'),
('Ropa', 'Vestimenta para hombres y mujeres'),
('Hogar', 'Art�culos para el hogar'),
('Juguetes', 'Juguetes y juegos'),
('Deportes', 'Equipamiento deportivo'),
('Muebles', 'Muebles para el hogar y oficina');
-- Insertar 5 productos en la categor�a "Electr�nica"
INSERT INTO productos (id_categoria, nombre, descripcion, estado, precio, descuento, stock)
VALUES 
(1, 'Smartphone XYZ', 'Smartphone con caracter�sticas avanzadas', 'N', 599.99, 10.00, 50),
(1, 'Laptop ABC', 'Laptop potente para trabajos pesados', 'N', 999.99, 0.00, 30),
(1, 'Tablet QRS', 'Tablet ligera y port�til', 'U', 299.99, 5.00, 25),
(1, 'Auriculares Bluetooth', 'Auriculares inal�mbricos con gran sonido', 'N', 89.99, 15.00, 100),
(1, 'C�mara Digital 4K', 'C�mara con grabaci�n en 4K y zoom �ptico', 'N', 450.00, 20.00, 15);
-- Insertar 5 productos en la categor�a "Ropa"
INSERT INTO productos (id_categoria, nombre, descripcion, estado, precio, descuento, stock)
VALUES 
(2, 'Camiseta B�sica', 'Camiseta de algod�n suave', 'U', 19.99, 0.00, 100),
(2, 'Pantalones Jeans', 'Pantalones de mezclilla c�modos', 'N', 39.99, 5.00, 80),
(2, 'Chaqueta de Cuero', 'Chaqueta de cuero genuino', 'N', 89.99, 10.00, 50),
(2, 'Vestido de Verano', 'Vestido ligero y fresco', 'U', 29.99, 0.00, 60),
(2, 'Zapatos Deportivos', 'Zapatos c�modos para hacer ejercicio', 'N', 49.99, 15.00, 40);
-- Insertar 5 productos en la categor�a "Juguetes"
INSERT INTO productos (id_categoria, nombre, descripcion, estado, precio, descuento, stock)
VALUES 
(3, 'Mu�eca de Peluche', 'Mu�eca suave y abrazable', 'N', 24.99, 0.00, 50),
(3, 'Bloques de Construcci�n', 'Juego de bloques para construir', 'N', 15.99, 5.00, 100),
(3, 'Tren El�ctrico', 'Tren el�ctrico con v�as', 'N', 49.99, 10.00, 30),
(3, 'Pista de Carreras', 'Pista de carreras para coches', 'N', 39.99, 0.00, 20),
(3, 'Juego de Mesa', 'Juego de mesa cl�sico para toda la familia', 'N', 29.99, 5.00, 40);
-- Insertar 5 productos en la categor�a "Deportes"
INSERT INTO productos (id_categoria, nombre, descripcion, estado, precio, descuento, stock)
VALUES 
(4, 'Bal�n de F�tbol', 'Bal�n de f�tbol tama�o oficial', 'N', 29.99, 0.00, 100),
(4, 'Raqueta de Tenis', 'Raqueta ligera para jugadores de todos los niveles', 'N', 49.99, 10.00, 30),
(4, 'Zapatillas de Correr', 'Zapatillas c�modas para correr', 'N', 79.99, 5.00, 60),
(4, 'Set de Pesas', 'Pesas ajustables para entrenamiento', 'U', 89.99, 15.00, 20),
(4, 'Pelota de Baloncesto', 'Pelota de baloncesto de alta calidad', 'N', 34.99, 0.00, 50);
-- Insertar 5 productos en la categor�a "Muebles"
INSERT INTO productos (id_categoria, nombre, descripcion, estado, precio, descuento, stock)
VALUES 
(5, 'Sof� de Dos Plazas', 'Sof� c�modo y moderno', 'N', 499.99, 0.00, 20),
(5, 'Mesa de Comedor', 'Mesa de madera para 6 personas', 'N', 299.99, 10.00, 15),
(5, 'Silla de Oficina', 'Silla ergon�mica ajustable', 'N', 149.99, 5.00, 50),
(5, 'Estanter�a de Madera', 'Estanter�a para libros y decoraciones', 'N', 199.99, 15.00, 25),
(5, 'Cama King Size', 'Cama amplia con cabecera', 'U', 899.99, 0.00, 10);


-- Insertar 15 clientes en la tabla "clientes"
INSERT INTO clientes (nombres, apellidos, correo, dni, celular, nacionalidad, fecha_de_registro)
VALUES 
('Juan', 'P�rez', 'juan.perez@gmail.com', '12345678', '987654321', 'Peruano', '2023-09-01'),
('Mar�a', 'G�mez', 'maria.gomez@hotmail.com', '23456789', '976543210', 'Chilena', '2023-09-02'),
('Carlos', 'L�pez', 'carlos.lopez@gmail.com', '34567890', '965432109', 'Argentino', '2023-09-03'),
('Ana', 'Mart�nez', 'ana.martinez@hotmail.com', '45678901', '954321098', 'Colombiana', '2023-09-04'),
('Luis', 'Fern�ndez', 'luis.fernandez@gmail.com', '56789012', '943210987', 'Mexicano', '2023-09-05'),
('Sof�a', 'Ram�rez', 'sofia.ramirez@hotmail.com', '67890123', '932109876', 'Ecuatoriana', '2023-09-06'),
('Diego', 'Castillo', 'diego.castillo@gmail.com', '78901234', '921098765', 'Uruguayo', '2023-09-07'),
('Laura', 'Torres', 'laura.torres@hotmail.com', '89012345', '910987654', 'Paraguaya', '2023-09-08'),
('Andr�s', 'V�squez', 'andres.vasquez@gmail.com', '90123456', '909876543', 'Boliviano', '2023-09-09'),
('Claudia', 'Hern�ndez', 'claudia.hernandez@hotmail.com', '01234567', '898765432', 'Venezolana', '2023-09-10'),
('Felipe', 'Salazar', 'felipe.salazar@gmail.com', '12345679', '887654321', 'Peruano', '2023-09-11'),
('Paola', 'Jim�nez', 'paola.jimenez@hotmail.com', '23456780', '876543210', 'Chilena', '2023-09-12'),
('Ricardo', 'Mendoza', 'ricardo.mendoza@gmail.com', '34567891', '865432109', 'Argentino', '2023-09-13'),
('Isabel', 'D�az', 'isabel.diaz@hotmail.com', '45678902', '854321098', 'Colombiana', '2023-09-14'),
('Javier', 'C�rdoba', 'javier.cordoba@gmail.com', '56789013', '843210987', 'Mexicano', '2023-09-15');

--Insertar estados de pedido
INSERT INTO estados_pedidos (nombre, descripcion) VALUES ('Entregado', 'El pedido ha sido entregado al cliente.');
INSERT INTO estados_pedidos (nombre, descripcion) VALUES ('Pendiente', 'El pedido est� pendiente de ser procesado.');
INSERT INTO estados_pedidos (nombre, descripcion) VALUES ('En Proceso', 'El pedido est� siendo preparado.');
INSERT INTO estados_pedidos (nombre, descripcion) VALUES ('Cancelado', 'El pedido ha sido cancelado.');
INSERT INTO estados_pedidos (nombre, descripcion) VALUES ('Devoluci�n', 'El pedido ha sido devuelto por el cliente.');

---------------------------------------------------------
---------------------------------------------------------

-- Insertar Datos de compra del cliente 1 - 2 pedidos

-- Insertar la primera transacci�n
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Tarjeta de Cr�dito', 150.00, '2023-09-19', 1);


-- Insertar la segunda transacci�n
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('PayPal', 80.00, '2023-09-21', 1);


-- Crear Pedidos
-- Insertar el primer pedido 1
INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (1, 1, 1, '2023-09-20', 'Per�', 'Lima', 'Av.  Viva 123', 15001, 'ABC123');

-- Insertar el segundo pedido 2
INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (1, 2, 1, '2023-09-22', 'Per�', 'Lima', 'Av. Siempre 645', 15001, 'DEF456');

-- Crear Detalles de Pedidos
-- Detalle del primer pedido (3 balones de f�tbol)
INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (3, 1, 1); 

-- Detalle del segundo pedido (2 camisetas b�sicas)
INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (2, 2, 2); 

-- Crear Rese�as
-- Rese�a para el primer pedido (balones de f�tbol)
INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (1, 1, 'Excelente calidad, muy recomendado!', 5); -- Bal�n de f�tbol

-- Rese�a para el segundo pedido (camisetas b�sicas)
INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (1, 2, 'Comodidad y buen material, me encantan!', 4); -- Camiseta b�sica

-- Crear Seguimiento de Pedidos
-- Seguimiento para el primer pedido
INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (1, 'Enviado', GETDATE(), 'El pedido ha sido enviado.');

-- Seguimiento para el segundo pedido
INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (2, 'Preparado para env�o', GETDATE(), 'El pedido est� listo para ser enviado.');


-- Insertar Datos de compra del cliente 2 - 1 pedido

-- Crear una transacci�n
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Tarjeta de Cr�dito', 75.00, '2023-09-23', 1);

-- Crear un pedido
INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (2, 3, 1, '2023-09-25', 'Argetina', 'Buenos Aires', 'Av. Pueblo 784', 15002, 'XYZ789');

-- Crear detalles del pedido 
INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (1, 3, 2); 

-- Crear una rese�a para el producto
INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (2, 2, 'Me encanta esta camiseta, muy c�moda.', 5); 

-- Crear seguimiento del pedido
INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (3, 'Enviado', GETDATE(), 'El pedido ha sido enviado y est� en camino.');

-- Insertar  Datos cliente 3 - 3 pedidos

-- Pedido 1
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Tarjeta de Cr�dito', 70.00, '2023-09-24', 1);

INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (3, 4, 1, '2023-09-26', 'Chile', 'Santiago', 'Av. Ejemplo 123', 15093, 'LMN123');

INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (1, 4, 1); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (3, 1, 'Excelente bal�n, ideal para jugar.', 5); 

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (4, 'Enviado', GETDATE(), 'El pedido ha sido enviado.');

-- Pedido 2
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('PayPal', 40.00, '2023-09-25', 1);

INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (3, 5, 1, '2023-09-27', 'Chile', 'Santiago', 'Av. Ejemplo 123', 15003, 'LMN456');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (2, 5, 2);

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (3, 2, 'Comodidad y buen material.', 4); 

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (5, 'En Proceso', GETDATE(), 'El pedido est� en proceso.');

-- Pedido 3
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Efectivo', 100.00, '2023-09-26', 1);

INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (3, 6, 1, '2023-09-28', 'Chile', 'Santiago', 'Av. Ejemplo 123', 15003, 'LMN789');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (1, 6, 3); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (3, 3, 'Gran rendimiento y f�cil de usar.', 5); 

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (6, 'Pendiente', GETDATE(), 'El pedido est� pendiente de ser procesado.');


-- Insertar  Datos cliente 4 - 1 pedido

INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Tarjeta de Cr�dito', 50.00, '2023-09-20', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (4, 7, 1, '2023-09-22', 'Argentina', 'Buenos Aires', 'Av. Libertador 500', 1001, 'ABC123');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (1, 7, 4); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (4, 4, 'Producto excelente, lo recomiendo.', 5);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (7, 'Enviado', GETDATE(), 'El pedido ha sido enviado.');


--- Insertar  Datos cliente 5 - 1 pedido

INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Efectivo', 30.00, '2023-09-21', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (5, 8, 1, '2023-09-23', 'Chile', 'Santiago', 'Calle del Sol 300', 8320000, 'DEF456');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (2, 8, 5); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (5, 5, 'Calidad muy buena.', 4);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (8, 'Pendiente', GETDATE(), 'El pedido est� pendiente de env�o.');


-- Insertar  Datos cliente 6 - 1 pedido


INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Tarjeta de Cr�dito', 85.00, '2023-09-22', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (6, 9, 2, '2023-09-25', 'Colombia', 'Bogot�', 'Carrera 10 10-20', 110010, 'GHI789');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (1, 9, 6); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (6, 6, 'Muy satisfecho con la compra.', 5);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (6, 'Enviado', GETDATE(), 'El pedido ha sido enviado.');

-- Insertar  Datos cliente 7 - 1 pedido


INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('PayPal', 40.00, '2023-09-23', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (7,10, 4, '2023-09-26', 'M�xico', 'Ciudad de M�xico', 'Calle de la Paz 200', 01000, 'JKL012');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (3, 10, 7); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (7, 7, 'Gran producto, excelente compra.', 5);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (10, 'En Proceso', GETDATE(), 'El pedido est� en proceso de env�o.');


-- Insertar  Datos cliente 8 - 1 pedido

INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Efectivo', 60.00, '2023-09-24', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (8, 11, 5, '2023-09-27', 'Per�', 'Lima', 'Av. de la Rep�blica 123', 15004, 'MNO345');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (1, 11, 8); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (8, 8, 'R�pido y eficiente.', 4);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (11, 'Pendiente', GETDATE(), 'El pedido est� pendiente.');



-- Insertar  Datos cliente 9 - 3 pedidos

-- Pedido 1
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Tarjeta de Cr�dito', 120.00, '2023-09-30', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (9, 12, 1, '2023-10-02', 'Argentina', 'C�rdoba', 'Av. Sarmiento 1500', 5000, 'RCD001');

INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (2, 12, 10); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (9, 10, 'Gran calidad, muy satisfecho.', 5);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (12, 'Enviado', GETDATE(), 'El pedido ha sido enviado.');


-- Pedido 2
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Efectivo', 90.00, '2023-09-30', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (9, 13, 1, '2023-10-03', 'Argentina', 'C�rdoba', 'Calle 123', 5001, 'RCD002');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (1, 13, 11); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (9, 11, 'Muy bueno, pero el env�o tard� un poco.', 4);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (13, 'Pendiente', GETDATE(), 'El pedido est� en proceso de env�o.');


-- Pedido 3
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('PayPal', 75.00, '2023-09-30', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (9, 14, 1, '2023-10-04', 'Argentina', 'C�rdoba', 'Ruta 20', 5002, 'RCD003');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (3, 14, 13); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (9, 13, 'Excelente relaci�n calidad-precio.', 5);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (14, 'Enviado', GETDATE(), 'El pedido ha sido enviado.');


-- Insertar  Datos cliente 10 - 3 pedidos

-- Pedido 1
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Tarjeta de Cr�dito', 150.00, '2023-09-30', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (10, 15, 1, '2023-10-02', 'Colombia', 'Medell�n', 'Carrera 80 #20-30', 50020, 'VLG001');

INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (1, 15, 14); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (10, 14, 'Producto lleg� en perfecto estado.', 5);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (15, 'Enviado', GETDATE(), 'El pedido ha sido enviado.');


-- Pedido 2
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('Efectivo', 120.00, '2023-09-30', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (10, 15, 2, '2023-10-03', 'Colombia', 'Medell�n', 'Calle 10 #5-15', 50021, 'VLG002');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (2, 15, 15); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (10, 15, 'Muy �til y de buena calidad.', 4);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (15, 'Pendiente', GETDATE(), 'El pedido est� pendiente de env�o.');


-- Pedido 3
INSERT INTO transacciones (metodo_de_pago, total, fecha_pago, confirmacion)
VALUES ('PayPal', 200.00, '2023-09-30', 1);


INSERT INTO pedidos (id_cliente, id_transaccion, id_estado_pedido, fecha_entrega, pais, ciudad, direccion, codigo_postal, numero_seguimiento)
VALUES (10, 16, 1, '2023-10-04', 'Colombia', 'Medell�n', 'Av. del Ferrocarril 55', 50022, 'VLG003');


INSERT INTO detalle_pedidos (cantidad, id_pedido, id_producto)
VALUES (3, 16, 16); 

INSERT INTO rese�as (id_cliente, id_producto, comentario, calificacion)
VALUES (10, 16, 'Excelente, lleg� a tiempo.', 5);

INSERT INTO seguimiento_pedidos (id_pedido, estado, fecha_actualizacion, descripcion)
VALUES (16, 'En Proceso', GETDATE(), 'El pedido est� en proceso de env�o.');



select * from detalle_pedidos
delete from transacciones



SELECT 
    p.id AS producto_id,
    p.nombre AS nombre_producto,
    SUM(dp.cantidad) AS total_vendido,
    AVG(r.calificacion) AS calificacion_promedio
FROM 
    productos p
LEFT JOIN 
    detalle_pedidos dp ON p.id = dp.id_producto
LEFT JOIN 
    rese�as r ON p.id = r.id_producto
GROUP BY 
    p.id, p.nombre
ORDER BY 
    total_vendido DESC;



SELECT 
    c.id AS cliente_id,
    c.nombres,
    c.apellidos,
    COUNT(DISTINCT p.id) AS total_compras,
    COUNT(r.id) AS total_rese�as
FROM 
    clientes c
LEFT JOIN 
    pedidos pd ON c.id = pd.id_cliente
LEFT JOIN 
    detalle_pedidos dp ON pd.id = dp.id_pedido
LEFT JOIN 
    rese�as r ON c.id = r.id_cliente
LEFT JOIN 
    productos p ON dp.id_producto = p.id
GROUP BY 
    c.id, c.nombres, c.apellidos
ORDER BY 
    total_compras DESC;

	SELECT 
    p.id AS pedido_id, 
    c.nombres, 
    c.apellidos, 
    ep.nombre AS estado_pedido, 
    p.fecha_entrega 
FROM 
    pedidos p
JOIN 
    clientes c ON p.id_cliente = c.id
JOIN 
    estados_pedidos ep ON p.id_estado_pedido = ep.id;


SELECT 
    id, 
    nombre, 
    precio, 
    stock 
FROM 
    productos 
WHERE 
    stock > 0;

	SELECT 
    c.id AS cliente_id,
    c.nombres,
    c.apellidos,
    COUNT(p.id) AS total_pedidos,
    SUM(t.total) AS total_gastado
FROM 
    clientes c
LEFT JOIN 
    pedidos p ON c.id = p.id_cliente
LEFT JOIN 
    transacciones t ON p.id_transaccion = t.id
GROUP BY 
    c.id, c.nombres, c.apellidos
ORDER BY 
    total_gastado DESC;


SELECT 
    c.id AS categoria_id,
    c.nombre AS nombre_categoria,
    COUNT(DISTINCT p.id) AS total_productos,
    SUM(dp.cantidad) AS total_vendido,
    COUNT(r.id) AS total_rese�as
FROM 
    categorias c
LEFT JOIN 
    productos p ON c.id = p.id_categoria
LEFT JOIN 
    detalle_pedidos dp ON p.id = dp.id_producto
LEFT JOIN 
    rese�as r ON p.id = r.id_producto
GROUP BY 
    c.id, c.nombre
ORDER BY 
    total_vendido DESC;

	CREATE FUNCTION dbo.TotalGastadoPorCliente(@cliente_id INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @total DECIMAL(10, 2);

    SELECT @total = COALESCE(SUM(t.total), 0)
    FROM pedidos p
    JOIN transacciones t ON p.id_transaccion = t.id
    WHERE p.id_cliente = @cliente_id;

    RETURN @total;
END;

CREATE FUNCTION dbo.CalificacionPromedio(@producto_id INT)
RETURNS DECIMAL(3, 2)
AS
BEGIN
    DECLARE @promedio DECIMAL(3, 2);

    SELECT @promedio = AVG(calificacion)
    FROM rese�as
    WHERE id_producto = @producto_id;

    RETURN COALESCE(@promedio, 0);
END;

select dbo.CalificacionPromedio(15)
select dbo.TotalGastadoPorCliente(2)



-- Crear vista para seguimiento de pedidos
CREATE VIEW vista_seguimiento_pedidos AS
SELECT p.id AS pedido_id, 
       p.fecha_entrega, 
       sp.estado, 
       sp.fecha_actualizacion, 
       sp.descripcion
FROM pedidos p
JOIN seguimiento_pedidos sp ON p.id = sp.id_pedido;

-- MUESTRA LOS PRODUCTOS CON MEJORES RESE�AS 
SELECT 
    p.id AS producto_id,
    p.nombre,
    AVG(r.calificacion) AS calificacion_promedio,
    COUNT(r.id) AS total_rese�as
FROM 
    productos p
JOIN 
    rese�as r ON p.id = r.id_producto
GROUP BY 
    p.id, p.nombre
HAVING 
    COUNT(r.id) > 0 -- Solo incluir productos con al menos una rese�a
ORDER BY 
    calificacion_promedio DESC; -- Ordenar de mejor a peor calificaci�n



SELECT 
    c.id AS cliente_id,
    c.nombres,
    c.apellidos,
    c.correo,
    p.id AS pedido_id,
    p.fecha_entrega
FROM 
    clientes c
JOIN 
    pedidos p ON c.id = p.id_cliente
JOIN 
    estados_pedidos ep ON p.id_estado_pedido = ep.id
WHERE 
    ep.nombre = 'Cancelado' 
    AND p.fecha_entrega = CAST(GETDATE() - 1 AS DATE); -- Filtra los pedidos cancelados del d�a anterior


CREATE VIEW vw_RendimientoProductos AS
SELECT 
    p.id AS producto_id,
    p.nombre AS nombre_producto,
    SUM(dp.cantidad) AS total_vendido,
    (p.precio - p.descuento) AS precio_final,
    AVG(r.calificacion) AS calificacion_promedio
FROM 
    productos p
LEFT JOIN 
    detalle_pedidos dp ON p.id = dp.id_producto
LEFT JOIN 
    rese�as r ON p.id = r.id_producto
GROUP BY 
    p.id, p.nombre, p.precio, p.descuento;

	select * from vw_RendimientoProductos


CREATE VIEW vw_ClientesCompras AS
SELECT 
    c.id AS cliente_id,
    c.nombres,
    c.apellidos,
    COUNT(p.id) AS total_pedidos,
    COALESCE(SUM(t.total), 0) AS total_gastado
FROM 
    clientes c
LEFT JOIN 
    pedidos p ON c.id = p.id_cliente
LEFT JOIN 
    transacciones t ON p.id_transaccion = t.id
GROUP BY 
    c.id, c.nombres, c.apellidos;

select * from vw_ClientesCompras


CREATE VIEW vw_SeguimientoPedidos AS
SELECT 
    p.id AS pedido_id,
    c.nombres AS nombre_cliente,
    c.apellidos AS apellido_cliente,
    ep.nombre AS estado_pedido,
    ep.descripcion AS descripcion_estado,
    p.fecha_entrega,
    sp.estado AS estado_seguimiento,
    sp.fecha_actualizacion
FROM 
    pedidos p
JOIN 
    clientes c ON p.id_cliente = c.id
JOIN 
    estados_pedidos ep ON p.id_estado_pedido = ep.id
LEFT JOIN 
    seguimiento_pedidos sp ON p.id = sp.id_pedido
ORDER BY 
    p.fecha_entrega DESC;


CREATE VIEW vw_TransaccionesPorCliente AS
SELECT 
    c.id AS cliente_id,
    c.nombres,
    c.apellidos,
    t.id AS transaccion_id,
    t.metodo_de_pago,
    t.total,
    t.fecha_pago
FROM 
    clientes c
JOIN 
    pedidos p ON c.id = p.id_cliente
JOIN 
    transacciones t ON p.id_transaccion = t.id
ORDER BY 
    c.id, t.fecha_pago DESC;

CREATE VIEW vw_SeguimientoPedidos AS
SELECT 
    p.id AS pedido_id,
    c.nombres AS nombre_cliente,
    c.apellidos AS apellido_cliente,
    ep.nombre AS estado_pedido,
    ep.descripcion AS descripcion_estado,
    p.fecha_entrega,
    sp.estado AS estado_seguimiento,
    sp.fecha_actualizacion
FROM 
    pedidos p
JOIN 
    clientes c ON p.id_cliente = c.id
JOIN 
    estados_pedidos ep ON p.id_estado_pedido = ep.id
LEFT JOIN 
    seguimiento_pedidos sp ON p.id = sp.id_pedido
ORDER BY 
    p.fecha_entrega DESC;

CREATE PROCEDURE sp_AgregarCliente
    @nombres VARCHAR(55),
    @apellidos VARCHAR(55),
    @correo VARCHAR(55),
    @dni VARCHAR(8),
    @celular VARCHAR(9),
    @nacionalidad VARCHAR(20),
    @fecha_de_registro DATE
AS
BEGIN
    INSERT INTO clientes (nombres, apellidos, correo, dni, celular, nacionalidad, fecha_de_registro)
    VALUES (@nombres, @apellidos, @correo, @dni, @celular, @nacionalidad, @fecha_de_registro);
END;

CREATE PROCEDURE sp_ActualizarStockProducto
    @producto_id INT,
    @nuevo_stock INT
AS
BEGIN
    UPDATE productos
    SET stock = @nuevo_stock
    WHERE id = @producto_id;
END;

CREATE PROCEDURE sp_ReporteVentasMensuales
    @anio INT
AS
BEGIN
    SELECT 
        MONTH(p.fecha_entrega) AS mes,
        SUM(t.total) AS total_ventas,
        COUNT(p.id) AS total_pedidos
    FROM 
        pedidos p
    JOIN 
        transacciones t ON p.id_transaccion = t.id
    WHERE 
        YEAR(p.fecha_entrega) = @anio
    GROUP BY 
        MONTH(p.fecha_entrega)
    ORDER BY 
        mes;
END;

CREATE PROCEDURE sp_CancelarPedido
    @pedido_id INT
AS
BEGIN
    DECLARE @id_producto INT;
    DECLARE @cantidad INT;

    -- Obtener los detalles del pedido
    DECLARE cursor_detalles CURSOR FOR
        SELECT id_producto, cantidad
        FROM detalle_pedidos
        WHERE id_pedido = @pedido_id;

    OPEN cursor_detalles;
    FETCH NEXT FROM cursor_detalles INTO @id_producto, @cantidad;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Reponer el stock
        UPDATE productos
        SET stock = stock + @cantidad
        WHERE id = @id_producto;

        FETCH NEXT FROM cursor_detalles INTO @id_producto, @cantidad;
    END

    CLOSE cursor_detalles;
    DEALLOCATE cursor_detalles;

    -- Actualizar el estado del pedido a cancelado
    UPDATE pedidos
    SET id_estado_pedido = (SELECT id FROM estados_pedidos WHERE nombre = 'Cancelado')
    WHERE id = @pedido_id;
END;


CREATE PROCEDURE sp_ProductoMasVendido
AS
BEGIN
    SELECT TOP 1 
        p.id AS producto_id,
        p.nombre AS nombre_producto,
        SUM(dp.cantidad) AS cantidad_vendida,
        SUM(dp.cantidad * p.precio) AS total_ingresos
    FROM 
        detalle_pedidos dp
    JOIN 
        productos p ON dp.id_producto = p.id
    JOIN 
        pedidos ped ON dp.id_pedido = ped.id
    GROUP BY 
        p.id, p.nombre
    ORDER BY 
        cantidad_vendida DESC;
END;
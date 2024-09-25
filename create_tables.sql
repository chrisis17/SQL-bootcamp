-- Creación de la tabla clientes
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

-- Creación de la tabla categorias
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    descripcion VARCHAR(200) NOT NULL
);

-- Creación de la tabla productos
CREATE TABLE productos (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_categoria INT NOT NULL,
    nombre VARCHAR(55) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    estado CHAR(1) NOT NULL CHECK (estado IN ('N', 'U')), -- nuevo N, usado U
    precio DECIMAL(10, 2) NOT NULL, -- Cambiado a DECIMAL para mayor precisión
    descuento DECIMAL(5, 2) DEFAULT 0, -- Descuento puede ser 0
    stock INT NOT NULL,
    CONSTRAINT fk_categoria_producto FOREIGN KEY (id_categoria) REFERENCES categorias(id) ON DELETE CASCADE
);

-- Creación de la tabla reseñas
CREATE TABLE reseñas (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    comentario VARCHAR(200) NOT NULL,
    calificacion INT NOT NULL CHECK (calificacion BETWEEN 1 AND 5), -- Calificación entre 1 y 5
    CONSTRAINT fk_cliente_reseña FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE,
    CONSTRAINT fk_producto_reseña FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
);

-- Creación de la tabla estados_pedidos
CREATE TABLE estados_pedidos (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(25) NOT NULL, -- entregado, pendiente, en proceso, cancelado, devolución
    descripcion VARCHAR(200) NOT NULL
);

-- Creación de la tabla transacciones
CREATE TABLE transacciones (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    metodo_de_pago VARCHAR(30) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    fecha_pago DATETIME,
    confirmacion BIT NOT NULL CHECK (confirmacion IN (0, 1)) -- Pago aceptado o rechazado
);

-- Creación de la tabla pedidos
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL, -- Llave foránea que referencia a clientes
    id_transaccion INT NOT NULL,
    id_estado_pedido INT NOT NULL,
    fecha_entrega DATE NOT NULL,
    pais VARCHAR(25) NOT NULL,
    ciudad VARCHAR(25) NOT NULL,
    direccion NVARCHAR(200) NOT NULL,
    codigo_postal INT NOT NULL,
    numero_seguimiento VARCHAR(50), -- Nuevo campo para el número de seguimiento
    CONSTRAINT fk_cliente_pedido FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE,
    CONSTRAINT fk_transaccion_pedido FOREIGN KEY (id_transaccion) REFERENCES transacciones(id) ON DELETE CASCADE,
    CONSTRAINT fk_estado_pedido_pedido FOREIGN KEY (id_estado_pedido) REFERENCES estados_pedidos(id) ON DELETE CASCADE
);

-- Creación de la tabla detalle_pedidos
CREATE TABLE detalle_pedidos (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0), -- Asegurarse de que la cantidad sea mayor que 0
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    CONSTRAINT fk_pedido_detalle_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id) ON DELETE CASCADE,
    CONSTRAINT fk_producto_detalle_pedido FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
);

-- Creación de la tabla seguimiento_pedidos
CREATE TABLE seguimiento_pedidos (
    id INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    id_pedido INT NOT NULL,
    estado VARCHAR(50) NOT NULL, -- Estado del pedido (ej. "Enviado", "Entregado", "Cancelado")
    fecha_actualizacion DATETIME NOT NULL DEFAULT GETDATE(), -- Fecha de actualización
    descripcion VARCHAR(200), -- Descripción adicional sobre el estado
    CONSTRAINT fk_seguimiento_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id) ON DELETE CASCADE
);
# Modelamiento de Datos Relacionales para "ventas en Amazon"

Este repositorio muestra el contexto del problema y los agentes que intervienen en la venta de Amazon online.
También guarda los scripts necesarios para la creación de tablas relacionales, inserción de datos y querys de ejemplo.

![tables](https://github.com/user-attachments/assets/7331b0bd-d3bc-48e9-bf85-ffc12f4f4c4f)

## Contexto:
Tu empresa ha sido contratada para implementar una base de datos que gestiones las ventas en Amazon, de acuerdo a los siguientes lineamientos.

### Cliente:
Un cliente se registra en el sitio web ingresando datos personales (nombre, correo, contraseña, teléfono, fecha de registro). La información se almacena en la base de datos.

### Productos:
El cliente navega el catálogo, selecciona productos, y los añade al carrito de compras; datos a considerar: Información de los productos: nombre, descripción, precio, stock. Información de categorías: nombre, descripción

### Pedido:
El cliente completa un pedido proporcionando detalles de envío y método de pago. Datos para considerar: Información del pedido: cliente, productos seleccionados, cantidades, precio total. Dirección de envío: dirección, ciudad, estado, código postal, país. medio de pago.

### Inventario:
El sistema actualiza el stock de productos después de cada compra y notifica al personal si el inventario es bajo.

### Transacciones:
El sistema procesa y registra los pagos de pedidos, guardando información sobre el monto, fecha, estado de la transacción. Proceso:

### Reseñas:
Después de recibir un producto, el cliente puede dejar una reseña. Datos Involucrados: Información de reseñas: calificación, comentario, producto.

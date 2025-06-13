
CREATE DATABASE SupermercadORT;
GO

USE SupermercadORT;
GO

CREATE TABLE Provincias (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Pais VARCHAR(100)
);

CREATE TABLE Rubros (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(100)
);

CREATE TABLE Proveedores (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Domicilio VARCHAR(200),
    Email VARCHAR(100),
    IdProvincia INT FOREIGN KEY REFERENCES Provincias(Id),
    Activo BIT
);

CREATE TABLE Clientes (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Domicilio VARCHAR(200),
    Email VARCHAR(100),
    IdProvincia INT FOREIGN KEY REFERENCES Provincias(Id),
    Activo BIT
);

CREATE TABLE Articulos (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(100),
    StockActual INT,
    StockMinimo INT,
    PuntoReposicion INT,
    PrecioUnitario FLOAT,
    IdRubro INT FOREIGN KEY REFERENCES Rubros(Id),
    IdProveedor INT FOREIGN KEY REFERENCES Proveedores(Id)
);

CREATE TABLE Pedidos (
    Id INT PRIMARY KEY,
    Fecha DATE,
    IdProveedor INT FOREIGN KEY REFERENCES Proveedores(Id),
    IdCliente INT FOREIGN KEY REFERENCES Clientes(Id),
    Numero INT,
    Subtotal FLOAT
);

CREATE TABLE DetallePedidos (
    Id INT PRIMARY KEY,
    IdArticulo INT FOREIGN KEY REFERENCES Articulos(Id),
    IdPedido INT FOREIGN KEY REFERENCES Pedidos(Id),
    Cantidad INT,
    Precio FLOAT
);


-- PARTE 2: CONSULTAS

-- 1. Listar, ordenado por Nombre y Provincia, a todos los clientes. Mostrar sólo Nombre, en mayúscula, Provincia, Domicilio y E-mail.
SELECT UPPER(c.Nombre) AS Nombre, p.Nombre AS Provincia, c.Domicilio, c.Email
FROM Clientes c
JOIN Provincias p ON c.IdProvincia = p.Id
ORDER BY c.Nombre, p.Nombre;

-- 2. Listar todos los Artículos cuyo precio unitario sea mayor que 10 y menor que 100. Mostrar El Nombre del Artículo, el Precio y el Proveedor
SELECT a.Nombre AS Articulo, a.PrecioUnitario, pr.Nombre AS Proveedor
FROM Articulos a
JOIN Proveedores pr ON a.IdProveedor = pr.Id
WHERE a.PrecioUnitario > 10 AND a.PrecioUnitario < 100;

-- 3. Proveedores activos que empiecen con F y su email sea de Argentina
SELECT Nombre, Email, Domicilio, Activo
FROM Proveedores
WHERE Activo = 1 AND Nombre LIKE 'F%' AND Email LIKE '%.ar';

-- 4. Pedidos con subtotal < 15000. Mostrar Fecha, Cliente, Subtotal ordenado por subtotal descendente
SELECT p.Fecha, c.Nombre AS Cliente, p.Subtotal
FROM Pedidos p
JOIN Clientes c ON p.IdCliente = c.Id
WHERE p.Subtotal < 15000
ORDER BY p.Subtotal DESC;

-- 5. Listar proveedores ordenados por provincia y luego nombre. Mostrar todos los campos
SELECT *
FROM Proveedores
ORDER BY IdProvincia, Nombre;

-- 6. Detalle del Pedido 5
SELECT a.Nombre AS Articulo, dp.Cantidad, dp.Precio, (dp.Cantidad * dp.Precio) AS ImporteTotal
FROM DetallePedidos dp
JOIN Articulos a ON dp.IdArticulo = a.Id
WHERE dp.IdPedido = 5;

-- 7. Pedidos del cliente 1 antes del 1 de enero de 2025
SELECT *
FROM Pedidos
WHERE IdCliente = 1 AND Fecha < '2025-01-01';

-- 8. Artículos cuyo stock actual < punto de reposición
SELECT *
FROM Articulos
WHERE StockActual < PuntoReposicion;

-- 9. Actualizar país de las provincias de “Brasil” a “Argentina”
UPDATE Provincias
SET Pais = 'Argentina'
WHERE Pais = 'Brasil';

-- 10. Decrementar 10 unidades al stock actual de todos los artículos del rubro 1
UPDATE Articulos
SET StockActual = StockActual - 10
WHERE IdRubro = 1;

-- 11. Subir un 20% el precio unitario de artículos del rubro 3 y proveedor 1
UPDATE Articulos
SET PrecioUnitario = PrecioUnitario * 1.20
WHERE IdRubro = 3 AND IdProveedor = 1;

-- 12. Borrar todas las provincias cuyo país sea España
DELETE FROM Provincias
WHERE Pais = 'España';

-- 13. Borrar todos los pedidos del cliente 3
DELETE FROM Pedidos
WHERE IdCliente = 3;

-- 14. Insertar un nuevo Rubro
INSERT INTO Rubros (Id, Nombre) VALUES (999, 'Nuevo Rubro');

-- 15. Insertar una nueva provincia (Uruguay)
INSERT INTO Provincias (Id, Nombre, Pais) VALUES (999, 'Montevideo', 'Uruguay');

-- 16. Insertar un cliente de la provincia agregada (Uruguay)
INSERT INTO Clientes (Id, Nombre, Domicilio, Email, IdProvincia, Activo)
VALUES (999, 'Cliente Uruguay', 'Av. Uruguay 123', 'uruguay@cliente.com', 999, 1);

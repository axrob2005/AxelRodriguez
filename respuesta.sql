-- Pregunta 1: Nombre de los productos vendidos por TODOS los empleados
SELECT p.ProductName
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees e
    WHERE NOT EXISTS (
        SELECT 1
        FROM Orders o
        JOIN OrderDetails od ON od.OrderID = o.OrderID
        WHERE o.EmployeeID = e.EmployeeID
          AND od.ProductID = p.ProductID
    )
);

-- Pregunta 2: Nombre de los clientes que compraron SOLO productos con precio menor a 50
SELECT c.CompanyName
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
)
AND NOT EXISTS (
    SELECT 1
    FROM Orders o
    JOIN OrderDetails od ON od.OrderID = o.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    WHERE o.CustomerID = c.CustomerID
      AND p.UnitPrice >= 50
);

-- Pregunta 3: Titulo y nombre de los empleados que han vendido al menos uno de los productos 'Gravad lax' o 'Mishi Kobe Niku'
SELECT DISTINCT e.Title, e.FirstName, e.LastName
FROM Employees e
JOIN Orders o ON o.EmployeeID = e.EmployeeID
JOIN OrderDetails od ON od.OrderID = o.OrderID
JOIN Products p ON p.ProductID = od.ProductID
WHERE p.ProductName IN ('Gravad lax', 'Mishi Kobe Niku');

-- Pregunta 4: Nombre del empleado y nombre del cliente para pedidos enviados por Speedy Express a clientes de Bruselas
SELECT e.FirstName || ' ' || e.LastName AS EmployeeName,
       c.CompanyName AS CustomerName
FROM Orders o
JOIN Employees e ON e.EmployeeID = o.EmployeeID
JOIN Customers c ON c.CustomerID = o.CustomerID
JOIN Shippers s ON s.ShipperID = o.ShipVia
WHERE s.CompanyName = 'Speedy Express'
  AND c.City = 'Bruxelles';

-- Pregunta 5: Nombre, direccion, ciudad y region de los empleados que han realizado pedidos con destino a Belgica
SELECT DISTINCT e.FirstName || ' ' || e.LastName AS EmployeeName,
       e.Address,
       e.City,
       e.Region
FROM Employees e
JOIN Orders o ON o.EmployeeID = e.EmployeeID
WHERE o.ShipCountry = 'Belgium';

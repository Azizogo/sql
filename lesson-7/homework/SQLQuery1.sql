USE lessons;
GO

DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Products;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

INSERT INTO Customers VALUES 
(1, 'Diana'), 
(2, 'Ethan'), 
(3, 'Fiona'),
(4, 'George');

INSERT INTO Orders VALUES 
(201, 1, '2024-03-05'), 
(202, 1, '2024-04-12'),
(203, 2, '2024-04-25'),
(204, 2, '2024-05-01'),
(205, 3, '2024-05-05');

INSERT INTO Products VALUES 
(1, 'Smartphone', 'Electronics'), 
(2, 'Keyboard', 'Electronics'),
(3, 'Notebook', 'Stationery'),
(4, 'Pen', 'Stationery'),
(5, 'Monitor', 'Electronics');

INSERT INTO OrderDetails VALUES 
(1, 201, 1, 1, 500.00),
(2, 201, 2, 2, 40.00),
(3, 202, 5, 1, 200.00),
(4, 203, 3, 5, 5.00),
(5, 204, 1, 1, 500.00),
(6, 204, 2, 1, 40.00),
(7, 205, 3, 3, 5.00),
(8, 205, 4, 2, 1.50);

--1
SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;



--2
SELECT 
    c.CustomerID,
    c.CustomerName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

--3

SELECT 
    o.OrderID,
    p.ProductName,
    od.Quantity
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;


--4

SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 1;


--5 
SELECT 
    od.OrderID,
    od.ProductID,
    p.ProductName,
    od.Price
FROM 
    OrderDetails od
JOIN 
    Products p ON od.ProductID = p.ProductID
JOIN (
    SELECT 
        OrderID,
        MAX(Price) AS MaxPrice
    FROM 
        OrderDetails
    GROUP BY 
        OrderID
) as max_prices ON od.OrderID = max_prices.OrderID AND od.Price = max_prices.MaxPrice;

--6
select
	c.*,
	o.OrderID,
	o.OrderDate
from Customers as c
	join Orders as o
		on c.CustomerID = o.CustomerID
	join (
		select
			CustomerID,
			max(OrderDate) as LatestOrder
		from orders
		group by CustomerID
			
) as FilteredOrders on FilteredOrders.CustomerID = c.CustomerID and o.OrderDate = FilteredOrders.LatestOrder;

--7 
SELECT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT CASE WHEN p.Category <> 'Electronics' THEN p.ProductID END) = 0;

--8 
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Category = 'Stationery';


--9

SELECT 
    c.CustomerID,
    c.CustomerName,
    COALESCE(SUM(od.Quantity * od.Price), 0) AS TotalSpent
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName;
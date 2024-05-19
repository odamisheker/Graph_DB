USE master;
GO

DROP DATABASE IF EXISTS UserProductCategoryDB;
GO

CREATE DATABASE UserProductCategoryDB; 
GO

USE UserProductCategoryDB; 
GO

-- 1. 

CREATE TABLE Users (
    UserID INT IDENTITY NOT NULL,
    UserName NVARCHAR(100) NOT NULL,
	LastName NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Users PRIMARY KEY (UserID)
) AS NODE;
GO

CREATE TABLE Products (
    ProductID INT IDENTITY NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
	ProductDesc NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Products PRIMARY KEY (ProductID)
) AS NODE;
GO

CREATE TABLE Categories (
    CategoryID INT IDENTITY NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
	CategoryDesc  NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (CategoryID)
) AS NODE;
GO

-- 2. 

CREATE TABLE UserProductRelation AS EDGE;
GO

CREATE TABLE ProductCategoryRelation AS EDGE;
GO

CREATE TABLE UserCategoryRelation AS EDGE;
GO


-- 3.
INSERT INTO Users (UserName, LastName)
VALUES 
('Alice', 'Smith'),
('Bob', 'Johnson'),
('Charlie', 'Williams'),
('David', 'Jones'),
('Emma', 'Brown'),
('Frank', 'Davis'),
('Grace', 'Miller'),
('Hannah', 'Wilson'),
('Isaac', 'Moore'),
('Julia', 'Taylor');

INSERT INTO Products (ProductName, ProductDesc)
VALUES 
('Laptop', 'Powerful laptop for work and gaming'),
('Headphones', 'Noise-cancelling headphones with Bluetooth'),
('Smartphone', 'Latest smartphone with high-quality camera'),
('Keyboard', 'Mechanical keyboard with RGB lighting'),
('Monitor', '27-inch 4K monitor for immersive experience'),
('T-shirt', 'Cotton T-shirt with unique design'),
('Jeans', 'Blue denim jeans for casual wear'),
('Shoes', 'Leather shoes for formal occasions'),
('Book', 'Best-selling novel by famous author'),
('Backpack', 'Durable backpack for daily use');

INSERT INTO Categories (CategoryName, CategoryDesc)
VALUES 
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Apparel and fashion accessories'),
('Books', 'Books and literature'),
('Accessories', 'Miscellaneous accessories');


-- 4.
INSERT INTO UserProductRelation ($from_id, $to_id)
VALUES
    ( (SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Products WHERE ProductID = 1) ), 
    ( (SELECT $node_id FROM Users WHERE UserID = 2), (SELECT $node_id FROM Products WHERE ProductID = 2) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Products WHERE ProductID = 3) ), 
    ( (SELECT $node_id FROM Users WHERE UserID = 4), (SELECT $node_id FROM Products WHERE ProductID = 4) ), 
    ( (SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Products WHERE ProductID = 5) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 6), (SELECT $node_id FROM Products WHERE ProductID = 6) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 7), (SELECT $node_id FROM Products WHERE ProductID = 7) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 8), (SELECT $node_id FROM Products WHERE ProductID = 8) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 9), (SELECT $node_id FROM Products WHERE ProductID = 9) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 10), (SELECT $node_id FROM Products WHERE ProductID = 10) );

INSERT INTO ProductCategoryRelation ($from_id, $to_id)
VALUES
    ( (SELECT $node_id FROM Products WHERE ProductID = 1), (SELECT $node_id FROM Categories WHERE CategoryID = 1) ),
    ( (SELECT $node_id FROM Products WHERE ProductID = 2), (SELECT $node_id FROM Categories WHERE CategoryID = 1) ), 
    ( (SELECT $node_id FROM Products WHERE ProductID = 3), (SELECT $node_id FROM Categories WHERE CategoryID = 1) ),
    ( (SELECT $node_id FROM Products WHERE ProductID = 4), (SELECT $node_id FROM Categories WHERE CategoryID = 1) ),
    ( (SELECT $node_id FROM Products WHERE ProductID = 5), (SELECT $node_id FROM Categories WHERE CategoryID = 1) ),
    ( (SELECT $node_id FROM Products WHERE ProductID = 6), (SELECT $node_id FROM Categories WHERE CategoryID = 2) ), 
    ( (SELECT $node_id FROM Products WHERE ProductID = 7), (SELECT $node_id FROM Categories WHERE CategoryID = 2) ),
    ( (SELECT $node_id FROM Products WHERE ProductID = 8), (SELECT $node_id FROM Categories WHERE CategoryID = 2) ), 
    ( (SELECT $node_id FROM Products WHERE ProductID = 9), (SELECT $node_id FROM Categories WHERE CategoryID = 3) ), 
    ( (SELECT $node_id FROM Products WHERE ProductID = 10), (SELECT $node_id FROM Categories WHERE CategoryID = 4) ); 

INSERT INTO UserCategoryRelation ($from_id, $to_id)
VALUES
    ( (SELECT $node_id FROM Users WHERE UserID = 1), (SELECT $node_id FROM Categories WHERE CategoryID = 1) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 2), (SELECT $node_id FROM Categories WHERE CategoryID = 1) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 3), (SELECT $node_id FROM Categories WHERE CategoryID = 1) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 4), (SELECT $node_id FROM Categories WHERE CategoryID = 1) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 5), (SELECT $node_id FROM Categories WHERE CategoryID = 1) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 6), (SELECT $node_id FROM Categories WHERE CategoryID = 2) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 7), (SELECT $node_id FROM Categories WHERE CategoryID = 2) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 8), (SELECT $node_id FROM Categories WHERE CategoryID = 2) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 9), (SELECT $node_id FROM Categories WHERE CategoryID = 3) ),
    ( (SELECT $node_id FROM Users WHERE UserID = 10), (SELECT $node_id FROM Categories WHERE CategoryID = 4) ); 

-- 5.

SELECT c.CategoryName
FROM Users AS u,
     UserProductRelation AS upr,
     Products AS p,
     ProductCategoryRelation AS pcr,
     Categories AS c
WHERE MATCH (u-(upr)->p-(pcr)->c)
      AND u.UserName = 'Alice';

SELECT u.UserName
FROM Users AS u,
     UserProductRelation AS upr,
     Products AS p,
     ProductCategoryRelation AS pcr,
     Categories AS c
WHERE MATCH (u-(upr)->p-(pcr)->c)
      AND c.CategoryName = 'Electronics';

SELECT p.ProductName, c.CategoryName
FROM Users AS u,
     UserProductRelation AS upr,
     Products AS p,
     ProductCategoryRelation AS pcr,
     Categories AS c
WHERE MATCH (u-(upr)->p-(pcr)->c)
      AND u.UserName = 'Bob';

SELECT p.ProductName
FROM Products AS p,
     ProductCategoryRelation AS pcr,
     Categories AS c
WHERE MATCH (p-(pcr)->c)
      AND c.CategoryName = 'Clothing';

SELECT u.UserName
FROM Users AS u,
     UserCategoryRelation AS ucr,
     Categories AS c,
     UserProductRelation AS upr,
     Products AS p,
     ProductCategoryRelation AS pcr
WHERE MATCH (u-(ucr)->c)
      AND MATCH (u-(upr)->p-(pcr)->c)
      AND c.CategoryName = 'Clothing';

-- 6.
SELECT
    u1.UserName AS userName,
    STRING_AGG(c1.CategoryName, '->') WITHIN GROUP (GRAPH PATH) AS UserCategoryPath
FROM
    Users AS u1,
    Categories FOR PATH AS c1,
    UserCategoryRelation FOR PATH AS UserCategoryRel
WHERE MATCH(SHORTEST_PATH(u1(-(UserCategoryRel)->c1)+))
    AND u1.UserName = 'Alice'

SELECT
    u1.UserName AS userName,
    STRING_AGG(c1.CategoryName, '->') WITHIN GROUP (GRAPH PATH) AS UserCategoryPath
FROM
    Users AS u1,
    Categories FOR PATH AS c1,
    UserCategoryRelation FOR PATH AS UserCategoryRel
WHERE MATCH(SHORTEST_PATH(u1(-(UserCategoryRel)->c1){1, 3}))
    AND u1.UserName = 'Frank'
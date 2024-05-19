select @@SERVERNAME
-- server name: DESKTOP-BDVSL78\SQLEXPRESS
-- database: UserProductCategoryDB

SELECT U.UserName AS [Имя пользователя], U.LastName AS [Фамилия пользователя], P.ProductName AS [Название продукта], P.ProductDesc AS [Описание продукта]
FROM Users AS U
INNER JOIN UserProductRelation AS UPR ON U.$node_id = UPR.$from_id
INNER JOIN Products AS P ON UPR.$to_id = P.$node_id;
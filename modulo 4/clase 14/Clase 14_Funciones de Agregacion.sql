use pubs
go

SELECT A.city 'Ciudad', COUNT(A.city) 'Cant. Autores Ciudad' 
FROM authors A
WHERE A.city = 'Oakland'
GROUP BY A.city


SELECT t.type 'Tipo', AVG(price) 'Precio Promedio' FROM [dbo].[titles] T
WHERE T.type LIKE '%BUS%'
GROUP BY T.type


SELECT t.type 'Tipo', AVG(price) 'Precio Promedio' FROM [dbo].[titles] T
WHERE T.type LIKE '%BUS%'
GROUP BY T.type

SELECT t.type 'Tipo', SUM(T.ytd_sales) 'Cantidad Vendida' FROM titles T
WHERE T.type = 'Business'
GROUP BY T.type

SELECT S.title_id, s.stor_id,  MIN(S.qty) FROM sales S INNER JOIN titles T ON S.title_id = T.title_id
WHERE T.title_id = 'BU1032'
GROUP BY S.title_id, s.stor_id
HAVING MIN(S.qty) < 7

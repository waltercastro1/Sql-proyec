

IF OBJECT_ID('rptAutosXModelo') IS NOT NULL
	DROP PROC rptAutosXModelo
GO

ALTER PROC rptAutosXModelo
@TipoAut varchar(30) 
AS
	SELECT DA.NUM_ALQ, CL.IDE_CLI, CL.APE_CLI + ' ' + CL.NOM_CLI AS [CLIENTE], DA.MAT_AUT, AU.COL_AUT, AU.MOD_AUT, AL.FEC_ALQ
	FROM DetalleAlquiler DA INNER JOIN Automovil AU ON DA.MAT_AUT = AU.MAT_AUT 
		INNER JOIN Cliente CL ON CL.IDE_CLI = DA.IDE_CLI
		INNER JOIN Alquiler AL ON AL.NUM_ALQ = DA.NUM_ALQ
	WHERE AU.MOD_AUT Like '%' + @TipoAut + '%'

--EXECUTE rptAutosXModelo @TipoAut = 'Cam'

use RENTCAR
	SELECT DA.NUM_ALQ, CL.IDE_CLI, CL.APE_CLI + ' ' + CL.NOM_CLI AS [CLIENTE], DA.MAT_AUT, AU.COL_AUT, AU.MOD_AUT, AL.FEC_ALQ
	FROM DetalleAlquiler DA INNER JOIN Automovil AU ON DA.MAT_AUT = AU.MAT_AUT 
		INNER JOIN Cliente CL ON CL.IDE_CLI = DA.IDE_CLI
		INNER JOIN Alquiler AL ON AL.NUM_ALQ = DA.NUM_ALQ
	--WHERE AU.MOD_AUT = 'SEDAN'
	WHERE AU.MOD_AUT like '%Cam%'

exec sp_help Automovil 





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


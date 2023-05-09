 
use henry_m3;

/*Normalización Localidad Provincia

La cláusula UNION se utiliza para combinar los resultados de dos o más consultas 
en una sola tabla de resultados. 
En la consulta que presentas, se usan tres consultas SELECT separadas por la cláusula UNION:

La primera consulta selecciona las columnas "Localidad" y "Provincia" 
de la tabla "cliente" donde la "Localidad" es igual a 'Avellaneda'.

La segunda consulta selecciona las columnas "Localidad" y "Provincia"
de la tabla "sucursal" donde la "Localidad" es igual a 'Avellaneda'.

La tercera consulta selecciona las columnas "Ciudad" y "Provincia"
 de la tabla "proveedor" donde la "Ciudad" es igual a 'Avellaneda'.

En cada una de las consultas, se utiliza la cláusula DISTINCT 
para asegurarse de que no haya filas duplicadas en la tabla de resultados.

Luego, la cláusula UNION combina las tres tablas de resultados en una sola tabla,
eliminando cualquier fila duplicada en el proceso.
 
 
La consulta resultante devuelve una lista única
de localidades y provincias que coinciden con el valor "Avellaneda",
 ordenada primero por provincia y luego por localidad.
*/

-- Crea tabla aux_Localidad para normalizar localidad y prov.
DROP TABLE IF EXISTS aux_Localidad;
CREATE TABLE IF NOT EXISTS aux_Localidad ( 
	Localidad_Original	VARCHAR(80),
	Provincia_Original	VARCHAR(50),
	Localidad_Normalizada	VARCHAR(80),
	Provincia_Normalizada	VARCHAR(50),
	IdLocalidad			INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
SELECT * FROM aux_Localidad;






/*Notar la difernecia entre el UNION y el UNION ALL

La diferencia entre UNION y UNION ALL es que UNION realiza
 una unión de conjuntos eliminando las filas duplicadas, 
mientras que UNION ALL realiza la unión de los conjuntos sin eliminar las filas duplicadas.

Union une tablas, a dif del join, inner join, une dos tablas considerando la interseccion de ambas, 
Union, extiende la tabla, hace una tabla de varias tablas

*/

-- union evita los repetidos
-- SI, UNION ELIMINA DUPLICADOS ENTRE LAS TABLAS COMPARADAS. SOLO TRAE LOS "NO REPETIDOS"
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 
FROM cliente 
where Localidad = 'Avellaneda'
UNION
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 
FROM sucursal 
where Localidad = 'Avellaneda'
UNION
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 
FROM proveedor where Ciudad = 'Avellaneda'
ORDER BY 2, 1;

-- UNION ALL no elimina los valores duplicados en las 3 tablas.
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM cliente where Localidad = 'Avellaneda'
UNION ALL -- NO ELIMINA VALORES DUPLICADOS
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM sucursal where Localidad = 'Avellaneda'
UNION ALL
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor where Ciudad = 'Avellaneda'
ORDER BY 2, 1;






/*
En este bloque de código se están insertando los datos normalizados
de las localidades y provincias de las tablas cliente, sucursal y proveedor 
en la tabla aux_localidad.

El SELECT DISTINCT
se utiliza para obtener sólo las filas únicas de cada tabla, es decir, sin duplicados.

Luego, se utiliza UNION
para unir las filas únicas de las tres tablas.
De esta manera, se obtienen todas las localidades y provincias sin duplicados.

En la instrucción ORDER BY 2, 1 
se ordena el resultado por la columna número 2 (provincia)
y luego por la columna número 1 (localidad).

Finalmente, los datos obtenidos se insertan en la tabla aux_localidad,
que tiene una estructura específica para la normalización de las localidades y provincias.

La columna IdLocalidad tiene valor 0 porque aún no se ha generado una clave única
para cada localidad y provincia.

*/
INSERT INTO aux_localidad (Localidad_Original, Provincia_Original, Localidad_Normalizada, Provincia_Normalizada, IdLocalidad)
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM cliente
UNION
SELECT DISTINCT Localidad, Provincia, Localidad, Provincia, 0 FROM sucursal
UNION
SELECT DISTINCT Ciudad, Provincia, Ciudad, Provincia, 0 FROM proveedor
ORDER BY 2, 1;


SELECT distinct * FROM aux_localidad ORDER BY Provincia_Original;

UPDATE `aux_localidad` SET Provincia_Normalizada = 'Buenos Aires'
WHERE Provincia_Original IN ('B. Aires',
                            'B.Aires',
                            'Bs As',
                            'Bs.As.',
                            'Buenos Aires',
                            'C Debuenos Aires',
                            'Caba',
                            'Ciudad De Buenos Aires',
                            'Pcia Bs As',
                            'Prov De Bs As.',
                            'Provincia De Buenos Aires');
SELECT DISTINCT Provincia_Original, Provincia_Normalizada
FROM aux_localidad WHERE Provincia_Normalizada = 'Buenos Aires';






/*El AND es un operador lógico que se utiliza
 para combinar dos o más condiciones en una expresión WHERE.
 En el ejemplo que mostraste, se utiliza para combinar dos condiciones:
*/

UPDATE `aux_localidad` SET Localidad_Normalizada = 'Capital Federal'
WHERE Localidad_Original IN ('Boca De Atencion Monte Castro',
                            'Caba',
                            'Cap.   Federal',
                            'Cap. Fed.',
                            'Capfed',
                            'Capital',
                            'Capital Federal',
                            'Cdad De Buenos Aires',
                            'Ciudad De Buenos Aires')
AND Provincia_Normalizada = 'Buenos Aires';
SELECT DISTINCT Provincia_Original, Provincia_Normalizada
FROM aux_localidad WHERE Provincia_Normalizada = 'Buenos Aires';						
                            
                            
UPDATE `aux_localidad` SET Localidad_Normalizada = 'Córdoba'
WHERE Localidad_Original IN ('Coroba',
                            'Cordoba',
							'Cã³rdoba')
AND Provincia_Normalizada = 'Córdoba';
SELECT DISTINCT Provincia_Original, Provincia_Normalizada
FROM aux_localidad WHERE Provincia_Normalizada = 'Córdoba';





-- Crea nuevas tablas a poblar con info ya normalizada... localidad y provincia.

DROP TABLE IF EXISTS `localidad`;
CREATE TABLE IF NOT EXISTS `localidad` (
  `IdLocalidad` int(11) NOT NULL AUTO_INCREMENT, -- 0
  `Localidad` varchar(80) NOT NULL,-- 1
  `Provincia` varchar(80) NOT NULL,-- 2
  `IdProvincia` int(11) NOT NULL,-- 3
  PRIMARY KEY (`IdLocalidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
SELECT * FROM localidad;

DROP TABLE IF EXISTS `provincia`;
CREATE TABLE IF NOT EXISTS `provincia` (
  `IdProvincia` int(11) NOT NULL AUTO_INCREMENT,
  `Provincia` varchar(50) NOT NULL,
  PRIMARY KEY (`IdProvincia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
SELECT * FROM provincia;

-- Puebla ahora las tablas nuevas Localidad y Provincia con la info:
-- INSERT INTO dentro de la tabla nueva localidad, inserte (Localidad, Provincia, IdProvincia),
-- pero... con que valores? Alli le pasa un subquery;
INSERT INTO Localidad (Localidad, Provincia, IdProvincia)-- (1,2,3)...(cero no le pasa valores por ser AUTO_INCREMENT)
SELECT	DISTINCT Localidad_Normalizada, Provincia_Normalizada, 0 
-- INTERESANTE COMO USA LA SUBCONSULTA PARA POBLAR! subquery!
FROM aux_localidad -- Le pasa desde donde tomar los datos
ORDER BY Provincia_Normalizada, Localidad_Normalizada;-- y MUY IMPORTANTE el ORDEN EN QUE SE LOS PASA!
-- Para que vayan de la mano con el auto increment, muy buena practica.

INSERT INTO provincia (Provincia) -- Lo mismo con provincia;
SELECT DISTINCT Provincia_Normalizada
FROM aux_localidad
ORDER BY Provincia_Normalizada;

-- Visualizacion para confirmar:
select * from provincia;
select * from localidad;

-- actualizo la tabla localidad, haciendo join, con el id de provincia, que fue formulado
-- con el AUTO_INCREMENT IdLocalidad en la tabla IdProvincia.
UPDATE localidad l JOIN provincia p
	ON (l.Provincia = p.Provincia)
SET l.IdProvincia = p.IdProvincia;
SELECT * FROM localidad;


-- ahora actualiza la tabla aux_localidad con localidad provincia donde tengo el par unico.
UPDATE aux_localidad a JOIN localidad l 
	ON (l.Localidad = a.Localidad_Normalizada AND a.Provincia_Normalizada = l.Provincia)-- ambas deben cumplise
SET a.IdLocalidad = l.IdLocalidad;
SELECT * FROM localidad;


select * from aux_localidad;
-- agrego las col desarrollada a las tablas donde sea necesario/util para hacerla foreing key de 
-- de la nueva tabla creada
-- a esto le llamare: relacionar la nueva tabla

ALTER TABLE `cliente` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Localidad`;
ALTER TABLE `proveedor` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Departamento`;
ALTER TABLE `sucursal` ADD `IdLocalidad` INT NOT NULL DEFAULT '0' AFTER `Provincia`;



-- Actualizo ahora la tabla cliente tomando el id de localidad de la tabla vieja,
-- buscando en la tabla aux su id.
UPDATE cliente c JOIN aux_localidad a
	ON (c.Provincia = a.Provincia_Original AND c.Localidad = a.Localidad_Original)
SET c.IdLocalidad = a.IdLocalidad;

UPDATE sucursal s JOIN aux_localidad a
	ON (s.Provincia = a.Provincia_Original AND s.Localidad = a.Localidad_Original)
SET s.IdLocalidad = a.IdLocalidad;

UPDATE proveedor p JOIN aux_localidad a
	ON (p.Provincia = a.Provincia_Original AND p.Ciudad = a.Localidad_Original)
SET p.IdLocalidad = a.IdLocalidad;
-- Visaulizo:
select * from cliente;
select * from proveedor;
select * from sucursal;

-- Dropeo ahora las no necesarias.
ALTER TABLE `cliente`
  DROP `Provincia`,
  DROP `Localidad`;
  
ALTER TABLE `proveedor`
  DROP `Ciudad`,
  DROP `Provincia`,
  DROP `Pais`,
  DROP `Departamento`;
  
ALTER TABLE `sucursal`
  DROP `Localidad`,
  DROP `Provincia`;
  
ALTER TABLE `localidad`
  DROP `Provincia`;
  -- Verifico
SELECT * FROM `cliente`;
SELECT * FROM `proveedor`;
SELECT * FROM `sucursal`;
SELECT * FROM `localidad`;
SELECT * FROM `provincia`;

-- muy bueno!






/*Discretización del campo edad, como no tengo la fecha exacta de nacimiento,
Debo discretizar haciendo un rango etario*/
-- agrego la col, rango etario, vacia primero...
ALTER TABLE `cliente` ADD `Rango_Etario` VARCHAR(20) NOT NULL DEFAULT '-' AFTER `Edad`;
SELECT * FROM cliente;
-- actualizo y meto dentro de los rangos etarios:
UPDATE cliente SET Rango_Etario = '1_Hasta 30 años' WHERE Edad <= 30;
UPDATE cliente SET Rango_Etario = '2_De 31 a 40 años' WHERE Edad <= 40 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '3_De 41 a 50 años' WHERE Edad <= 50 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '4_De 51 a 60 años' WHERE Edad <= 60 AND Rango_Etario = '-';
UPDATE cliente SET Rango_Etario = '5_Desde 60 años' WHERE Edad > 60 AND Rango_Etario = '-';
SELECT * FROM cliente;

SELECT Rango_Etario, count(*)
FROM cliente
GROUP BY Rango_Etario
ORDER BY Rango_Etario;





/*Deteccion y corrección de OUTLIERS sobre ventas*/
/*Motivos:
2-Outlier de Cantidad
3-Outlier de Precio
*/

-- formula 3 sigmas std de Gonzalo.


-- SELECCIONA de ventas, todos los registros. 
-- De o (IdProducto) el promedio del precio de venta, es decir, La subconsulta "o"
-- calcula el promedio de los precios de venta para cada producto individual y 
-- lo etiqueta como "promedio" utilizando la función de agregación AVG (promedio).
SELECT v.*, o.promedio, o.maximo -- traeme, de ventas, todo, tablien o.promedio(agrupado por Id de producto, elprecio promedio de cada IdProducto).. y su maximo (en +desv est *3)
FROM venta v JOIN (SELECT 	IdProducto, -- join con Subquery, seleccione el IdProducto
							AVG(Precio) as promedio,-- Haga promedio del precio de cada estos IdProducto (que se presente por cada venta (join efecto))
							AVG(Precio) + (3 * STDDEV(Precio)) AS maximo -- tambien saca el valor maximo a considerar dentro del rango en el que no se considera un outlaier.
					FROM venta
					GROUP BY IdProducto) o -- Agupado por producto
			ON (v.IdProducto = o.IdProducto) -- donde hacer el join?...
WHERE v.Precio > o.maximo; -- trayendome solo aquellos que su precio de venta sea un valor fuera del rango outliers definido arriba.

select * from venta where IdProducto = 42890; 
-- busca para ver la anomalia en el ejemplo, 
-- uno de los tantos valores en la tabla producto del select anterior
-- Se puede observar el outlier que sobresale por el resto de los valores.

SELECT v.*, o.promedio, o.maximo
FROM venta v JOIN (SELECT 	IdProducto,
							AVG(Cantidad) as promedio,
							AVG(Cantidad) + (3 * STDDEV(Cantidad)) AS maximo
					FROM venta
					GROUP BY IdProducto) o
			ON (v.IdProducto = o.IdProducto)
WHERE v.Cantidad > o.maximo;
select * from venta where IdProducto = 42992;

select Cantidad, count(*) from venta group by Cantidad order by 1; -- visualización para detectar anomalias


INSERT INTO aux_venta (IdVenta, 
						Fecha, 
						Fecha_Entrega, 
						IdCliente, 
						IdSucursal, 
						IdEmpleado, 
						IdProducto, 
						Precio, 
						Cantidad, 
						Motivo)                        
SELECT v.IdVenta, 
		v.Fecha, 
		v.Fecha_Entrega, 
		v.IdCliente, 
		v.IdSucursal, 
		v.IdEmpleado, 
		v.IdProducto, 
		v.Precio, 
		v.Cantidad,
		2
FROM venta v 
JOIN (SELECT IdProducto, AVG(Cantidad) As Promedio, STDDEV(Cantidad) as Desv 
		FROM venta 
        GROUP BY IdProducto) v2
on (v.IdProducto = v2.IdProducto)
WHERE v.Cantidad > (v2.Promedio + (3 * v2.Desv)) OR v.Cantidad < 0;
SELECT * FROM aux_venta ORDER BY Motivo DESC;
/*Crea una nueva entrada en la tabla aux_venta.

Selecciona columnas específicas de la tabla venta y las inserta en la nueva entrada de aux_venta.

Usa una subconsulta para calcular el promedio y la desviación estándar de la cantidad
de productos vendidos para cada producto en la tabla venta.

Se une con la tabla venta en la columna IdProducto para filtrar las ventas
que tienen una cantidad anormalmente alta o baja en comparación con el promedio y 
la desviación estándar calculados.

Asigna un valor de "2" a la columna "Motivo" en la nueva entrada de aux_venta.

Finalmente, selecciona todas las entradas de la tabla aux_venta ordenándolas por orden descendente 
de la columna "Motivo".*/

INSERT INTO aux_venta (IdVenta, 
						Fecha, 
                        Fecha_Entrega, 
                        IdCliente, 
                        IdSucursal, 
                        IdEmpleado, 
                        IdProducto, 
                        Precio, 
                        Cantidad,
                        Motivo)
SELECT v.IdVenta, 
		v.Fecha, 
        v.Fecha_Entrega, 
        v.IdCliente, 
        v.IdSucursal, 
        v.IdEmpleado, 
        v.IdProducto, 
        v.Precio, 
        v.Cantidad, 
        3
FROM venta v 
JOIN (SELECT IdProducto, 
		AVG(Precio) As Promedio, 
        STDDEV(Precio) as Desv 
        FROM venta 
        GROUP BY IdProducto) v2 -- otra subquery dentro de la sub query, se abusa
on (v.IdProducto = v2.IdProducto) -- donde lo une por id de 
WHERE v.Precio > (v2.Promedio + (3 * v2.Desv)) OR v.Precio < 0;

select * from aux_venta where Motivo = 2; -- outliers de cantidad
select * from aux_venta where Motivo = 3; -- outliers de precio
-- detectamos outlaiers cant y precio y los insertamos en la tabla aux


-- agrego la col Outlaier con valor por def = 1
ALTER TABLE `venta` ADD `Outlier` TINYINT NOT NULL DEFAULT '1' AFTER `Cantidad`;

-- ahora marco los outliers con 0.. por la cant de registros tarda un poco
UPDATE venta v JOIN aux_venta a
	ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
SET v.Outlier = 0;
SELECT * FROM venta LIMIT 10; 




SELECT 	co.TipoProducto,
		round(co.PromedioVentaConOutliers,2),
        round(so.PromedioVentaSinOutliers,2),
        round(round(co.PromedioVentaConOutliers,2)-round(so.PromedioVentaSinOutliers,2)) as diferencia
FROM
	(SELECT 	tp.TipoProducto, 									-- Traeme la columna tipo de producto de la tabla tipo de producto.
			AVG(v.Precio * v.Cantidad) as PromedioVentaConOutliers 	-- Calcula el promedio del ingreso por ventas de cada producto,
	FROM 	venta v JOIN producto p 								--  según la tabla ventas.. inner joined con la tabla producto (p),
		ON (v.IdProducto = p.IdProducto) 							-- ¿donde las une? a traves del idProducto que figura como columna en ambas tablas y establece asi la relacion.
			JOIN tipo_producto tp 									-- y a la tabla resultante le hace otro join (en realidad a la última agregada "producto")
		ON (p.IdTipoProducto = tp.IdTipoProducto) 					-- mediante el IdTipoProducto que figura en la tabla producto y tipo_producto
	GROUP BY tp.TipoProducto) co 									-- agrupaado por tipo de propducto.
JOIN
	(SELECT 	tp.TipoProducto,									-- Luego lo multiplica por la "máscara" de motivoOutlaiers!
			AVG(v.Precio * v.Cantidad) as PromedioVentaSinOutliers	-- calculando el promedio del ingreso por ventas
	FROM 	venta v JOIN producto p									-- utilizando la tabla ventas, inner joined con tabla producto
		ON (v.IdProducto = p.IdProducto and v.Outlier = 1)			-- ¿donde las une? a traves del idProducto que figura como columna en ambas tablas (vennta y prod), pero demasel outlaier debe ser motivo 1 (el cual era que NO era un Outlaier) y establece asi la relacion.
			JOIN tipo_producto tp									-- y a la tabla resultante le hace otro join por tipo de producto 
		ON (p.IdTipoProducto = tp.IdTipoProducto)					-- donde las une: por idTipoProducto, que figura en ambas.
	GROUP BY tp.TipoProducto) so 									-- agrupado por la columna TipoProducto de la tabla tipo_producto y utiliza un alias de query para que en la misma tabla traiga ambos
ON co.TipoProducto = so.TipoProducto;								-- Donde? en la codificacion x tipoProducto







-- KPI: Margen de Ganancia por producto superior a 20% para el 2019.
SELECT 	venta.Producto, 
		venta.SumaVentas, 
        venta.CantidadVentas, 
        venta.SumaVentasOutliers,
        compra.SumaCompras, 
        compra.CantidadCompras,
        ((venta.SumaVentas / compra.SumaCompras - 1) * 100) as margen
FROM
	(SELECT 	p.Producto,
			SUM(v.Precio * v.Cantidad * v.Outlier) 	as 	SumaVentas,
			SUM(v.Outlier) 							as	CantidadVentas,
			SUM(v.Precio * v.Cantidad) 				as 	SumaVentasOutliers,
			COUNT(*) 								as	CantidadVentasOutliers
	FROM venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto
			AND YEAR(v.Fecha) = 2019)
	GROUP BY p.Producto) AS venta
JOIN
	(SELECT 	p.Producto,
			SUM(c.Precio * c.Cantidad) 				as SumaCompras,
			COUNT(*)								as CantidadCompras
	FROM compra c JOIN producto p
		ON (c.IdProducto = p.IdProducto
			AND YEAR(c.Fecha) = 2019)
	GROUP BY p.Producto) as compra
ON (venta.Producto = compra.Producto);

/*KPIs: Correccion Latitud y Longitud para evaluar la demora en la entrega teniendo den cuenta tambien la distancia*/
ALTER TABLE `localidad` ADD `Latitud` DOUBLE NOT NULL DEFAULT '0' AFTER `IdProvincia`, ADD `Longitud` DOUBLE NOT NULL DEFAULT '0' AFTER `Latitud`;
select * from localidad l ;

DROP TABLE IF EXISTS aux_cliente;
CREATE TABLE IF NOT EXISTS aux_cliente (
	IdCliente			INTEGER,
	Latitud				DOUBLE,
	Longitud			DOUBLE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO aux_cliente (IdCliente, Latitud, Longitud)
SELECT 	IdCliente, Latitud, Longitud
FROM cliente WHERE Latitud < -55;
SELECT * FROM aux_cliente;

UPDATE cliente c JOIN aux_cliente ac
	ON (c.IdCliente = ac.IdCliente)
SET c.Latitud = ac.Longitud, c.Longitud = ac.Latitud;
SELECT * FROM aux_cliente;


UPDATE `cliente` SET Latitud = Latitud * -1 WHERE Latitud > 0;
UPDATE `cliente` SET Longitud = Longitud * -1 WHERE Longitud > 0;

UPDATE localidad l 
	JOIN (	SELECT IdLocalidad, AVG(Latitud) AS Latitud
			FROM cliente WHERE Latitud <> 0 
			GROUP BY IdLocalidad) c
	ON (l.IdLocalidad = c.IdLocalidad)
SET l.Latitud = c.Latitud;

UPDATE localidad l 
	JOIN (	SELECT IdLocalidad, AVG(Longitud) AS Longitud
			FROM cliente WHERE Longitud <> 0 
			GROUP BY IdLocalidad) c
	ON (l.IdLocalidad = c.IdLocalidad)
SET l.Longitud = c.Longitud;

UPDATE cliente c JOIN localidad l
	ON (c.IdLocalidad = l.IdLocalidad)
SET c.Latitud = l.Latitud
WHERE c.Latitud = 0;

UPDATE cliente c JOIN localidad l
	ON (c.IdLocalidad = l.IdLocalidad)
SET c.Longitud = l.Longitud
WHERE c.Longitud = 0; 

SELECT v.*, SQRT( (c.Latitud - s.Latitud) * (c.Latitud - s.Latitud) + (c.Longitud - s.Longitud) * (c.Longitud - s.Longitud) ) * 111.1 as Dist
FROM venta v JOIN cliente c
		ON (v.IdCliente = c.IdCliente)
    JOIN sucursal s
    	ON (v.IdSucursal = s.IdSucursal);
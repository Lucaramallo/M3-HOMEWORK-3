/*
## Homework

1) Aplicar alguna técnica de detección de Outliers en la tabla ventas, sobre los campos Precio y Cantidad.
Realizar diversas consultas para verificar la importancia de haber detectado Outliers. Por ejemplo ventas por sucursal en un período teniendo en cuenta outliers y descartándolos.
2) Es necesario armar un proceso, mediante el cual podamos integrar todas las fuentes, aplicar las transformaciones o reglas de negocio necesarias a los datos y generar el modelo final que va a ser consumido desde los reportes. 
Este proceso debe ser claro y autodocumentado.
¿Se puede armar un esquema, donde sea posible detectar con mayor facilidad futuros errores en los datos?
3) Elaborar 3 KPIs del negocio. Tener en cuenta que deben ser métricas fácilmente graficables, por lo tanto debemos asegurarnos de contar con los datos adecuados.
¿Necesito tener el claro las métricas que voy a utilizar? 
¿La métrica necesaria debe tener algún filtro en especial? 
La Meta que se definió ¿se calcula con la misma métrica?
*/

USE henry_m3;
-- 1) Aplicar alguna técnica de detección de Outliers en la tabla ventas, 
-- sobre los campos Precio y Cantidad.
/*

### Diagrama de Caja:

El Diagrama de Caja permite observar la distribución
completa de los datos al mismo tiempo que su mediana y sus cuartiles.
También, muestra los elementos que se escapan del universo, los outliers.

Rango intercuartílico o IQR = 

* mínimo = Q1 - 1.5 x IQR
* máximo = Q3 + 1.5 x IQR


### Regla de las tres sigmas:

La Regla de las Tres Sigmas se basa en el valor promedio y la desviación estándar para obtener el rango, fuera del cual, podemos asumir que un valor es atípico.

* mínimo = Promedio – 3 * Desviación Estándar
* máximo = Promedio + 3 * Desviación Estándar
*/

-- Calculo de rango intercuartilico:
-- 0 Estudio la Tabla a analizar.
-- 1 Ordeno de mayor a menor los datos,
SELECT * 
FROM venta
ORDER BY Precio DESC;
-- Cuento la cantidad de registros en la columna de interes para saber si es par o impar.
/*
Si el número total de valores es impar, entonces la mediana es el valor en la posición (n+1)/2,
donde n es el número total de valores. Si el número total de valores es par, 
entonces la mediana es la media de los valores en las posiciones n/2 y (n/2)+1 

*/



-- DEBO HACER AMBOS CAMINOS; PAR IMPAR; Y LUEGO ANIDARLOS EN UN IF






-- Realizar diversas consultas para verificar la importancia de haber detectado Outliers.
-- Por ejemplo ventas por sucursal en un período teniendo en cuenta outliers y descartándolos.
 

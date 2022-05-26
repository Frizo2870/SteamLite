

--Cosultas basicas de una tabla, SQL basico

Select * from ratingjuegos;
Select * from clientes;



select * from ratingjuegos
--
--Consulta utilizando inner join sobre 2 tablas y utilizando la funcion rank() SQL Avanzado

Select ratingjuegos.id,juegos.nombre,ratingjuegos.rating, rank() over(order by ratingjuegos.rating) from juegos
inner JOIN ratingjuegos on juegos.id=ratingjuegos.id;
--

--Consulta ordenando ascendentemente los juegos. SQL BAsico
select * from juegos order by precio ASC;
--
Consulta con inner joins para determinar juegos de cierta categoria, publicador o desarrollador. SQL Intermedio
Select juegos.id,juegos.nombre,juegos.precio,juegos.fecha_salida,juegos.descripcion,categoria_juegos.categoria
from juegos inner join categoria_juegos on juegos.id=categoria_juegos.id_juego
where categoria_juegos.categoria='Horror';

Select juegos.id,juegos.nombre,juegos.precio,juegos.fecha_salida,juegos.descripcion, desarrolladorjuegos.id_des,
desarrolladores.nombre from (juegos inner join desarrolladorjuegos on juegos.id=desarrolladorjuegos.id) inner join desarrolladores on
desarrolladorjuegos.id_des=desarrolladores.id where desarrolladores.nombre='Tadorna tadorna';

Select juegos.id,juegos.nombre,juegos.precio,juegos.fecha_salida,juegos.descripcion, publicadorjuegos.id_publicador,
publicadores.nombre from (juegos inner join publicadorjuegos on juegos.id=publicadorjuegos.id) inner join publicadores on
publicadorjuegos.id_publicador=publicadores.id where publicadores.nombre='Suricate';
---
--Consultas con operaciones de tiempo para determinar tiempo de juego de un usuario y tiempo de juego de una semana de los juegos. SQL Avanzado

SELECT ID_Usuario, ID_juego, sum(extract (hour from(hora_final - hora_inicio))) as playtime_total_usuario from jugando
where ID_usuario=81 and ID_juego=89 Group by ID_usuario, ID_juego;

SELECT ID_juego, sum(extract (hour from(hora_final - hora_inicio))) as playtime, rank() over(order by sum(extract (hour from(hora_final - hora_inicio))) DESC)
from jugando where hora_inicio BETWEEN now()- Interval '7 day' and now() Group by ID_juego;

--Consulta para ver todos los juegos de Horror. SQL basico
SELECT *from categoria_juegos WHERE categoria='Horror';

--
SELECT * from categoria_juegos WHERE categoria='Horror'

UNION

SELECT * from categoria_juegos WHERE categoria='Action';

-- Consulta para ver juegos de Horror y de Action

SELECT juegos.nombre, precio

from categoria_juegos INNER JOIN juegos

ON categoria_juegos.id_juego=juegos.id

WHERE categoria='Horror'

INTERSECT

SELECT juegos.nombre, precio

from categoria_juegos INNER JOIN juegos

ON categoria_juegos.id_juego=juegos.id

WHERE categoria='Action';

-- Consulta para ver todos los juegos excepto los de Horror
SELECT *from Categoria_juegos

EXCEPT

SELECT *from Categoria_juegos WHERE categoria='Horror';

-- Creacion de vista para ver juegos con un rating de 4

CREATE VIEW vista1 AS SELECT * from Colleccion_usuario WHERE Rating_ind=4










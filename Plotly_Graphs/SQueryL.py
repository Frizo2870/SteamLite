############################
# BASIC LEVEL
############################

# Selecion Juegos
def SelectJuegos():
    return """SELECT * FROM Juegos"""

# Selecion x categoria
def SelectCat():
    return """SELECT *from categoria_juegos WHERE categoria='Horror'"""

# Select Cat: Horror U Action
def SelectCat_Horr_Act():
    return """
    SELECT * from categoria_juegos WHERE categoria='Horror'

    UNION

    SELECT * from categoria_juegos WHERE categoria='Action'"""

############################
# INTERMEDIATE LEVEL
############################
# Juegos con = ID en clientes
def id_cliente_juego():
    return """
    SELECT clientes.nombre,juegos.nombre AS nombre_juego from clientes Inner JOIN juegos ON clientes.ID=juegos.ID
    """

# Select Cat != Horror
def SelectCat_difHorror():
    return """
    SELECT *
    from Categoria_juegos

    EXCEPT

    SELECT *
    from Categoria_juegos WHERE
    categoria = 'Horror'
    """

# Promedio x Categoria
def PromxCat():
    return """
    Create or REPLACE FUNCTION AVG_tabla()

RETURNS table(cat VARCHAR(90),promedio numeric(10,2))

LANGUAGE 'plpgsql'

as $$

BEGIN

RETURN QUERY

SELECT categoria, AVG(precio)

from categoria_juegos INNER JOIN juegos

ON categoria_juegos.id_juego =juegos.id

GROUP BY categoria;

END;

$$;

SELECT * FROM AVG_tabla()
    """

# Ranging 15 juegos mas caros

def rank_funtion():
    return """
SELECT ID_juego, sum(extract (hour from(hora_final - hora_inicio))) as playtime, rank() over(order by sum(extract (hour from(hora_final - hora_inicio))) DESC)
from jugando where hora_inicio BETWEEN now()- Interval '7 day' and now() Group by ID_juego;
    """

############################
# ADVANCE LEVEL
############################
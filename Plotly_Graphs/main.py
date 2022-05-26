import plotly.express as px
import pandas as pd
from Connection import Connection
import SQueryL as sql
con = Connection()
con.openConnection()

"""BASIC LEVEL"""

####################################################################
# SELECT *´JUEGOS
####################################################################
query = pd.read_sql_query(sql.SelectJuegos(), con.connection)
dfCases = pd.DataFrame(query, columns=["id", "nombre", "precio"])
# Caja de vigotes
figBarCases = px.box(dfCases, x="precio")
#figBarCases.show()

####################################################################
# SELECT *´JUEGOxCategoria
####################################################################
query = pd.read_sql_query(sql.SelectCat(), con.connection)
dfCases = pd.DataFrame(query, columns=["id_juego",  "categoria"])
# Grafico barras
figBarCases = px.line(dfCases, x="id_juego",y="categoria")
#figBarCases.show()

####################################################################
# SELECT * Cat:Horror U Action
####################################################################
query = pd.read_sql_query(sql.SelectCat_Horr_Act(), con.connection)
dfCases = pd.DataFrame(query, columns=["id_juego",  "categoria"])
# Grafico barras
figBarCases = px.bar(dfCases, x="id_juego",y="categoria")
#figBarCases.show()


####################################################################
# SELECT * Cat:Horror U Action
####################################################################
query = pd.read_sql_query(sql.SelectCat_difHorror(), con.connection)
dfCases = pd.DataFrame(query, columns=["id_juego",  "categoria"])
# Grafico barras
figBarCases = px.bar(dfCases, x="id_juego",y="categoria")
#figBarCases.show()


"""INTERMEDIATE LEVEL"""

####################################################################
# SELECT * ID = en juego y cliente
####################################################################
query = pd.read_sql_query(sql.id_cliente_juego(), con.connection)
dfCases = pd.DataFrame(query, columns=["nombre",  "nombre_juego"])
# Grafico barras
figBarCases = px.line(dfCases, x="nombre",y="nombre_juego")
#figBarCases.show()

####################################################################
# SELECT * Promedio x categoria
####################################################################
query = pd.read_sql_query(sql.PromxCat(), con.connection)
dfCases = pd.DataFrame(query, columns=["cat",  "promedio"])
# Grafico barras
figBarCases = px.line(dfCases, x="cat",y="promedio")
#figBarCases.show()
#################


####################################################################
# SELECT 15 precios mas caros en juegos
####################################################################
query = pd.read_sql_query(sql.rank_funtion(), con.connection)
dfCases = pd.DataFrame(query, columns=["id_juego",  "playtime","rank"])
print(dfCases)
# Grafico barras
figBarCases = px.pie(dfCases, values="id_juego",names="rank")
figBarCases.show()





####################################################################
####################################################################
con.closeConnection()
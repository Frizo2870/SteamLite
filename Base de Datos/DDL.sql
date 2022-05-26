Drop table if EXISTS Clientes CASCADE;
Drop table if EXISTS juegos CASCADE;
Drop table if EXISTS categoria_juegos CASCADE;
Drop table if EXISTS coleccion_usuario CASCADE;
Drop table if EXISTS desarrolladores CASCADE;
Drop table if EXISTS factura CASCADE;
Drop table if EXISTS historial_compras CASCADE;
Drop table if EXISTS jugando CASCADE;
Drop table if EXISTS ofertas CASCADE;
Drop table if EXISTS desarrolladorjuegos CASCADE;
Drop table if EXISTS publicadorjuegos CASCADE;
Drop table if EXISTS publicadores CASCADE;
drop table if exists ratingjuegos cascade;
drop table if exists buy_attempt cascade;

--Principal
Create Table Publicadores(
  Nombre VARCHAR(50) Not NULL,
  Id Serial PRIMARY KEY
  );
 
 Create Table Desarrolladores(
  Nombre VARCHAR(50) Not NULL,
  Id Serial PRIMARY KEY
  );
 
CREATE TABLE Clientes(
  id Serial PRIMARY KEY,
  Email VARCHAR(50) NOT NULL,
  Contraseña VARCHAR(50) Not NULL,
  Nombre VARCHAR(50) NOT NULL,
  Cartera NUMERIC(8,2)NOT NULL CHECK(Cartera>=0)
  );

--Principal
CREATE TABLE Juegos(
  id Serial PRIMARY Key,
  Nombre VARCHAR(50) Not NULL,
  Precio NUMERIC(8,2) not NULL CHECK(Precio>=0),
  Fecha_salida  date Not NULL,
  Descripcion   VARCHAR(300)
  );

Create Table PublicadorJuegos(
  id INTEGER,
  FOREIGN KEY(ID) REFERENCES juegos(id),  
  Id_publicador integer,
  foreign key(Id_publicador) references Publicadores
  );
CREATE Table DesarrolladorJuegos(
  id INTEGER,
  FOREIGN KEY(ID) REFERENCES Juegos(id),
   Id_des integer,
  foreign key(Id_des) references Desarrolladores
  );
Create Table RatingJuegos(
  id INTEGER,
  FOREIGN KEY(ID) REFERENCES juegos(id),  
  Rating SMALLINT check(Rating>=0 and Rating<=10) DEFAULT null
  );
 
--Principal
Create Table Coleccion_usuario (
  ID_usuario INTEGER,
  ID_juego integer ,
  Rating_ind SMALLINT CHECK(Rating_ind>=0 and Rating_ind<=10),
  FOREIGN KEY (ID_usuario) REFERENCES clientes(id),
  FOREIGN KEY (ID_juego) REFERENCES juegos(id)
  );
--Principal
CREATE Table Factura(
  Id_usuario INTEGER REFERENCES Clientes(ID),
  Id_juego INTEGER REFERENCES Juegos(ID) ,
  Id_factura SERIAL PRIMARY key,
  Precio INTEGER,
  fecha timestamp
  );
--Principal

--Principal

--Principal
Create Table Categoria_juegos(
  Id_juego INTEGER REFERENCES Juegos(ID),
  Categoria VARCHAR(50)
  );
--Principal
Create Table Ofertas(
  Id_juego INTEGER Unique REFERENCES Juegos(ID),
  Descuento NUMERIC(2,2)
  );
--Principal

Create table buy_attempt(
  Id_usuario INTEGER REFERENCES Clientes(ID),
  Id_juego INTEGER REFERENCES Juegos(ID)
  );

Create table jugando(
id_usuario integer references Clientes(ID),
id_juego integer references Juegos(ID),
hora_final timestamp default now(),
hora_inicio timestamp default now()-interval '1 hour');

--Trigger encargado de gestionar las compras agregando facturas, juegos a la coleccion y restando el dinero a la cartera. SQL Avanzado

Create or REPLACE FUNCTION compra1()
returns TRIGGER
LANGUAGE 'plpgsql'
as $$
DECLARE
plata INTEGER;
costo INTEGER;
BEGIN
select cartera into plata from clientes where clientes.id=new.id_usuario;
Select precio into costo from juegos where juegos.id=New.id_juego;

if plata-costo>0
    then
      update clientes
      set cartera=cartera-(Select precio from juegos where juegos.id=New.id_juego)
      where clientes.id=new.id_usuario;
         
      insert into factura(id_usuario,id_juego,precio, fecha)
      values (new.id_usuario,new.id_juego,(Select precio from juegos where juegos.id=New.id_juego),now());
     
      insert into coleccion_usuario(id_usuario,id_juego)
      values(New.id_usuario,new.id_juego);
     
end IF;
return new;
end;
$$;

create trigger compra
after insert ON buy_attempt
for each ROW
EXECUTE FUNCTION compra1();

--Trigger encargado de gestionar los nuevos descuentos a agregar. SQL Intermedio

Create function descuento1()
returns TRIGGER
LANGUAGE'plpgsql'
as $$
BEGIN
update juegos set precio=(1-new.descuento)*precio where juegos.id=new.id_juego;

return new;
end
$$;


CREATE trigger descuentos
after insert on ofertas
for each ROW
execute FUNCTION descuento1();
--Trigger encargado de gestionar las expiraciones de las ofertas de juegos. SQL intermedio
Create FUNCTION descuento2()
returns TRIGGER
LANGUAGE'plpgsql'
as $$
BEGIN
update juegos set precio=precio/(1-old.descuento) where juegos.id=old.id_juego;

return new;
end
$$;


CREATE trigger rdescuentos
before DELETE on ofertas
for each ROW
execute FUNCTION descuento2();

--Trigger encargado de promediar los ratings de los juegos de la tabla coleccion_usuario y modificar el rating de ese juego en la tabla de ratingjuegos. SQL intermedio

Create FUNCTION average_rating()
returns TRIGGER
LANGUAGE'plpgsql'
as $$
declare
av INTEGER;
BEGIN
Select avg(rating_ind) Into av from coleccion_usuario where coleccion_usuario.id_juego=new.id_juego;

update ratingjuegos set rating=av where ratingjuegos.id=new.id_juego;

return new;
end
$$;


CREATE trigger uprating
after update of rating_ind on coleccion_usuario
for each ROW
execute FUNCTION average_rating();

--Trigger encargado de agregar los juegos a la tabla ratingjuegos al ingresarlos al sistema. SQL intermedio

Create FUNCTION ratingadd()
returns TRIGGER
LANGUAGE'plpgsql'
as $$
BEGIN
insert into ratingjuegos (id)
VALUES(new.id);

return new;
end
$$;


CREATE trigger plusrating
after INSERT on juegos
for each ROW
execute FUNCTION ratingadd();

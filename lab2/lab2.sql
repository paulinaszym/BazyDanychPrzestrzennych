--create database lab2;
--CREATE EXTENSION postgis;

create table buildings(id int, geometry geometry, name varchar);
create table roads(id int, geometry geometry, name varchar);
create table poi(id int, geometry geometry, name varchar);


--Zadanie 4, 5
insert into buildings values
(1,ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))'),'BuildingA'),
(2,ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))'),'BuildingB'),
(3,ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))'),'BuildingC'),
(4,ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))'),'BuildingD'),
(5,ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))'),'BuildingE');

insert into roads values
( 1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)'),'RoadX'),
( 2, ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)'),'RoadY');

insert into poi values
( 1, ST_GeomFromText('POINT(1 3.5)'),'G'),
( 2, ST_GeomFromText('POINT(5.5 1.5)'),'H'),
( 3, ST_GeomFromText('POINT(9.5 6)'),'I'),
( 4, ST_GeomFromText('POINT(6.5 6)'),'J'),
( 5, ST_GeomFromText('POINT(6 9.5)'),'K')

--Zadanie 6
--a
select sum(ST_Length(geometry)) from roads;

--b
select ST_ASTEXT(geometry) , ST_Area(geometry), ST_Perimeter(geometry) from buildings where name='BuildingA';

--c
select NAME,  ST_Area(geometry) from buildings order by name;

--d
select NAME,  ST_Perimeter(geometry) from buildings order by ST_Area(geometry) desc limit 2;

--e
select ST_Distance(buildings.geometry, poi.geometry) from buildings, poi where buildings.name='BuildingC' and poi.name='K';

--f
select ST_Area(ST_Difference((select geometry from buildings where name='BuildingC'), ST_Buffer((select geometry from buildings where name='BuildingB'), 0.5)));

--g
select name from buildings where ST_Y(ST_Centroid(geometry)) > ST_Y(ST_Centroid((select geometry from roads where name='RoadX')));

--h
select ST_Area(ST_SymDifference((select geometry from buildings where name='BuildingC'),ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')))
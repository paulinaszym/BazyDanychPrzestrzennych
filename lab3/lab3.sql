--Zadanie 1
select b2019.gid, b2019.polygon_id, b2019.name, b2019.type, b2019.height, ST_AsText(b2019.geom) FROM buildings2019 b2019
left join buildings2018  b2018 ON b2018.geom = b2019.geom
where b2018.gid is null;

--Zadanie 2
with new_buildings as (
	select b2019.gid, b2019.polygon_id, b2019.name, b2019.type, b2019.height, b2019.geom FROM buildings2019 b2019
	LEFT JOIN buildings2018  b2018 ON b2018.geom = b2019.geom
	WHERE b2018.gid is null 
),
new_poi as(
	select p2019.gid,p2019.poi_id,p2019.link_id, p2019.poi_name ,p2019.st_name, p2019.lat ,p2019."type",p2019.lon, p2019.geom
	from poi2019 p2019 
	left join poi2018 p2018 on p2018.geom = p2019.geom
	where p2018.gid is null 
),
zad2 as (
select poi.type
from new_poi poi
join new_buildings b on ST_Intersects(poi.geom, ST_Buffer(b.geom,0.005))
)

select type, count(*) from zad2 group by type;

--Zadanie 3
 create table  streets_reprojected(gid int primary key, link_id float8, st_name varchar(254), ref_in_id float8,
	  			    nref_in_id float8, func_class varchar(1), speed_cat varchar(1), 
				    fr_speed_I float8, to_speed_I float8, dir_travel varchar(1), geom geometry);

   insert into streets_reprojected 
   select gid, link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, 
	  fr_speed_l, to_speed_l, dir_travel, ST_Transform(ST_SetSRID(geom,4326), 3068)
   from streets2019 ;
   
  select * from streets_reprojected;
  
 --Zadanie 4
 create table input_points(id int primary key,name varchar(50),geom geometry);
 
insert into input_points values
    (1, 'point1', 'POINT(8.36093 49.03174)'),
    (2, 'point2', 'POINT(8.39876 49.00644)');
    
--Zadanie 5
update input_points
set geom = ST_Transform(ST_SetSRID(geom,4326), 3068);

--Zadanie 6
update streetnode2019
set geom = ST_Transform(ST_SetSRID(geom,4326), 3068);
   
with lines as(
	select st_makeline(geom) as l from input_points ip
)

select *
from streetnode2019 CROSS JOIN lines
WHERE ST_Contains(ST_Buffer(lines.l, 0.002),streetnode2019.geom);

--Zadanie 7
with parks as(
	select ST_Buffer(geom,0.003) as buf from landuseA2019 luA 
	where type='Park (City/County)'
)

 select count(*) from poi2019 poi
   CROSS JOIN parks p
   WHERE poi.type ='Sporting Goods Store'
   AND ST_Contains(p.buf, poi.geom);
   
  --Zadanie 8
   select ST_Intersection(r.geom, w.geom) as geom
   into T2019_KAR_BRIDGES
   from railways2019 r
   join waterlines2019 w
	ON ST_Intersects(r.geom, w.geom);
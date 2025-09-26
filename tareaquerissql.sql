2--Muestra los nombres de todas las películas con una clasificación por 
--edades de ‘Rʼ.

select f.title 
from film f 
where rating = 'R';

3--Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 
--y 40

select  actor_id, first_name
from actor
where actor_id  between 30 and 40;

4--Obtén las películas cuyo idioma coincide con el idioma original.

select  f. film_id, f. title , l. name as idioma
from film f 
join language l on  f.language_id = l.language_id
where f.original_language_id is null;
  

5--Ordena las películas por duración de forma ascendente.

select title, length
from film 
order by length asc;

6--Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su 
--apellido.--

select first_name, last_name
from actor
where last_name ilike '%Allen%';


7--Encuentra la cantidad total de películas en cada clasificación de la tabla 
--“filmˮ y muestra la clasificación junto con el recuento

select rating, count(*) as total_peliculas
from film
group by rating;

8-- Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una 
--duración mayor a 3 horas en la tabla film.

select title
from film f 
where f.rating = 'PG-13' or f.length >180;

9--Encuentra la variabilidad de lo que costaría reemplazar las películas.

select stddev(f.replacement_cost ) as REEMPLAZAR_PELICULAS
from film f ;
 
10--Encuentra la mayor y menor duración de una película de nuestra BBDD.

select min(f.length) as duración_minima,
	   max(f.length) as duración_maxima
from film f ;

11-- Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

select p.amount as costo_antepenultimo_alquiler
from rental r
join payment p on r.rental_id = p.rental_id
order by r.rental_date desc
limit 5 offset 2 ;

12--Encuentra el título de las películas en la tabla “filmˮ que no sean ni 'NC-17'
 --ni ‘Gʼ en cuanto a su clasificación.

select f.title 
from film f 
where f.rating   
	not in ('NC-17', 'G');


13--Encuentra el promedio de duración de las películas para cada 
--clasificación de la tabla film y muestra la clasificación junto con el 
--promedio de duración.
 
select rating, round(avg(f.length ),(2)) as promedio_redondeado
from film f 
group by rating;
	
14--Encuentra el título de todas las películas que tengan una duración mayor 
--a 180 minutos.

select *
from film f 
where f.length >180;

15-- ¿Cuánto dinero ha generado en total la empresa?

select sum(amount) as total_dinero
from payment p ;

16--Muestra los 10 clientes con mayor valor de id.
select *
from customer c 
order by customer_id desc 
limit 11;

17-- Encuentra el nombre y apellido de los actores que aparecen en la 
--película con título ‘Egg Igbyʼ

select a.first_name ,a.last_name 
from actor a 
join film_actor fa on a.actor_id = fa.actor_id 
join film f ON fa.film_id = f.film_id
where f.title  = 'Egg Igby';

18--Selecciona todos los nombres de las películas únicos.

select f.title 
from film f ;

 19--Encuentra el título de las películas que son comedias y tienen una 
--duración mayor a  minutos en la tabla “filmˮ.

select f.title 
from film f 
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Comedy'
and f.length > 180;


20--Encuentra las categorías de películas que tienen un promedio de 
--duración superior a 110 minutos y muestra el nombre de la categoría 
--junto con el promedio de duración.

select
    c.name as categoria,
    avg(f.length) as promedio_duracion
from category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
group by c.name
having avg(f.length) > 110
order by promedio_duracion desc;


21-- ¿Cuál es la media de duración del alquiler de las películas?

select avg(f.rental_duration) as duracion_alquiler
from film f ;

22--Crea una columna con el nombre y apellidos de todos los actores y 
--actrices.

select concat(first_name, ' ', last_name) as nombre_completo
from actor;

23--Números de alquiler por día, ordenados por cantidad de alquiler de 
--forma descendente.

select rental_date::date as fecha_alquiler,
       count(*) as cantidad_alquileres
from  rental
group by  rental_date::date
order by cantidad_alquileres desc;

24-- Encuentra las películas con una duración superior al promedio.

select film.*, avg_duracion.promedio
from film
join (
	 select avg(length ) as promedio
	 from film
	) avg_duracion on length > avg_duracion.promedio;


25--Averigua el número de alquileres registrados por mes.
	

select
    date_trunc('month', rental_date) as mes,
    count(*) as total_alquileres
from rental
group by date_trunc('month', rental_date)
order by mes;


26-- Encuentra el promedio, la desviación estándar y varianza del total 
--pagado.

select round(AVG("amount"),2) as promedio_redonedeado,
round(stddev("amount"),2) as desviacion_estandar,
round(variance("amount"),2) as varianza_total
from payment p ;

27-- ¿Qué películas se alquilan por encima del precio medio?

select f.title,
    f.rental_rate
from film f
where f.rental_rate > (
        select avg(rental_rate) 
        from film f2 
    );

28--Muestra el id de los actores que hayan participado en más de 40 
--películas.

select fa.actor_id 
from film_actor fa 
group by actor_id 
having count(fa.film_id ) >40;

 29--Obtener todas las películas y, si están disponibles en el inventario, 
--mostrar la cantidad disponible.

select 
    f.title as Título,
    count(i.inventory_id) as Cantidad_Disponible
from  
    film f
left join inventory i on f.film_id = i.film_id
group by f.film_id, f.title
order by f.title;


30--Obtener los actores y el número de películas en las que ha actuado
 
select 
    a.first_name as nombre,
    a.last_name as apellido,
    count(fa.film_id ) as numero_de_peliculas
from actor a
join  film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name
order by numero_de_peliculas desc;

31--Obtener todas las películas y mostrar los actores que han actuado en 
--ellas, incluso si algunas películas no tienen actores asociados.

select 
    f.title as pelicula,
    a.first_name as actor_nombre,
    a.last_name as actor_apellido
from film f
left join film_actor fa on f.film_id = fa.film_id
left joinactor a on fa.actor_id = a.actor_id
order by f.title, a.last_name, a.first_name;
 
32--Obtener todos los actores y mostrar las películas en las que han 
--actuado, incluso si algunos actores no han actuado en ninguna película.

 select
    a.first_name,
    a.last_name,
    f.title
from actor a
left join  film_actor fa on a.actor_id = fa.actor_id
left join film f on fa.film_id = f.film_id
order by a.last_name, a.first_name, f.title;

33--Obtener todas las películas que tenemos y todos los registros de 
--alquiler.

 select
    f.title,
    r.rental_date,
    r.return_date,
    c.first_name as cliente_nombre,
    c.last_name as cliente_apellido
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join customer c on r.customer_id = c.customer_id
order by   r.rental_date desc;


34--Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

select c.customer_id ,c.first_name, ' ', c.last_name,
	   sum(p.amount) as total_gastado
from customer c 
join payment p on c.customer_id = p.customer_id
group by  c.customer_id, c.first_name, c.last_name
order by total_gastado desc
limit 5;
 
35--Selecciona todos los actores cuyo primer nombre es 'Johnny'.

select a.first_name, a.last_name 
from actor a 
where a.first_name ilike '%Johnny%'
order by last_name, first_name;

 
36--Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como 
--Apellido

select "first_name" as Nombre ,"last_name" as Apellido
from actor a ;

37--Encuentra el ID del actor más bajo y más alto en la tabla actor.

select min (a.actor_id ) as id_bajo, max(a.actor_id )as id_bajo
from actor a ;

38--Cuenta cuántos actores hay en la tabla “actorˮ.

select count(a.actor_id )
from actor a ;

39--Selecciona todos los actores y ordénalos por apellido en orden 
--ascendente.

select *
from actor a 
order by "last_name" desc ;

40-- Selecciona las primeras 5 películas de la tabla “filmˮ.

select f.film_id , f.title 
from film f 
order by "title" asc 
limit 5;

41--Agrupa los actores por su nombre y cuenta cuántos actores tienen el 
--mismo nombre. ¿Cuál es el nombre más repetido?

select a.first_name ,  count (*) as cantidad
from actor a 
group by a.first_name 
order by cantidad desc ;

42-- Encuentra todos los alquileres y los nombres de los clientes que los 
--realizaron.

select 
  rental.rental_id,
  rental.rental_date,
  customer.first_name,
  customer.last_name
from rental
join customer on rental.customer_id = customer.customer_id
order by rental.rental_date;


43--Muestra todos los clientes y sus alquileres si existen, incluyendo 
--aquellos que no tienen alquileres.

select  
    c.customer_id,
    c.first_name,
    c.last_name,
    r.rental_id,
    r.rental_date,
    r.return_date
from  customer c 
left join rental r  on c.customer_id  = c.customer_id;


44-- Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor 
--esta consulta? ¿Por qué? Deja después de la consulta la contestación.

select  *
from  film
cross join category;

- No aporta valor práctico. Devuelve muchos datos y muchos no tienen ningún sentido.

45-- Encuentra los actores que han participado en películas de la categoría 
--'Action'.

select distinct  
    a.first_name,
    a.last_name
from  actor a
join film_actor fa on a.actor_id = fa.actor_id
join film_category fc on fa.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Action'
order by a.last_name, a.first_name;

46-- Encuentra todos los actores que no han participado en películas.

select a.actor_id, a.first_name, a.last_name
from actor a
left join film_actor fa on a.actor_id = fa.actor_id
where fa.film_id is null;

47-- Selecciona el nombre de los actores y la cantidad de películas en las 
--que han participado.

select a.first_name, a.last_name, count(fa.film_id) as cantidad_peliculas
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name
order by cantidad_peliculas desc;

48--Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres 
--de los actores y el número de películas en las que han participado.

create view actor_num_peliculas as
select 
    a.first_name,
    a.last_name,
    count(fa.film_id) as num_peliculas
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name
order by a.last_name, a.first_name;



49--Calcula el número total de alquileres realizados por cada cliente.

select count(r.rental_id) as total_alquileres, r.customer_id 
from rental r 
group by customer_id

50--Calcula la duración total de las películas en la categoría 'Action'.

select sum(f.length ) as duracion_total
from film f 
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c. name = 'Action'


 51--Crea una tabla temporal llamada “cliente_rentas_temporalˮ para 
--almacenar el total de alquileres por cliente.

 create temporary table "cliente_rentas_temporal" as (
	select customer_id, 
		count(*) as total_ventas
	from rental r 
	group by customer_id 
)
;

 52--Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las 
--películas que han sido alquiladas al menos 10 veces.

create temporary table peliculas_alquiladas as
select
    f.film_id,
    f.title,
    count(r.rental_id) AS total_alquileres
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.film_id, f.title
having count(r.rental_id) >= 10;

53-- Encuentra el título de las películas que han sido alquiladas por el cliente 
--con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena 
--los resultados alfabéticamente por título de película.

select f.title 
from customer c 
join rental r on c.customer_id = r.customer_id
join inventory i ON r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
where  c.first_name = 'Tammy'
    and c.last_name = 'Sanders'
    and r.return_date is null
order by f.title asc;


54-- Encuentra los nombres de los actores que han actuado en al menos una 
--película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados 
--alfabéticamente por apellido.

select a.first_name, a.last_name 
from actor a 
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c."name"    = 'Sci-Fi'
order by a.last_name asc, a.first_name asc ;
 
55-- Encuentra el nombre y apellido de los actores que han actuado en 
--películas que se alquilaron después de que la película ‘Spartacus 
--Cheaperʼ se alquilara por primera vez. Ordena los resultados 
--alfabéticamente por apellido.

with ref as (
  select min(r.rental_date) as primera_rental
  from film f
  join  inventory i on f.film_id = i.film_id
  join	 rental r on i.inventory_id = r.inventory_id
  where f.title ilike '%spartacus%' and f.title ilike '%cheaper%'
)
select distinct a.first_name, a.last_name
from  actor a
join  film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join ref on ref.primera_rental is not null
where r.rental_date > ref.primera_rental   -- cambia a >= si quieres incluir el mismo día
order by a.last_name asc;


 56-- Encuentra el nombre y apellido de los actores que no han actuado en 
--ninguna película de la categoría ‘Musicʼ.

select a.first_name, a.last_name 
from actor a 
where a.actor_id not in (
	select 	fa.actor_id 
	from film_actor fa 
	join film_category fc on fa.film_id = fc.film_id
	join category c on fc.category_id = c.category_id
	where c.name = 'Music'
)
order by a.last_name, a.first_name;

 57-- Encuentra el título de todas las películas que fueron alquiladas por más 
--de 8 días.

select distinct f.title
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
where r.return_date is not null
  and r.return_date - r.rental_date > interval '8 days';

 58--Encuentra el título de todas las películas que son de la misma categoría 
--que ‘Animationʼ.

select f.title 
from film f 
join film_category fc on f.film_id = fc.film_id 
where fc.category_id  = (
	select category_id
	from category
	where name = 'Animation'
order by f.title asc
);

  

 59-- Encuentra los nombres de las películas que tienen la misma duración 
--que la película con el título ‘Dancing Feverʼ. Ordena los resultados 
--alfabéticamente por título de película.

select f.title 
from film f 
where f.length  in (
    select f.length 
    from film f
    where title ilike '%dancing fever%'
)
order by title;



 60--Encuentra los nombres de los clientes que han alquilado al menos 7 
--películas distintas. Ordena los resultados alfabéticamente por apellido.

select  c.first_name, c.last_name
from customer c
join  rental r on c.customer_id = r.customer_id
join  inventory i on  r.inventory_id = i.inventory_id
join	 film f on  i.film_id = f.film_id
group by  c.customer_id, c.first_name, c.last_name
having count(distinct f.film_id) >= 7
order by  c.last_name asc;

 61--Encuentra la cantidad total de películas alquiladas por categoría y 
--muestra el nombre de la categoría junto con el recuento de alquileres.


select 
    cat.name as categoria,
    count(r.rental_id) as total_alquileres
from  rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category cat on fc.category_id = cat.category_id
group by cat.name
order by total_alquileres desc;

 62--Encuentra el número de películas por categoría estrenadas en 2006.


select 
    c.name as categoria,
    count(f.film_id) as numero_peliculas
from film f
join  film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where f.release_year = 2006
group by c.name
order by numero_peliculas desc;

 63--Obtén todas las combinaciones posibles de trabajadores con las tiendas 
--que tenemos.

select 
    s.staff_id,
    s.first_name,
    s.last_name,
    st.store_id
from staff s
cross join store st;

 64-- Encuentra la cantidad total de películas alquiladas por cada cliente y 
--muestra el ID del cliente, su nombre y apellido junto con la cantidad de 
--películas alquiladas.

select  c. customer_id,
		c. first_name,
		c. last_name,
		count(r. rental_id) as total_peliculas_alquiladas
from customer c 
join rental r  on c. customer_id = r.customer_id 
group by c. customer_id , c. first_name, c. last_name 
order by total_peliculas_alquiladas desc;





--las consultas se me dan fatal, me he ayudado de la inteligencia artificial,
--porque sino no acabo el curso pero en cuanto tenga tiempo 
--profundizo mas o busco un tutor presencial que me explique bien. porque con ayuda 
--me ha costado varias semanas hacer estas preguntas imagine sin....







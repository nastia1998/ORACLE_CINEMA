-- grant create view to cinema_admin
create view cinemas_view as
    select * from cinema_admin.cinema;

select * from cinema_admin.cinemas_view;

create view cinemas_and_halls_view as
    select cinema.name, cinema.address, cinema_hall.rows_count, cinema_hall.places_count
    from cinema join cinema_hall
    on cinema.id = cinema_hall.cinema_id;
    
select * from cinemas_and_halls_view;
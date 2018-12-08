-- grant create view to cinema_admin
create view cinemas_view as
    select * from cinema_admin.cinema;
    
drop view cinemas_view;

select * from cinema_admin.cinemas_view;

create view cinemas_and_halls_view as
    select cinema.name, cinema.address, cinema_hall.rows_count, cinema_hall.places_count
    from cinema join cinema_hall
    on cinema.id = cinema_hall.cinema_id;
    
select * from cinemas_and_halls_view;

create view cinema_admin.show_all_seances as
    select cinema.name, cinema.address , movie.title, seance.timetable from cinema_admin.cinema
    join cinema_admin.cinema_hall on cinema.id = cinema_hall.cinema_id
    join cinema_admin.seance on cinema_hall.id = seance.cinema_hall_id
    join cinema_admin.movie on seance.movie_id = movie.id;
    
select * from cinema_admin.show_all_seances;



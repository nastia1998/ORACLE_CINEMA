-- grant create procedure to cinema_admin;
create procedure cinema_admin.add_cinema (name_cinema in nvarchar2, address_cinema in nvarchar2) as
    begin
        insert into cinema (name, address)
        values (name_cinema, address_cinema);
    end;
/
drop procedure cinema_admin.add_cinema;

-- grant insert on cinema_admin.cinema to cinema_admin;
-- alter user cinema_admin quouta unlimited on TS_CINEMA;
begin
    cinema_admin.add_cinema('Октябрь', 'проспект Независимости 73, Минск 220013');
    cinema_admin.add_cinema('Москва', 'г.Минск, пр-т Победителей, 13');
    cinema_admin.add_cinema('Беларусь', 'ул. Романовская Слобода д.28, Минск 220004');
end;

create procedure cinema_admin.add_cinema_hall (cinema_id_a number, rows_count_a number, places_count_a number) as
    begin
        insert into cinema_admin.cinema_hall (cinema_id, rows_count, places_count)
        values (cinema_id_a, rows_count_a, places_count_a);
    end;
/
drop procedure cinema_admin.add_cinema_hall;

begin
    cinema_admin.add_cinema_hall(1, 10, 10);
    cinema_admin.add_cinema_hall(2, 10, 15);
    cinema_admin.add_cinema_hall(3, 15, 30);
end;

create procedure cinema_admin.add_movie (title_movie nvarchar2) as
    begin
        insert into cinema_admin.movie (title)
        values (title_movie);
    end;
/
drop procedure cinema_admin.add_movie;

begin
    cinema_admin.add_movie('Чудо');
    cinema_admin.add_movie('Приключения Паддингтона');
    cinema_admin.add_movie('Джон Уик 2');
    cinema_admin.add_movie('Доктор Стрэндж');
    cinema_admin.add_movie('Дыши во мгле');
end;

create procedure cinema_admin.add_genre (name_genre nvarchar2) as
    begin
        insert into cinema_admin.genre (name)
        values (name_genre);
    end;
/

begin
    cinema_admin.add_genre('драма');
    cinema_admin.add_genre('комедия');
    cinema_admin.add_genre('триллер');
    cinema_admin.add_genre('фантастика');
end;

create procedure cinema_admin.add_movie_genre (movie_id_a number, genre_id_a number) as
    begin
        insert into cinema_admin.movie_genre (movie_id, genre_id)
        values (movie_id_a, genre_id_a);
    end;
/

begin
    cinema_admin.add_movie_genre (1, 1);
    cinema_admin.add_movie_genre (2, 2);
    cinema_admin.add_movie_genre (3, 3);
    cinema_admin.add_movie_genre (4, 4);
    cinema_admin.add_movie_genre (5, 4);
end;

create procedure cinema_admin.add_customer (login_a nvarchar2, password_a nvarchar2, email_a varchar2) as
    begin
        insert into cinema_admin.customer (login, password, email)
        values (login_a, password_a, email_a);
    end;
/

begin 
    cinema_admin.add_customer ('nastia2211', '123', 'nastia@gmail.com');
    cinema_admin.add_customer ('oleg1972', '987', 'oleg@gmail.com');
end;

create procedure cinema_admin.add_seance (cinema_hall_id_a number, movie_id_a number, timetable_a date) as
    begin
        insert into cinema_admin.seance (cinema_hall_id, movie_id, timetable)
        values (cinema_hall_id_a, movie_id_a, timetable_a);
    end;
/

begin
    cinema_admin.add_seance (1, 1, '28-10-1999');
    cinema_admin.add_seance (1, 1, '30-05-2003');
end;

create procedure cinema_admin.book_place 
(customer_id_a number, booking_date_a date, place_row number, place_place number, cost_a float, seance_id number) is
    p_id number;
    b_id number;
    begin
        insert into cinema_admin.booking (customer_id, booking_date)
        values (customer_id_a, booking_date_a);
        insert into cinema_admin.place (roww, place, cost, seance_id)
        values (place_row, place_place, cost_a, seance_id);
        
        insert into cinema_admin.booked_places (place_id, booking_id)
        values ((select id from cinema_admin.place where
    end;


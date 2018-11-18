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
    cinema_admin.add_genre('драма');
end;

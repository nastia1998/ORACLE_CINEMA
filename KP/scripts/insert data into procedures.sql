-- grant insert on cinema_admin.cinema to cinema_admin;
-- alter user cinema_admin quouta unlimited on TS_CINEMA;
begin
    cinema_admin.add_cinema('Октябрь', 'проспект Независимости 73, Минск 220013');
    cinema_admin.add_cinema('Москва', 'г.Минск, пр-т Победителей, 13');
    cinema_admin.add_cinema('Беларусь', 'ул. Романовская Слобода д.28, Минск 220004');
    cinema_admin.add_cinema('Беларус', 'ул. Романовская Слобода д.28, Минск 220004');
end;
select * from cinema_admin.cinema;
delete from cinema_admin.seance;
delete from cinema_admin.cinema_hall;
delete from cinema_admin.cinema;



begin
    cinema_admin.add_cinema_hall(4, 'Золотой', 10, 10);
    cinema_admin.add_cinema_hall(2, 'Платина', 10, 15);
    cinema_admin.add_cinema_hall(20, 'Бирюза', 15, 30);
    cinema_admin.add_cinema_hall(2, 'Платина', 10, 15);
end;
select * from cinema_admin.cinema_hall;



begin
    cinema_admin.add_movie('Чудо');
    cinema_admin.add_movie('Приключения Паддингтона');
    cinema_admin.add_movie('Джон Уик 2');
    cinema_admin.add_movie('Доктор Стрэндж');
    cinema_admin.add_movie('Дыши во мгле');
end;
select * from cinema_admin.movie;



begin
    cinema_admin.add_genre('драма');
    cinema_admin.add_genre('комедия');
    cinema_admin.add_genre('триллер');
    cinema_admin.add_genre('фантастика');
end;
select * from cinema_admin.genre;


begin
    cinema_admin.add_movie_genre (20, 1);
    cinema_admin.add_movie_genre (2, 2);
    cinema_admin.add_movie_genre (3, 3);
    cinema_admin.add_movie_genre (4, 4);
    cinema_admin.add_movie_genre (5, 4);
    cinema_admin.add_movie_genre (5, 5);
end;
select * from cinema_admin.movie_genre;


begin 
    cinema_admin.add_customer ('nastia2211', '123', 'nastiaa@gmail.com');
    cinema_admin.add_customer ('oleg1972', '987', 'oleg@gmail.com');
    cinema_admin.add_customer ('olego1972', '987', 'olego@gmail.com');
end;
select * from cinema_admin.customer;


begin
    cinema_admin.add_seance_and_places (2, 1, '04-01-2019', 10, 12, 5);
end;
select * from cinema_admin.seance;
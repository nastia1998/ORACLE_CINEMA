begin
    cinema_admin.admin_package.add_cinema('Октябрь', 'проспект Независимости 73, Минск 220013');
    cinema_admin.admin_package.add_cinema('Москва', 'г.Минск, пр-т Победителей, 13');
    cinema_admin.admin_package.add_cinema('Беларусь', 'ул. Романовская Слобода д.28, Минск 220004');
    commit;
end;
select * from cinema_admin.cinema;
delete from cinema_admin.cinema;

begin
    --cinema_admin.admin_package.change_name_cinema('Октябрь', 'Новый Октябрь', 'проспект Независимости 73, Минск 220013');
    --cinema_admin.admin_package.change_address_cinema('г.Минск, пр-т Победителей, 13', 'Новый адрес');
    --cinema_admin.admin_package.delete_cinema('ул. Романовская Слобода д.28, Минск 220004');
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    commit;
end;



--------------------------------------------------------------------------------------------------------------------------------

begin
    cinema_admin.admin_package.add_cinema_hall('проспект Независимости 73, Минск 220013', 'Золотой', 10, 10);
    cinema_admin.admin_package.add_cinema_hall('проспект Независимости 73, Минск 220013', 'Платина', 10, 20);
    cinema_admin.admin_package.add_cinema_hall('г.Минск, пр-т Победителей, 13', 'Серебро', 10, 10);
    commit;
end;
select * from cinema_admin.cinema_hall;
delete from cinema_admin.cinema_hall;

begin
    cinema_admin.admin_package.add_genre('драма');
    cinema_admin.admin_package.add_genre('комедия');
    cinema_admin.admin_package.add_genre('мелодрама');
    cinema_admin.admin_package.add_genre('фантастика');
    cinema_admin.admin_package.add_genre('фэнтези');
    cinema_admin.admin_package.add_genre('боевик');
    cinema_admin.admin_package.add_genre('военный');
    commit;
end;
select * from cinema_admin.genre;
delete from cinema_admin.genre;

begin
    cinema_admin.admin_package.add_movie('Побег из Шоушенка', 'драма');
    cinema_admin.admin_package.add_movie('Зеленая миля', 'фэнтези');
    cinema_admin.admin_package.add_movie('Форрест Гамп', 'мелодрама');
    commit;
end;
select * from cinema_admin.movie;
delete from cinema_admin.movie;
select * from cinema_admin.movie_genre;
delete from cinema_admin.movie_genre;

begin
    cinema_admin.admin_package.add_seance_and_places ('проспект Независимости 73, Минск 220013', 'Золотой', 'Побег из Шоушенка', 
                                        to_date('08-01-2019 10:00', 'dd-mm-yyyy hh24:mi'), 10, 10, 7);
    commit;
end;
select * from cinema_admin.place;
select * from cinema_admin.seance;
delete from cinema_admin.place;
delete from cinema_admin.seance;




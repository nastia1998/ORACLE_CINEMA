-- grant insert on cinema_admin.cinema to cinema_admin;
-- alter user cinema_admin quouta unlimited on TS_CINEMA;
begin
    cinema_admin.add_cinema('�������', '�������� ������������� 73, ����� 220013');
    cinema_admin.add_cinema('������', '�.�����, ��-� �����������, 13');
    cinema_admin.add_cinema('��������', '��. ����������� ������� �.28, ����� 220004');
    cinema_admin.add_cinema('�������', '��. ����������� ������� �.28, ����� 220004');
end;
select * from cinema_admin.cinema;
delete from cinema_admin.seance;
delete from cinema_admin.cinema_hall;
delete from cinema_admin.cinema;



begin
    --cinema_admin.add_cinema_hall(4, '�������', 10, 10);
    --cinema_admin.add_cinema_hall(2, '�������', 10, 15);
    --cinema_admin.add_cinema_hall(20, '������', 15, 30);
    cinema_admin.add_cinema_hall(2, '�������', 10, 10);
end;
select * from cinema_admin.cinema_hall;



begin
    cinema_admin.add_movie('����');
    cinema_admin.add_movie('����������� �����������');
    cinema_admin.add_movie('���� ��� 2');
    cinema_admin.add_movie('������ �������');
    cinema_admin.add_movie('���� �� ����');
end;
select * from cinema_admin.movie;



begin
    cinema_admin.add_genre('�����');
    cinema_admin.add_genre('�������');
    cinema_admin.add_genre('�������');
    cinema_admin.add_genre('����������');
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

--(cinema_hall_id_a number, movie_id_a number, timetable_a date, roww_a number, place_a number, cost_a number) 
-- alter session set nls_date_format = 'dd-mm-yyyy hh24:mi:ss'
begin
    --cinema_admin.add_seance_and_places (2, 1, '04-01-2019', 10, 12, 5);
    --cinema_admin.add_seance_and_places (2, 2, to_date('04-01-2019 12:00:00', 'dd-mm-yyyy hh24:mi:ss'), 10, 10, 7);
    cinema_admin.add_seance_and_places (2, 1, to_date('08-01-2019 10:00', 'dd-mm-yyyy hh24:mi'), 10, 8, 3);
end;
delete from cinema_admin.place;
delete from cinema_admin.seance;

select * from cinema_admin.movie;
select * from cinema_admin.seance;
select * from cinema_admin.booking;
select * from cinema_admin.place;
select * from cinema_admin.cinema;
select * from cinema_admin.cinema_hall;
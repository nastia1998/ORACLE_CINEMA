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
    cinema_admin.add_cinema_hall(4, '�������', 10, 10);
    cinema_admin.add_cinema_hall(2, '�������', 10, 15);
    cinema_admin.add_cinema_hall(20, '������', 15, 30);
    cinema_admin.add_cinema_hall(2, '�������', 10, 15);
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


begin
    cinema_admin.add_seance_and_places (2, 1, '04-01-2019', 10, 12, 5);
end;
select * from cinema_admin.seance;
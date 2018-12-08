begin
    cinema_admin.admin_package.add_cinema('�������', '�������� ������������� 73, ����� 220013');
    cinema_admin.admin_package.add_cinema('������', '�.�����, ��-� �����������, 13');
    cinema_admin.admin_package.add_cinema('��������', '��. ����������� ������� �.28, ����� 220004');
    commit;
end;
select * from cinema_admin.cinema;
delete from cinema_admin.cinema;

begin
    --cinema_admin.admin_package.change_name_cinema('�������', '����� �������', '�������� ������������� 73, ����� 220013');
    --cinema_admin.admin_package.change_address_cinema('�.�����, ��-� �����������, 13', '����� �����');
    --cinema_admin.admin_package.delete_cinema('��. ����������� ������� �.28, ����� 220004');
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    commit;
end;



--------------------------------------------------------------------------------------------------------------------------------

begin
    cinema_admin.admin_package.add_cinema_hall('�������� ������������� 73, ����� 220013', '�������', 10, 10);
    cinema_admin.admin_package.add_cinema_hall('�������� ������������� 73, ����� 220013', '�������', 10, 20);
    cinema_admin.admin_package.add_cinema_hall('�.�����, ��-� �����������, 13', '�������', 10, 10);
    commit;
end;
select * from cinema_admin.cinema_hall;
delete from cinema_admin.cinema_hall;

begin
    cinema_admin.admin_package.add_genre('�����');
    cinema_admin.admin_package.add_genre('�������');
    cinema_admin.admin_package.add_genre('���������');
    cinema_admin.admin_package.add_genre('����������');
    cinema_admin.admin_package.add_genre('�������');
    cinema_admin.admin_package.add_genre('������');
    cinema_admin.admin_package.add_genre('�������');
    commit;
end;
select * from cinema_admin.genre;
delete from cinema_admin.genre;

begin
    cinema_admin.admin_package.add_movie('����� �� ��������', '�����');
    cinema_admin.admin_package.add_movie('������� ����', '�������');
    cinema_admin.admin_package.add_movie('������� ����', '���������');
    commit;
end;
select * from cinema_admin.movie;
delete from cinema_admin.movie;
select * from cinema_admin.movie_genre;
delete from cinema_admin.movie_genre;

begin
    cinema_admin.admin_package.add_seance_and_places ('�������� ������������� 73, ����� 220013', '�������', '����� �� ��������', 
                                        to_date('08-01-2019 10:00', 'dd-mm-yyyy hh24:mi'), 10, 10, 7);
    commit;
end;
select * from cinema_admin.place;
select * from cinema_admin.seance;
delete from cinema_admin.place;
delete from cinema_admin.seance;




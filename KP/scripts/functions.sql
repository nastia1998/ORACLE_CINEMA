create or replace function cinema_admin.max_cost_movie_in_all_cinemas
(date_start date, date_end date)
return nvarchar2
as
    movie_title nvarchar2(50) := '-';
    begin
        select movie.title into movie_title from cinema_admin.movie
                 inner join cinema_admin.seance on movie.id = seance.movie_id
                 inner join cinema_admin.place on seance.id = place.seance_id where place.cost = (select max(place.cost) from cinema_admin.place inner join cinema_admin.booked_places on place.id = booked_places.place_id)
                 and (seance.timetable between to_date(date_start) and (date_end)) fetch next 1 row only;
        if movie_title != '-' then
            return(movie_title);
        else return '';
        end if;        
        exception 
        when no_data_found then dbms_output.put_line('�� ���� ������� ������. ��������� ���������� ��� ��� ������');
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM || 'in function');
    end;
/

declare 
    movie_title nvarchar2(50);
begin
    movie_title := cinema_admin.max_cost_movie_in_all_cinemas('02-01-2019' ,'05-01-2019');
        dbms_output.put_line('����� �������� ����� �� ����� ����� ���� ����������� ����: ' || movie_title);
    exception 
        when others then dbms_output.put_line('error in call: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;


create or replace function cinema_admin.get_attendance_of_cinema -- ������������ (���-�� ��������� ����)
(cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date)
return number
as
    count_booked_places number;
    begin
        select count(*) into count_booked_places from cinema_admin.booked_places 
        inner join cinema_admin.place on booked_places.place_id = place.id
        inner join cinema_admin.seance on place.seance_id = seance.id
        inner join cinema_admin.cinema_hall on seance.cinema_hall_id = cinema_hall.id
        inner join cinema_admin.cinema on cinema_hall.cinema_id = cinema.id 
        where (cinema.name = cinema_name and cinema.address = cinema_address) and
        (seance.timetable between to_date(date_start) and to_date(date_end));
        return count_booked_places;
        exception 
            when others then dbms_output.put_line('error in function cinema attendance: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
/

declare 
    count_booked_places number;
begin
    count_booked_places := cinema_admin.get_attendance_of_cinema('������', '�.�����, ��-� �����������, 13', '02-01-2019', '05-01-2019');
        dbms_output.put_line('���������� ��������� ������� � ���������� �� ������������ ������: ' || count_booked_places);
    exception 
        when others then dbms_output.put_line('error in call function attendance: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

create or replace function cinema_admin.get_capacity_of_cinema  -- ���������� ����������� ����������
(cinema_name nvarchar2, cinema_address nvarchar2)
return number
as
    count_places number;
    begin
        select sum(rows_count * places_count) into count_places from cinema_admin.cinema_hall
        inner join cinema_admin.cinema on cinema_hall.cinema_id = cinema.id 
        where cinema.name = cinema_name and cinema.address = cinema_address;
        return count_places;
    exception
        when others then dbms_output.put_line('error in function cinema capacity: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
/

declare 
    count_places number;
begin
    count_places := cinema_admin.get_capacity_of_cinema('������', '�.�����, ��-� �����������, 13');
        dbms_output.put_line('����������� � ����������: ' || count_places);
    exception 
        when others then dbms_output.put_line('error in call function capacity: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

create or replace function cinema_admin.get_count_screening_of_cinema -- ���������� �������
(cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date)
return number
as
    count_screening number;
    begin
        select count(*) into count_screening from cinema_admin.seance
        inner join cinema_admin.cinema_hall on seance.cinema_hall_id = cinema_hall.id
        inner join cinema_admin.cinema on cinema_hall.cinema_id = cinema.id
        where (cinema.name = cinema_name and cinema.address = cinema_address) and
        (seance.timetable between to_date(date_start) and to_date(date_end));
        return count_screening;
     exception
        when others then dbms_output.put_line('error in function cinema screening: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
/

declare 
    count_screening number;
begin
    count_screening := cinema_admin.get_count_screening_of_cinema('������', '�.�����, ��-� �����������, 13', '02-01-2019', '05-01-2019');
        dbms_output.put_line('���������� ������� �� ������������ �����: ' || count_screening);
    exception 
        when others then dbms_output.put_line('error in call function count screening: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

create or replace function cinema_admin.get_average_number_of_cinema
(cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date)
return number
as
    count_booked_places number;
    count_places number;
    count_screening number;
    get_average_number number;
    begin
        count_booked_places := cinema_admin.get_attendance_of_cinema(cinema_name, cinema_address, date_start, date_end);
        dbms_output.put_line('���������� ��������� ������� � ���������� �� ������������ ������: ' || count_booked_places);
        count_places := cinema_admin.get_capacity_of_cinema(cinema_name, cinema_address);
        dbms_output.put_line('����������� � ����������: ' || count_places);
        count_screening := cinema_admin.get_count_screening_of_cinema(cinema_name, cinema_address, date_start, date_end);
        dbms_output.put_line('���������� ������� �� ������������ �����: ' || count_screening);
        get_average_number := (count_booked_places / count_places) / count_screening * 100;
        return get_average_number;
     exception
        when others then dbms_output.put_line('error in function average number of cinema: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
/

declare 
    get_average_number number;
begin
    get_average_number := cinema_admin.get_average_number_of_cinema('������', '�.�����, ��-� �����������, 13', '02-01-2019', '05-01-2019');
        dbms_output.put_line('������� ������������� ����������: ' || get_average_number || '%');
    exception 
        when others then dbms_output.put_line('error in call function average number in cinema: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

create or replace function cinema_admin.max_cost_movie_in_one_cinema
(cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date)
return nvarchar2
as
    movie_title nvarchar2(50) := '-';
    begin
        select movie.title into movie_title from cinema_admin.movie
                 inner join cinema_admin.seance on movie.id = seance.movie_id
                 inner join cinema_admin.cinema_hall on seance.cinema_hall_id = cinema_hall.id
                 inner join cinema_admin.cinema on cinema_hall.cinema_id = cinema.id
                 inner join cinema_admin.place on seance.id = place.seance_id
                 where place.cost = (select max(place.cost) from cinema_admin.place inner join cinema_admin.booked_places on place.id = booked_places.place_id)
                 and (seance.timetable between to_date(date_start) and (date_end))
                 and (cinema.name = cinema_name and cinema.address = cinema_address) fetch next 1 row only;
        if movie_title != '-' then
            return(movie_title);
        else return '';
        end if;        
        exception 
        when no_data_found then dbms_output.put_line('�� ���� ������� ������. ��������� ���������� ��� ��� ������');
        when others then dbms_output.put_line('error in function max cost movie in one cinema Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
/

declare 
    movie_title nvarchar2(50);
begin
    movie_title := cinema_admin.max_cost_movie_in_one_cinema('������', '�.�����, ��-� �����������, 13', '02-01-2019' ,'05-01-2019');
        dbms_output.put_line('����� �������� ����� �� ����� � ������������ ����������: ' || movie_title);
    exception 
        when others then dbms_output.put_line('error in call function mas cost movie in one cinema: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

create or replace function cinema_admin.most_popular_genre_in_cinema
(cinema_name nvarchar2, cinema_address nvarchar2)
return nvarchar2
as
    genre_name nvarchar2(20);
    begin
        select (genre.name) into genre_name from cinema_admin.genre
        inner join cinema_admin.movie_genre on genre.id = movie_genre.genre_id
        inner join cinema_admin.movie on movie_genre.movie_id = movie.id
        inner join cinema_admin.seance on movie.id = seance.movie_id
        inner join cinema_admin.cinema_hall on seance.cinema_hall_id = cinema_hall.id 
        inner join cinema_admin.cinema on cinema_hall.cinema_id = cinema.id
        inner join cinema_admin.place on seance.id = place.seance_id
        inner join cinema_admin.booked_places on place.id = booked_places.place_id
        where (cinema.name = cinema_name and cinema.address = cinema_address)
        and place.cost = (select max(place.cost) from cinema_admin.place inner join cinema_admin.booked_places on place.id = booked_places.place_id);
        return genre_name;
        exception
        when others then dbms_output.put_line('error in function the most populat genre in cinema: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
/

declare 
    movie_genre nvarchar2(20);
begin
    movie_genre := cinema_admin.most_popular_genre_in_cinema('������', '�.�����, ��-� �����������, 13');
        dbms_output.put_line('����� ���������� ���� � �������� ����������: ' || movie_genre);
    exception 
        when others then dbms_output.put_line('error in call function most popular genre in cinema: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

create or replace function cinema_admin.max_movie_all_cinemas_time
return nvarchar2
as
    movie_title nvarchar2(50) := '-';
    begin
        select movie.title into movie_title from cinema_admin.movie
                 inner join cinema_admin.seance on movie.id = seance.movie_id
                 inner join cinema_admin.place on seance.id = place.seance_id where place.cost = (select max(place.cost) from cinema_admin.place inner join cinema_admin.booked_places on place.id = booked_places.place_id)
                 fetch next 1 row only;
        if movie_title != '-' then
            return(movie_title);
        else return '';
        end if;        
        exception 
        when no_data_found then dbms_output.put_line('�� ���� ������� ������. ');
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM || 'in function');
    end;
/

declare 
    movie_title nvarchar2(50);
begin
    movie_title := cinema_admin.max_movie_all_cinemas_time;
        dbms_output.put_line('����� �������� ����� ����� ���� ����������� ���� �� ��� �����: ' || movie_title);
    exception 
        when others then dbms_output.put_line('error in call: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

create or replace function cinema_admin.get_most_average_attendance
(date_start date, date_end date)
return nvarchar2
as
    count_booked_places number;
    count_places number;
    count_screening number;
    get_average_number number;
    max_cinema_name nvarchar2(50);
    -- ������ �� ����� ������������
    cursor c is select cinema.name, cinema.address from cinema_admin.cinema;
    counter_for_cinemas c%rowtype;
    begin
        for counter_for_cinemas in c
        loop
            count_booked_places := cinema_admin.get_attendance_of_cinema(counter_for_cinemas.name, counter_for_cinemas.address, date_start, date_end);
            dbms_output.put_line('���������� ��������� ������� � ���������� �� ������������ ������: ' || count_booked_places);
            count_places := cinema_admin.get_capacity_of_cinema(counter_for_cinemas.name, counter_for_cinemas.address);
            dbms_output.put_line('����������� � ����������: ' || count_places);
            count_screening := cinema_admin.get_count_screening_of_cinema(counter_for_cinemas.name, counter_for_cinemas.address, date_start, date_end);
            dbms_output.put_line('���������� ������� �� ������������ �����: ' || count_screening);
            if count_places != 0 and count_screening != 0 then
                get_average_number := (count_booked_places / count_places) / count_screening * 100;
                dbms_output.put_line('������� ������������� ���������� '|| counter_for_cinemas.name ||' = ' || get_average_number);
                dbms_output.put_line('-------------------------------------');
                insert into cinema_admin.temp_avg_attendence(temp_name, temp_avg_att)
                    values (counter_for_cinemas.name, get_average_number);
            else dbms_output.put_line('������� �� 0');
            end if;
        end loop;      
        select temp_avg_attendence.temp_name into max_cinema_name from cinema_admin.temp_avg_attendence where temp_avg_attendence.temp_avg_att = (select max(temp_avg_attendence.temp_avg_att) from cinema_admin.temp_avg_attendence);
        delete from cinema_admin.temp_avg_attendence;
        return max_cinema_name;
        --return get_average_number;
     exception
        when others then dbms_output.put_line('error in function max average number of cinema: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
/

declare 
    max_cinema_name nvarchar2(50);
begin
    max_cinema_name := cinema_admin.get_most_average_attendance('02-01-2019', '05-01-2019');
        dbms_output.put_line('����� ����������� ��������� �� ����� ����� ���� �����������: ' || max_cinema_name);
    exception 
        when others then dbms_output.put_line('error in call function average number in cinema: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

select * from cinema_admin.booked_places;
select * from cinema_admin.movie_genre;
select * from cinema_admin.movie;
select * from cinema_admin.genre;

drop function cinema_admin.max_cost_movie_in_all_cinemas; 
drop function cinema_admin.get_attendance_of_cinema;
drop function cinema_admin.get_capacity_of_cinema;
drop function cinema_admin.get_count_screening_of_cinema;
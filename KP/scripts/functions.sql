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
        when no_data_found then dbms_output.put_line('Не было найдено фильма. Проверьте промежуток дат для сезона');
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM || 'in function');
    end;
/

declare 
    movie_title nvarchar2(50);
begin
    movie_title := cinema_admin.max_cost_movie_in_all_cinemas('02-01-2019' ,'05-01-2019');
        dbms_output.put_line('Самый кассовый фильм за сезон среди всех кинотеатров сети: ' || movie_title);
    exception 
        when others then dbms_output.put_line('error in call: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;


create or replace function cinema_admin.get_attendance_of_cinema -- посещаемость (кол-во проданных мест)
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
    count_booked_places := cinema_admin.get_attendance_of_cinema('Москва', 'г.Минск, пр-т Победителей, 13', '02-01-2019', '05-01-2019');
        dbms_output.put_line('Количество проданных билетов в кинотеатре за определенный период: ' || count_booked_places);
    exception 
        when others then dbms_output.put_line('error in call function attendance: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

create or replace function cinema_admin.get_capacity_of_cinema  -- пропускная способность кинотеатра
(cinema_name nvarchar2, cinema_address nvarchar2)
return number
as
    count_places number;
    begin
        select sum(rows_count * places_count) from cinema_admin.cinema_hall
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
    count_places := cinema_admin.get_capacity_of_cinema('Москва', 'г.Минск, пр-т Победителей, 13');
        dbms_output.put_line('Вместимость в кинотеатре: ' || count_places);
    exception 
        when others then dbms_output.put_line('error in call function attendance: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

select * from cinema_admin.booked_places;

drop function cinema_admin.max_cost_movie_in_all_cinemas; 
drop function cinema_admin.get_attendance_of_cinema;
drop function cinema_admin.get_capacity_of_cinema;
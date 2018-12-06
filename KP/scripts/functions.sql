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
    movie_title := cinema_admin.max_cost_movie_in_all_cinemas('02-01-2019' ,'03-01-2019');
        dbms_output.put_line('Самый кассовый фильм за сезон среди всех кинотеатров сети: ' || movie_title);
    exception 
        when others then dbms_output.put_line('error in call: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;
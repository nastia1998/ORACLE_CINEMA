create or replace package admin_package
is
    procedure add_cinema (name_cinema nvarchar2, address_cinema nvarchar2);
    procedure change_name_cinema(old_name nvarchar2, new_name nvarchar2, cinema_address_a nvarchar2);
    procedure change_address_cinema(old_address nvarchar2, new_address nvarchar2);
    procedure delete_cinema(cinema_address_a nvarchar2);
    
    procedure add_cinema_hall (cinema_address_a nvarchar2, cinema_hall_name_a nvarchar2, rows_count_a number, places_count_a number);
    --procedure change_name_cinema_hall (hall_old_name nvarchar2, hall_new_name nvarchar2, cinema_address_a nvarchar2);
    --procedure delete_cinema_hall (name_cinema nvarchar2, cinema_address_a nvarchar2);
    
    procedure add_movie (title_movie nvarchar2, genre_name nvarchar2);
    --procedure change_name_movie (old_name nvarchar2, new_name nvarchar2);
    --procedure delete_movie (title_movie nvarchar2);
    
    procedure add_genre (name_genre nvarchar2);
    --procedure change_name_genre (old_name nvarchar2, new_name nvarchar2);
    --procedure delete_genre (name_genre nvarchar2);
    
    procedure add_seance_and_places (cinema_address_a nvarchar2, cinema_hall_name_a number, movie_title_a nvarchar2, timetable_a date, roww_a number, place_a number, cost_a number);
    
    function max_cost_movie_in_all_cinemas (date_start date, date_end date) return nvarchar2;
    function get_attendance_of_cinema (cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date) return number; -- посещаемость (кол-во проданных мест)
    function get_capacity_of_cinema (cinema_name nvarchar2, cinema_address nvarchar2) return number; -- пропускная способность кинотеатра
    function get_count_screening_of_cinema (cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date) return number; -- количество показов
    function get_average_number_of_cinema (cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date) return number;
    function max_cost_movie_in_one_cinema (cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date) return nvarchar2;
    function most_popular_genre_in_cinema (cinema_name nvarchar2, cinema_address nvarchar2) return nvarchar2;
    function max_movie_all_cinemas_time return nvarchar2;
    function get_most_average_attendance (date_start date, date_end date) return nvarchar2;
end admin_package;

create or replace package body admin_package
is

    procedure add_cinema (name_cinema nvarchar2, address_cinema nvarchar2)
    is
        crows number;
    begin
        select count(*) into crows from cinema_admin.cinema where name = name_cinema and address = address_cinema;
        if crows = 0 then
            insert into cinema (name, address)
                values (name_cinema, address_cinema);
            dbms_output.put_line('Кинотеатр ' || name_cinema || ' успешно добавлен!');
        else dbms_output.put_line('Такой кинотеатр уже существует!');
        end if;
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end add_cinema;
    
    procedure change_name_cinema(old_name nvarchar2, new_name nvarchar2, cinema_address_a nvarchar2)
    is
        ccinema number;
    begin
        select count(*) into ccinema from cinema_admin.cinema where name = old_name and address = cinema_address_a;
        if ccinema = 1 then
            update cinema_admin.cinema set name = new_name where name = old_name and address = cinema_address_a;
            dbms_output.put_line('Название кинотеатра успешно обновлено!');
        else dbms_output.put_line('Непривильно указан адрес или название кинотеатра!');
        end if;
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end change_name_cinema;
    
    procedure change_address_cinema(old_address nvarchar2, new_address nvarchar2)
    is
        ccinema number;
    begin
        select count(*) into ccinema from cinema_admin.cinema where address = old_address;
        if ccinema = 1 then
            update cinema_admin.cinema set cinema.address = new_address where cinema.name = old_address;
            dbms_output.put_line('Адрес кинотеатра успешно обновлено!');
        else dbms_output.put_line('Непривильно указан старый адрес кинотеатра!');
        end if;
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);    
    end change_address_cinema;
    
    procedure delete_cinema(cinema_address_a nvarchar2)
    is
        ccinema number;
    begin
        select count(*) into ccinema from cinema_admin.cinema where address = cinema_address_a;
        if ccinema = 1 then
            delete from cinema_admin.cinema where address = cinema_address_a;
            dbms_output.put_line('Кинотеатр успешно удален!');
        else dbms_output.put_line('Непривильно указан адрес кинотеатра!');
        end if;
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end delete_cinema;
    
    procedure add_cinema_hall (cinema_address_a nvarchar2, cinema_hall_name_a nvarchar2, rows_count_a number, places_count_a number)
    is
        cid number;
        chname number;
    begin
        select id into cid from cinema_admin.cinema where address = cinema_address_a order by id fetch next 1 rows only; 
        if cid != 0 then -- есть ли такой кинотеатр
            select count(*) into chname from cinema_admin.cinema_hall where cinema_id = cid and cinema_hall_name = cinema_hall_name_a; -- есть ли в этом кинотеатре зал с таким названием
            if chname = 0 then
                insert into cinema_admin.cinema_hall (cinema_id, cinema_hall_name, rows_count, places_count)
                    values (cid, cinema_hall_name_a, rows_count_a, places_count_a);
                dbms_output.put_line('Зал ' || cinema_hall_name_a || ' успешно добавлен!');
            else dbms_output.put_line('Зал с таким названием уже существует!');
            end if;
        else dbms_output.put_line('Такого кинотеатра не существует! Проверьте введенный адрес.');
        end if;
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end add_cinema_hall;
    
    procedure add_movie (title_movie nvarchar2, genre_name nvarchar2)
    is
        cmovie number;
        cmov_g number;
        mov_id number;
        g_id number;
    begin
        select count(*) into cmovie from cinema_admin.movie where title = title_movie;
        if cmovie = 0 then
            select count(*) into cmov_g from cinema_admin.genre where name = genre_name;
            if cmov_g = 1 then
                select id into g_id from cinema_admin.genre where name = genre_name;
                insert into cinema_admin.movie(title)
                    values(title_movie);
                select id into mov_id from cinema_admin.movie order by id desc fetch next 1 rows only;
                insert into cinema_admin.movie_genre(movie_id, genre_id)
                    values(mov_id, g_id);
                dbms_output.put_line('Фильм успешно добавлен!');
            else dbms_output.put_line('Такого жанра не обнаружено!');
            end if;
        else dbms_output.put_line('Фильм с таким названием существует! Проверьте введенные данные.');
        end if;
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
    
    procedure add_genre (name_genre nvarchar2)
    is
        cgenre number;
    begin
        select count(*) into cgenre from cinema_admin.genre where name = name_genre;
        if cgenre = 0 then
            insert into cinema_admin.genre (name)
                values (name_genre);
            dbms_output.put_line('Жанр успешно добавлен!');
        else dbms_output.put_line('Такой жанр уже существует!');
        end if;
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end add_genre;
    
    procedure add_seance_and_places (cinema_address_a nvarchar2, cinema_hall_name_a number, movie_title_a nvarchar2, timetable_a date, roww_a number, place_a number, cost_a number)
    is
        cmovie number;
        cid number;
        ch_id number;
        m_id number;
        s_id number;
    begin
        select id into cid from cinema_admin.cinema where address = cinema_address_a order by id fetch next 1 rows only;
        select id into ch_id from cinema_admin.cinema_hall where cinema_hall.cinema_id = cid and cinema_hall_name = cinema_hall_name_a order by id fetch next 1 rows only;
        if cid != 0 and ch_id != 0 then
            select count(*) into cmovie from cinema_admin.movie where title = movie_title_a;
            if cmovie != 0 then
                select id into m_id from cinema_admin.movie where title = movie_title_a order by id fetch next 1 rows only;
                insert into cinema_admin.seance (cinema_hall_id, movie_id, timetable)
                    values (ch_id, m_id, timetable_a);
                select id into s_id from cinema_admin.seance 
                    where movie_id = m_id and cinema_hall_id = ch_id and timetable = timetable_a order by id desc fetch next 1 rows only;
                for i in 1..roww_a
                loop
                    for j in 1..place_a
                    loop
                        insert into cinema_admin.place (roww, place, cost, seance_id)
                            values (i, j, cost_a, s_id);
                    end loop;
                end loop;
                dbms_output.put_line('Сеанс и места успешно добавлены!');
            else dbms_output.put_line('Не было найдено заданного фильма! Проверьте введенные данные.');
            end if;
        else dbms_output.put_line('Не был найден адрес кинотеатра или зал!');
        end if;
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end add_seance_and_places;
    
    function max_cost_movie_in_all_cinemas (date_start date, date_end date) return nvarchar2
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
    end max_cost_movie_in_all_cinemas;

    function get_attendance_of_cinema (cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date) return number
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
    
    function get_capacity_of_cinema (cinema_name nvarchar2, cinema_address nvarchar2) return number
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
    
    function get_count_screening_of_cinema (cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date) return number
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
    
    function get_average_number_of_cinema (cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date) return number
    as
    count_booked_places number;
    count_places number;
    count_screening number;
    get_average_number number;
    begin
        count_booked_places := cinema_admin.get_attendance_of_cinema(cinema_name, cinema_address, date_start, date_end);
        dbms_output.put_line('Количество проданных билетов в кинотеатре за определенный период: ' || count_booked_places);
        count_places := cinema_admin.get_capacity_of_cinema(cinema_name, cinema_address);
        dbms_output.put_line('Вместимость в кинотеатре: ' || count_places);
        count_screening := cinema_admin.get_count_screening_of_cinema(cinema_name, cinema_address, date_start, date_end);
        dbms_output.put_line('Количество показов за определенное время: ' || count_screening);
        get_average_number := (count_booked_places / count_places) / count_screening * 100;
        return get_average_number;
     exception
        when others then dbms_output.put_line('error in function average number of cinema: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
    
    function max_cost_movie_in_one_cinema (cinema_name nvarchar2, cinema_address nvarchar2, date_start date, date_end date) return nvarchar2
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
        when no_data_found then dbms_output.put_line('Не было найдено фильма. Проверьте промежуток дат для сезона');
        when others then dbms_output.put_line('error in function max cost movie in one cinema Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
    
    function most_popular_genre_in_cinema (cinema_name nvarchar2, cinema_address nvarchar2) return nvarchar2
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
    
    function max_movie_all_cinemas_time return nvarchar2
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
        when no_data_found then dbms_output.put_line('Не было найдено фильма. ');
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM || 'in function');
    end;
    
    function get_most_average_attendance (date_start date, date_end date) return nvarchar2
    as
    count_booked_places number;
    count_places number;
    count_screening number;
    get_average_number number;
    max_cinema_name nvarchar2(50);
    -- курсор со всеми кинотеатрами
    cursor c is select cinema.name, cinema.address from cinema_admin.cinema;
    counter_for_cinemas c%rowtype;
    begin
        for counter_for_cinemas in c
        loop
            count_booked_places := cinema_admin.get_attendance_of_cinema(counter_for_cinemas.name, counter_for_cinemas.address, date_start, date_end);
            dbms_output.put_line('Количество проданных билетов в кинотеатре за определенный период: ' || count_booked_places);
            count_places := cinema_admin.get_capacity_of_cinema(counter_for_cinemas.name, counter_for_cinemas.address);
            dbms_output.put_line('Вместимость в кинотеатре: ' || count_places);
            count_screening := cinema_admin.get_count_screening_of_cinema(counter_for_cinemas.name, counter_for_cinemas.address, date_start, date_end);
            dbms_output.put_line('Количество показов за определенное время: ' || count_screening);
            if count_places != 0 and count_screening != 0 then
                get_average_number := (count_booked_places / count_places) / count_screening * 100;
                dbms_output.put_line('Средняя заполняемость кинотеатра '|| counter_for_cinemas.name ||' = ' || get_average_number);
                dbms_output.put_line('-------------------------------------');
                insert into cinema_admin.temp_avg_attendence(temp_name, temp_avg_att)
                    values (counter_for_cinemas.name, get_average_number);
            else dbms_output.put_line('деление на 0');
            end if;
        end loop;      
        select temp_avg_attendence.temp_name into max_cinema_name from cinema_admin.temp_avg_attendence where temp_avg_attendence.temp_avg_att = (select max(temp_avg_attendence.temp_avg_att) from cinema_admin.temp_avg_attendence);
        delete from cinema_admin.temp_avg_attendence;
        return max_cinema_name;
        --return get_average_number;
     exception
        when others then dbms_output.put_line('error in function max average number of cinema: ' || 'Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end;
    
end admin_package;
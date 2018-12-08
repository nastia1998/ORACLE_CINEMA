-- grant create procedure to cinema_admin;
create procedure cinema_admin.add_cinema (name_cinema in nvarchar2, address_cinema in nvarchar2) 
authid current_user as
    crows integer;
    begin
        select count(*) into crows from cinema_admin.cinema where name = name_cinema and address = address_cinema;
        if crows = 0 then
            insert into cinema (name, address)
            values (name_cinema, address_cinema);
        end if;
    end;
/

create procedure cinema_admin.add_cinema_hall (cinema_id_a number, cinema_hall_name_a nvarchar2, rows_count_a number, places_count_a number) 
authid current_user as
    cid integer;
    chname nvarchar2(30);
    begin
        select count(*) into cid from cinema_admin.cinema where id = cinema_id_a; -- есть ли такой кинотеатр
        if cid != 0 then   
            select count(*) into chname from cinema_admin.cinema_hall where cinema_id = cinema_id_a and cinema_hall_name = cinema_hall_name_a; -- есть ли в этом кинотеатре зал с таким названием
            if chname = 0 then
                insert into cinema_admin.cinema_hall (cinema_id, cinema_hall_name, rows_count, places_count)
                values (cinema_id_a, cinema_hall_name_a, rows_count_a, places_count_a);
            end if;
        end if;
    end;
/

create procedure cinema_admin.add_movie (title_movie nvarchar2) 
authid current_user as
    cmovie integer;
    begin
        select count(*) into cmovie from cinema_admin.movie where title = title_movie;
        if cmovie = 0 then
            insert into cinema_admin.movie (title)
            values (title_movie);
        end if;
    end;
/

create procedure cinema_admin.add_genre (name_genre nvarchar2) 
authid current_user as
    cgenre integer;
    begin
        select count(*) into cgenre from cinema_admin.genre where name = name_genre;
        if cgenre = 0 then
            insert into cinema_admin.genre (name)
            values (name_genre);
        end if;
    end;
/

create procedure cinema_admin.add_movie_genre (movie_id_a number, genre_id_a number) 
authid current_user as
    mid integer;
    gid integer;
    cmg integer;
    begin
        select count(*) into mid from cinema_admin.movie where id = movie_id_a;
        select count(*) into gid from cinema_admin.genre where id = genre_id_a;
        if mid != 0 then    -- если существует фильм
            if gid != 0 then    -- если существует жанр
                select count(*) into cmg from cinema_admin.movie_genre where movie_id = movie_id_a and genre_id = genre_id_a;
                if cmg = 0 then     -- если нет фильма с таким жанром
                    insert into cinema_admin.movie_genre (movie_id, genre_id)
                    values (movie_id_a, genre_id_a);
                end if;
            end if;
        end if;
    end;
/

create or replace procedure cinema_admin.add_seance_and_places (cinema_hall_id_a number, movie_id_a number, timetable_a date, roww_a number, place_a number, cost_a number) 
authid current_user as
    chall integer;
    cmovie integer;
    challmov integer;
    cid number;
    begin
        select count(*) into chall from cinema_admin.cinema_hall where id = cinema_hall_id_a;
        if chall != 0 then -- если существует такой зал
            select count(*) into cmovie from cinema_admin.movie where id = movie_id_a;
            if cmovie != 0 then -- если существует такой фильм
                select count(*) into challmov from cinema_admin.seance where cinema_hall_id = cinema_hall_id_a and movie_id = movie_id_a and timetable = timetable_a;
                    if challmov = 0 then -- если еще нет такого сеанса
                        insert into cinema_admin.seance (cinema_hall_id, movie_id, timetable)
                        values (cinema_hall_id_a, movie_id_a, timetable_a);
                        
                        select id into cid from cinema_admin.seance order by id desc fetch next 1 rows only;
                        
                        for i in 1..roww_a
                        loop
                            for j in 1..place_a
                            loop
                                insert into cinema_admin.place (roww, place, cost, seance_id)
                                values (i, j, cost_a, cid);
                            end loop;
                        end loop;
                    end if;
            end if;
        end if;
    end;
/


create procedure cinema_admin.add_customer (login_a nvarchar2, password_a nvarchar2, email_a varchar2) 
authid current_user as
    clogin integer;
    cemail integer;
    begin
        select count(*) into clogin from cinema_admin.customer where login = login_a; 
        if clogin = 0 then -- если такого логина больше ни у кого нет
            select count(*) into cemail from cinema_admin.customer where email = email_a; 
            if cemail = 0 then -- если такого email больше ни у кого нет
                insert into cinema_admin.customer (login, password, email)
                values (login_a, password_a, email_a);
            end if;
        end if;
    end;
/

-- grant execute on DBMS_OUTPUT to RL_CINEMA_USER;
create or replace procedure cinema_admin.book_place
(customer_login_a nvarchar2, cinema_name_a nvarchar2, cinema_address_a nvarchar2, cinema_hall_name_a nvarchar2, movie_title_a nvarchar2,
 timetable_a date, place_roww_a number, place_place_a number, booking_date_a date) 
 as
    count_customers_by_login number;
    get_customer_id_a number;
    count_cinema number;
    get_cinema_id number;
    count_cinema_hall number;
    get_cinema_hall_id number;
    get_movie_id number;
    get_seance_id number;
    count_timetable number;
    count_place_by_seance_id number;
    get_place_id number;
    last_booking_id number;
    count_booked_place_by_id number := 0;
    begin
        select count(id) into count_customers_by_login from cinema_admin.customer where login = customer_login_a;
        dbms_output.put_line('count customers = ' || count_customers_by_login); 
        if count_customers_by_login = 1 then
            select id into get_customer_id_a from cinema_admin.customer where customer.login = customer_login_a;
            select count(*) into count_cinema from cinema_admin.cinema where name = cinema_name_a and address = cinema_address_a;
            dbms_output.put_line('count cinemas = ' || count_cinema); 
            if count_cinema = 1 then
                select id into get_cinema_id from cinema_admin.cinema where name = cinema_name_a and address = cinema_address_a;
                dbms_output.put_line('id кинотеатра = ' || get_cinema_id);
                select count(*) into count_cinema_hall from cinema_admin.cinema_hall where cinema_hall_name = cinema_hall_name_a and cinema_id = get_cinema_id;
                dbms_output.put_line('count cinema hall = ' || count_cinema_hall);
                if count_cinema_hall = 1 then
                    select id into get_cinema_hall_id from cinema_admin.cinema_hall where cinema_hall_name = cinema_hall_name_a and cinema_id = get_cinema_id;
                    dbms_output.put_line('cinema hall id = ' || get_cinema_hall_id);
                    select id into get_movie_id from cinema_admin.movie where title = movie_title_a;
                    dbms_output.put_line('movie id = ' || get_movie_id);
                    select id into get_seance_id from cinema_admin.seance where cinema_hall_id = get_cinema_hall_id and movie_id = get_movie_id;
                    dbms_output.put_line('seance id = ' || get_seance_id);
                    select count(*) into count_timetable from cinema_admin.seance where id = get_seance_id and timetable = timetable_a;
                    dbms_output.put_line('count timetables = ' || count_timetable);
                    if count_timetable = 1 then
                        select count(*) into count_place_by_seance_id from cinema_admin.place where seance_id = get_seance_id and roww = place_roww_a and place = place_place_a;
                        dbms_output.put_line('count places = ' || count_place_by_seance_id);
                        if count_place_by_seance_id = 1 then
                            select id into get_place_id from cinema_admin.place where seance_id = get_seance_id and roww = place_roww_a and place = place_place_a;
                            dbms_output.put_line('place id = ' || get_place_id);
                            insert into cinema_admin.booking (customer_id, booking_date) 
                                values (get_customer_id_a, booking_date_a);   
                            select id into last_booking_id from cinema_admin.booking order by id desc fetch next 1 rows only;
                            dbms_output.put_line('last booking id = ' || last_booking_id);
                            select count(*) into count_booked_place_by_id from cinema_admin.booked_places where place_id = get_place_id and booking_id = last_booking_id;
                            if count_booked_place_by_id = 0 then --???????????????????????????????????????????
                                insert into cinema_admin.booked_places (place_id, booking_id)
                                    values (get_place_id, last_booking_id);
                                dbms_output.put_line('Вы успешно заказали билет');
                            else dbms_output.put_line('данное место уже было заказано'); 
                            end if;
                        else dbms_output.put_line('было найдено более одного места с такой позицией в сеансе');
                        end if;
                    else dbms_output.put_line('было найдено более одного расписания');
                    end if;                    
                else dbms_output.put_line('было найдено более одного зала');
                end if;
            else dbms_output.put_line('было найдено более одного кинотеатра');
            end if;
        else dbms_output.put_line('было найдено более одного покупателя под одним именем');
        end if;
    end;
/

create or replace procedure cinema_admin.cancel_booking
(customer_login_a nvarchar2, booking_date_a date, roww_a number, place_a number)
as
    get_customer_id number;
    get_booking_id number;
    place_id_a number;
    cursor c is select id, roww, place from cinema_admin.place 
        where roww = roww_a and place = place_a;
    counter_for_places c%rowtype;
    cursor places is select * from cinema_admin.booked_places;
    counter places%rowtype;
    begin
        for counter_for_place in c
        loop    
            insert into places_by_row_and_place (temp_id, temp_row, temp_place)
                values (counter_for_place.id, counter_for_place.roww, counter_for_place.place); 
        end loop;
        
        select id into get_customer_id from cinema_admin.customer where customer.login = customer_login_a;
        select id into get_booking_id from cinema_admin.booking where customer_id = get_customer_id and booking_date = booking_date_a;         
        for counter in places
        loop
            if counter.booking_id = get_booking_id then
                select place_id into place_id_a from cinema_admin.booked_places
                inner join cinema_admin.places_by_row_and_place
                on cinema_admin.booked_places.place_id = cinema_admin.places_by_row_and_place.temp_id;
            end if;
        end loop;
        delete from cinema_admin.booked_places where place_id = place_id_a and booking_id = get_booking_id;
        delete from cinema_admin.booking where id = get_booking_id;
        delete from cinema_admin.places_by_row_and_place;
        dbms_output.put_line('Вы успешно сдали билет');
    end;
/

drop procedure cinema_admin.cancel_booking;
drop procedure cinema_admin.book_place;
drop procedure cinema_admin.add_customer;
drop procedure cinema_admin.add_seance_and_places;  
drop procedure cinema_admin.add_movie_genre;
drop procedure cinema_admin.add_genre;
drop procedure cinema_admin.add_movie;
drop procedure cinema_admin.add_cinema_hall;
drop procedure cinema_admin.add_cinema;

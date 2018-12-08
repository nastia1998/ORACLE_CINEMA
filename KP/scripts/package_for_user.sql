create or replace package user_package
is
    procedure registration(login_a customer.login%type, password_a customer.password%type, email_a customer.email%type);
    procedure show_all_seances(date_start date, date_end date);
    procedure book_place
        (customer_login_a nvarchar2, cinema_name_a nvarchar2, cinema_address_a nvarchar2, cinema_hall_name_a nvarchar2, movie_title_a nvarchar2,
         timetable_a date, place_roww_a number, place_place_a number, booking_date_a date);
    procedure cancel_booking
        (customer_login_a nvarchar2, booking_date_a date, roww_a number, place_a number);
    procedure show_booked_tickets(login_a customer.login%type, password_a customer.password%type);
end user_package;

create or replace package body user_package 
is

    procedure registration(login_a customer.login%type, password_a customer.password%type, email_a customer.email%type)
    is
        clogin number;
        cemail number;
    begin
        select count(*) into clogin from cinema_admin.customer where login = login_a; 
        if clogin = 0 then -- если такого логина больше ни у кого нет
            select count(*) into cemail from cinema_admin.customer where email = email_a; 
            if cemail = 0 then -- если такого email больше ни у кого нет
                insert into cinema_admin.customer (login, password, email)
                    values (login_a, password_a, email_a);
                dbms_output.put_line('Регистрация прошла успешно');
            else dbms_output.put_line('Пользователь с таким email уже существует');
            end if;
        else dbms_output.put_line('Пользователь с таким логином уже существует');
        end if;
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end registration;
    
    procedure show_all_seances(date_start date, date_end date)
    is
    cursor c is select cinema.name, cinema.address, m.title, chall.cinema_hall_name, s.timetable from cinema_admin.cinema
                    join cinema_admin.cinema_hall chall on cinema.id = chall.cinema_id
                    join cinema_admin.seance s on chall.id = s.cinema_hall_id
                    join cinema_admin.movie m on s.movie_id = m.id
                    where (s.timetable between date_start and date_end);
    counter c%rowtype;
    begin
        dbms_output.put_line('Все сеансы для дат с ' || to_char(date_start, 'dd-mm-yyyy hh24:mi:ss') || ' по ' || to_char(date_end, 'dd-mm-yyyy hh24:mi:ss') || ': ');
        for counter in c
        loop
            dbms_output.put_line('Название кинотеатра: ' || counter.name);
            dbms_output.put_line('Адрес кинотеатра: ' || counter.address);
            dbms_output.put_line('Название фильма: ' || counter.title);
            dbms_output.put_line('Название зала: ' || counter.cinema_hall_name);
            dbms_output.put_line('Время сеанса: ' || to_char(counter.timetable, 'dd-mm-yyyy hh24:mi'));
            dbms_output.put_line('------------------------------------');
        end loop;
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end show_all_seances;
    
    procedure book_place
        (customer_login_a nvarchar2, cinema_name_a nvarchar2, cinema_address_a nvarchar2, cinema_hall_name_a nvarchar2, movie_title_a nvarchar2,
         timetable_a date, place_roww_a number, place_place_a number, booking_date_a date)
    is
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
            select customer.id into get_customer_id_a from cinema_admin.customer where customer.login = customer_login_a;
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
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end book_place;
    
    procedure cancel_booking
        (customer_login_a nvarchar2, booking_date_a date, roww_a number, place_a number)
    is
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
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end cancel_booking;
    
    procedure show_booked_tickets(login_a customer.login%type, password_a customer.password%type)
    is
       cursor c2(cust_id number) is select booking.booking_date, s.timetable, c.name, m.title, cinh.cinema_hall_name, p.roww, p.place from cinema_admin.booking
                    inner join cinema_admin.booked_places on booking.id = booked_places.booking_id
                    inner join cinema_admin.place p on booked_places.place_id = p.id
                    inner join cinema_admin.seance s on p.seance_id = s.id
                    inner join cinema_admin.movie m on s.movie_id = m.id
                    inner join cinema_admin.cinema_hall cinh on s.cinema_hall_id = cinh.id
                    inner join cinema_admin.cinema c on cinh.cinema_id = c.id
                    where booking.customer_id = cust_id;
        places_curs c2%rowtype;
        customer_id number;
    begin
        dbms_output.put_line('Все купленные билеты:');
        
        select id into customer_id from cinema_admin.customer where customer.login = login_a and customer.password = password_a;
        open c2(customer_id);
        loop
            fetch c2 into places_curs;    
            if c2%found then
                dbms_output.put_line('Дата заказа: ' || to_char(places_curs.booking_date, 'dd-mm-yyyy hh24:mi:ss'));
                dbms_output.put_line('Время сеанса: ' || to_char(places_curs.timetable, 'dd-mm-yyyy hh24:mi:ss'));
                dbms_output.put_line('Название кинотеатра: ' || places_curs.name);
                dbms_output.put_line('Название фильма: ' || places_curs.title);
                dbms_output.put_line('Название зала: ' || places_curs.cinema_hall_name);
                dbms_output.put_line('Номер ряда: ' || places_curs.roww);
                dbms_output.put_line('Номер места: ' || places_curs.place);
                dbms_output.put_line('------------------------------------');
            end if;
        exit when c2%notfound;
        end loop;
        close c2;
        
    exception
        when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
    end show_booked_tickets;
    
end user_package;
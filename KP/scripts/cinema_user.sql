begin 
    --cinema_admin.book_place ('nastia2211', 'Москва', 'г.Минск, пр-т Победителей, 13', 'Платина', 'Чудо', '04-01-2019', 1, 2, '01-01-2019'); 
    cinema_admin.book_place ('nastia2211', 'Москва', 'г.Минск, пр-т Победителей, 13', 'Платина', 'Приключения Паддингтона', '04-01-2019', 5, 10, '03-01-2019');
    commit;
    exception 
    when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

begin
    cinema_admin.cancel_booking('nastia2211', '01-01-2019', 1, 2);
    commit;
    exception
    when others then dbms_output.put_line('Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

SELECT * FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('PROCEDURE','TABLE','PACKAGE') and owner = 'CINEMA_ADMIN';

begin
  cinema_admin.user_package.show_all_seances('03-01-2019', '05-01-2019');
   exception
        when others then dbms_output.put_line('error in showing all seances Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;    
select * from cinema_admin.customer;
select * from cinema_admin.seance;
select * from cinema_admin.booked_places;
select * from cinema_admin.place;
select * from cinema_admin.booking;
select * from cinema_admin.cinema;
begin
  cinema_admin.user_package.registration('nataly', '7456', 'nataly@gmail.com');
  commit;
  exception
        when others then dbms_output.put_line('error in showing all seances Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;    
begin
  cinema_admin.user_package.show_all_seances(to_date('03-01-2019 12:00', 'dd-mm-yyyy hh24:mi'), to_date('09-01-2019 12:00', 'dd-mm-yyyy hh24:mi'));
  --cinema_admin.user_package.show_booked_tickets('nastia2211', '123');
  --cinema_admin.user_package.cancel_booking ('nastia2211', '03-01-2019', 5, 10);
  /*cinema_admin.user_package.book_place ('nastia2211', 'Москва', 'г.Минск, пр-т Победителей, 13', 'Платина', 'Чудо',
                                        to_date('08-01-2019 10:00','dd-mm-yyyy hh24:mi'), 1, 3, to_date('07-01-2019 12:00','dd-mm-yyyy hh24:mi')
                                       );*/
  commit;
  exception
        when others then dbms_output.put_line('error in showing all seances Code: ' || SQLCODE || ' Error: ' || SQLERRM);
end;

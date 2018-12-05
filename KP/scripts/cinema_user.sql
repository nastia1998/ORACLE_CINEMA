begin 
    cinema_admin.book_place ('nastia2211', 'Москва', 'г.Минск, пр-т Победителей, 13', 'Платина', 'Чудо', '04-01-2019', 1, 2, '01-01-2019'); 
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

SELECT * FROM ALL_OBJECTS WHERE OBJECT_TYPE IN ('PROCEDURE','TABLE') and owner = 'CINEMA_ADMIN';


(customer_login_a number, booking_date_a date, roww_a number, place_a number)
    
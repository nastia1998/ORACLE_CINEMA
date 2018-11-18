-- grant create view to cinema_admin
create view cinemas_view as
    select * from cinema_admin.cinema;
/*CREATE TABLE d_date(
  id number GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  fullDate date
  );*/
/*drop table d_date;*/
select * from d_date;

Set serveroutput on 
declare
 
   oneFineMinute interval day to second := to_dsInterval ('000 00:01:00');
   firstDate date := to_date('31/12/1959 00:00:00','DD/MM/YYYY HH24:MI:SS');
   
 begin
 
   for i in 1..52560000 loop
     /*dbms_output.put_line (    'Now added ' || to_char(i) || ' minutes, date is ' 
                            || to_char(firstDate,'DD/MM/YYYY HH24:MI:SS'));*/
    
    insert into d_date(FULLDATE)
    values(firstDate);
                            
    firstDate := firstDate + oneFineMinute;
    
   end loop;
 
 end;
 COMMIT;
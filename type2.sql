declare
endOfTime date := to_date('9999-12-31','YYYY-MM-DD');
begin
insert into Member(
  memberno ,
  name ,
  zipcode ,
  dateborn ,
  datejoined ,
  dateleft ,
  statut ,
  age ,
  valid_to ,
  valid_from 
  /*club_id*/

)
(
  select
  memberno,
  name,
  zipcode,
  dateborn,
  datejoined,
  dateleft,
  statut_member,
  age,
  endOfTime,
  SYSDATE
  from MEMBER_PROFILING2
  where(MEMBER_PROFILING2.typeOfChange = 1)
);
end;
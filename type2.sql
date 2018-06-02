
update Member
set valid_to = SYSDATE
where MEMBERNO in(
        select MEMBERNO 
        from MEMBER_PROFILING2 
        where typeOfChange = 2 or typeOfChange = 3 or typeOfChange = 4);

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
  valid_from,
  club_id

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
  '31/12/9999',
  SYSDATE,
  club_id
  from MEMBER_PROFILING2
  where MEMBERNO in(
        select MEMBERNO 
        from MEMBER_PROFILING2 
        where typeOfChange = 1 or typeOfChange = 3 or typeOfChange = 4)
);


SELECT * FROM member;



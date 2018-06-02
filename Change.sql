create table Member_Profiling(
  INITIALS CHAR(4 BYTE),
  memberno NUMBER(6,0),
  name VARCHAR2(50 BYTE),
  zipcode NUMBER(4,0),
  dateborn date,
  datejoined date,
  dateleft date,
  student CHAR(1 BYTE),
  pilot CHAR(1 BYTE),
  cat CHAR(1 BYTE),
  fullcat CHAR(1 BYTE),
  typeOfChange number
);

insert INTO Member_Profiling(
  INITIALS,
  memberno, 
  name ,
  zipcode ,
  dateborn ,
  datejoined ,
  dateleft,
  student,
  pilot,
  cat,
  fullcat,
  typeOfChange)
  (
SELECT DISTINCT 
  INITIALS,
  memberno,
  name,
  ZIPCODE,
  DATEBORN,
  DATEJOINED,
  DATELEFT,
  STATUSSTUDENT,
  STATUSPILOT,
  STATUSASCAT,
  STATUSFULLCAT,
  typeOfChange
  from Member_Extract
  where(typeOfChange = 1 or  typeOfChange = 3)
);

create table Member_Profiling2(
  memberid NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  INITIALS CHAR(4 BYTE),
  memberno NUMBER(6,0),
  name VARCHAR2(50 BYTE),
  zipcode NUMBER(4,0),
  dateborn date,
  datejoined date,
  dateleft date,
  student CHAR(1 BYTE),
  pilot CHAR(1 BYTE),
  cat CHAR(1 BYTE),
  fullcat CHAR(1 BYTE),
  typeOfChange number
);

insert into MEMBER_PROFILING2(
  memberno,
  INITIALS,
  name ,
  zipcode ,
  dateborn ,
  datejoined ,
  dateleft ,
  student ,
  pilot ,
  cat ,
  fullcat )
Select 
  memberno,
  INITIALS,
  name ,
  zipcode ,
  dateborn ,
  datejoined ,
  dateleft ,
  student ,
  pilot ,
  cat ,
  fullcat,
  typeOfChange
from Member_Profiling 
where((DATELEFT > DATEJOINED)
  and (DATEJOINED <= SYSDATE) 
  and (DATEJOINED >= DATEBORN)
  and (REGEXP_COUNT(student||pilot||cat||fullcat,'Y')=1 ) 
  and (DATEBORN <= SYSDATE) 
  and (DATEBORN > '01/01/1920' )
);

ALTER TABLE MEMBER_PROFILING2
ADD age int;
UPDATE MEMBER_PROFILING2
SET age = ((SYSDATE-dateborn)/365);

ALTER TABLE MEMBER_PROFILING2
ADD statut_member VARCHAR2(50);
UPDATE MEMBER_PROFILING2
SET statut_member = 'student' WHERE STUDENT = 'Y' ;
UPDATE MEMBER_PROFILING2
SET statut_member = 'pilot' WHERE PILOT = 'Y' ;
UPDATE MEMBER_PROFILING2
SET statut_member = 'cat' WHERE CAT = 'Y' ;
UPDATE MEMBER_PROFILING2
SET statut_member = 'fullcat' WHERE FULLCAT = 'Y' ;

ALTER TABLE MEMBER_PROFILING2 DROP COLUMN student;
ALTER TABLE MEMBER_PROFILING2 DROP COLUMN pilot;
ALTER TABLE MEMBER_PROFILING2 DROP COLUMN cat;
ALTER TABLE MEMBER_PROFILING2 DROP COLUMN fullcat;





Select
          MEMBERNO 
          from Member_Extract 
          where(typeOfChange = 2);



UPDATE MEMBER_PROFILING2 
SET age = ((SYSDATE-dateborn)/365)
where (typeOfChange = 4);

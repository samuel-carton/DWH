create table Member_Extract(
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
  fullcat CHAR(1 BYTE)
);
insert INTO Member_Extract(
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
  fullcat)
  (
SELECT DISTINCT 
  INITIALS,
  memberno,
  name,
  ZIPCODE,
  DATEBORN,
  DATEJOINED,
  DATELEFT,
  TAMEMBER.STATUSSTUDENT,
  TAMEMBER.STATUSPILOT,
  TAMEMBER.STATUSASCAT,
  TAMEMBER.STATUSFULLCAT  
  from TAMEMBER
);
INSERT into Club (name,zipcode)
(
  Select MANE, ZIPCODE from TACLUB
);
create table Flight_Extract(
  c_name varchar2 (50 BYTE),
  launchtime date,
  landingtime date,
  PlaneRegistration char(3 byte),
  Pilot1Init char(4 byte),
  Pilot2Init char(4 byte),
  cablebreak char(1 byte),
  crosscountrykm number(4,0),
  LaunchAerotow char(1 byte),
  Launchwinch char(1 byte),
  Launchsafelaunch char(1 byte)
);
INSERT into FLIGHT_EXTRACT(c_name, launchtime,landingtime,PlaneRegistration,Pilot1Init,Pilot2Init,cablebreak,crosscountrykm,LaunchAerotow,Launchwinch,Launchsafelaunch)
(
  Select 'TAFLIGHTSSG70', LAUNCHTIME, LANDINGTIME, PLANEREGISTRATION, PILOT1INIT, PILOT2INIT, CABLEBREAK, CROSSCOUNTRYKM, LAUNCHAEROTOW, LAUNCHWINCH, TAFLIGHTSSG70.LAUNCHSELFLAUNCH from TAFLIGHTSSG70
);
INSERT into FLIGHT_EXTRACT(c_name, launchtime,landingtime,PlaneRegistration,Pilot1Init,Pilot2Init,cablebreak,crosscountrykm,LaunchAerotow,Launchwinch,Launchsafelaunch)
(
  Select 'TAFLIGHTSVEJLE', LAUNCHTIME, LANDINGTIME, PLANEREGISTRATION, PILOT1INIT, PILOT2INIT, CABLEBREAK, CROSSCOUNTRYKM, LAUNCHAEROTOW, LAUNCHWINCH, LAUNCHSELFLAUNCH from TAFLIGHTSVEJLE
);
create table Member_Extract2(
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
  fullcat CHAR(1 BYTE)
);
insert into MEMBER_Extract2(
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
  fullcat
from MEMBER_EXTRACT
where((DATELEFT > DATEJOINED)
  and (DATEJOINED <= SYSDATE) 
  and (DATEJOINED >= DATEBORN)
  and (REGEXP_COUNT(student||pilot||cat||fullcat,'Y')=1 ) 
  and (DATEBORN <= SYSDATE) 
  and (DATEBORN > '01/01/1920' )
);
create table Flight_Extract2(
  c_name varchar2 (50 BYTE),
  launchtime date,
  landingtime date,
  PlaneRegistration char(3 byte),
  Pilot1Init char(4 byte),
  Pilot2Init char(4 byte),
  cablebreak char(1 byte),
  crosscountrykm number(4,0),
  LaunchAerotow char(1 byte),
  Launchwinch char(1 byte),
  Launchsafelaunch char(1 byte)
);
insert into Flight_Extract2(
  c_name ,
  launchtime ,
  landingtime ,
  PlaneRegistration ,
  Pilot1Init ,
  Pilot2Init ,
  cablebreak ,
  crosscountrykm ,
  LaunchAerotow ,
  Launchwinch ,
  Launchsafelaunch 
)
Select * FROM FLIGHT_EXTRACT
where 
(
(landingtime>launchtime) and
(landingtime<=SYSDATE)
and (launchtime>='17/12/1904')
and (REGEXP_COUNT(LaunchAerotow||Launchwinch||Launchsafelaunch,'Y')=1)
);


/* -------------------------------Flight_Extract2---------------------------*/
ALTER TABLE Flight_Extract2
ADD LaunchMethod int;

UPDATE Flight_Extract2
SET LAUNCHMETHOD = '1' WHERE LaunchAerotow = 'Y';
UPDATE Flight_Extract2
SET LAUNCHMETHOD = '2' WHERE Launchwinch = 'Y';
UPDATE Flight_Extract2
SET LAUNCHMETHOD = '3' WHERE Launchsafelaunch = 'Y';
UPDATE Flight_Extract2
SET PILOT2INIT = 'PASS' WHERE PILOT2INIT = ' ';

ALTER TABLE Flight_Extract2 DROP COLUMN LaunchAerotow;
ALTER TABLE Flight_Extract2 DROP COLUMN Launchwinch;
ALTER TABLE Flight_Extract2 DROP COLUMN Launchsafelaunch;

/* -------------------------------MEMBER_Extract2---------------------------*/
ALTER TABLE MEMBER_Extract2
ADD age int;
UPDATE MEMBER_Extract2
SET age = ((SYSDATE-dateborn)/365);

ALTER TABLE MEMBER_Extract2
ADD statut_member VARCHAR2(50);
UPDATE MEMBER_Extract2
SET statut_member = 'student' WHERE STUDENT = 'Y' ;
UPDATE MEMBER_Extract2
SET statut_member = 'pilot' WHERE PILOT = 'Y' ;
UPDATE MEMBER_Extract2
SET statut_member = 'cat' WHERE CAT = 'Y' ;
UPDATE MEMBER_Extract2
SET statut_member = 'fullcat' WHERE FULLCAT = 'Y' ;

ALTER TABLE MEMBER_Extract2 DROP COLUMN student;
ALTER TABLE MEMBER_Extract2 DROP COLUMN pilot;
ALTER TABLE MEMBER_Extract2 DROP COLUMN cat;
ALTER TABLE MEMBER_Extract2 DROP COLUMN fullcat;

/*DROP TABLE MEMBER_Extract;
DROP TABLE MEMBER_Extract2;
DROP TABLE FLIGHT_EXTRACT;
DROP TABLE FLIGHT_EXTRACT2;*/










 
 

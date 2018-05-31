create table Member_Profiling(
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
insert INTO Member_Profiling(
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

/*SELECT * FROM MEMBER_PROFILING;*/


create table Club_Profiling(
  name VARCHAR2(50 byte),
  zipcode number(4,0)
  );
INSERT into Club_Profiling(name,zipcode)
(
  Select MANE, ZIPCODE from TACLUB
);

/*SELECT * FROM Club_Profiling;*/
create table F_Flight(
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

INSERT into F_Flight(c_name, launchtime,landingtime,PlaneRegistration,Pilot1Init,Pilot2Init,cablebreak,crosscountrykm,LaunchAerotow,Launchwinch,Launchsafelaunch)
(
  Select 'TAFLIGHTSSG70', LAUNCHTIME, LANDINGTIME, PLANEREGISTRATION, PILOT1INIT, PILOT2INIT, CABLEBREAK, CROSSCOUNTRYKM, LAUNCHAEROTOW, LAUNCHWINCH, TAFLIGHTSSG70.LAUNCHSELFLAUNCH from TAFLIGHTSSG70
);

INSERT into F_Flight(c_name, launchtime,landingtime,PlaneRegistration,Pilot1Init,Pilot2Init,cablebreak,crosscountrykm,LaunchAerotow,Launchwinch,Launchsafelaunch)
(
  Select 'TAFLIGHTSVEJLE', LAUNCHTIME, LANDINGTIME, PLANEREGISTRATION, PILOT1INIT, PILOT2INIT, CABLEBREAK, CROSSCOUNTRYKM, LAUNCHAEROTOW, LAUNCHWINCH, LAUNCHSELFLAUNCH from TAFLIGHTSVEJLE
);

/*SELECT * FROM F_Flight;*/


create table Member_Profiling2(
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
/*select * from MEMBER_PROFILING2;
drop table MEMBER_PROFILING2;*/

insert into MEMBER_PROFILING2(
  memberno,
  name ,
  zipcode ,
  dateborn ,
  datejoined ,
  dateleft ,
  student ,
  pilot ,
  cat ,
  fullcat )
Select memberno,
  name ,
  zipcode ,
  dateborn ,
  datejoined ,
  dateleft ,
  student ,
  pilot ,
  cat ,
  fullcat
from Member_Profiling 
where((DATELEFT > DATEJOINED)
  and (DATEJOINED <= SYSDATE) 
  and (DATEJOINED >= DATEBORN)
  and (REGEXP_COUNT(student||pilot||cat||fullcat,'Y')=1 ) 
  and (DATEBORN <= SYSDATE) 
  and (DATEBORN > '01/01/1920' )
);

create table F_Flight2(
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

insert into F_Flight2(
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
Select * FROM F_Flight
where 
(
(landingtime>launchtime) and
(landingtime<=SYSDATE)
and (launchtime>='17/12/1904')
and (REGEXP_COUNT(LaunchAerotow||Launchwinch||Launchsafelaunch,'Y')=1)
);

ALTER TABLE F_Flight2
ADD LaunchMethod int;

UPDATE F_Flight2
SET LAUNCHMETHOD = '1' WHERE LaunchAerotow = 'Y';
UPDATE F_Flight2
SET LAUNCHMETHOD = '2' WHERE Launchwinch = 'Y';
UPDATE F_Flight2
SET LAUNCHMETHOD = '3' WHERE Launchsafelaunch = 'Y';
UPDATE F_Flight2
SET PILOT2INIT = 'PASS' WHERE PILOT2INIT = ' ';

ALTER TABLE F_Flight2 DROP COLUMN LaunchAerotow;
ALTER TABLE F_Flight2 DROP COLUMN Launchwinch;
ALTER TABLE F_Flight2 DROP COLUMN Launchsafelaunch;

SELECT * FROM F_Flight2;

ALTER TABLE MEMBER_PROFILING2
ADD age int;
UPDATE MEMBER_PROFILING2
SET age = ((SYSDATE-dateborn)/365);

SELECT * FROM MEMBER_PROFILING2;

ALTER TABLE MEMBER_PROFILING2
ADD statut_member VARCHAR2(50);
UPDATE MEMBER_PROFILING2
SET statut_member = 'student' WHERE statut = '1' ;
UPDATE MEMBER_PROFILING2
SET statut_member = 'pilot' WHERE statut = '2' ;
UPDATE MEMBER_PROFILING2
SET statut_member = 'cat' WHERE statut = '3' ;
UPDATE MEMBER_PROFILING2
SET statut_member = 'fullcat' WHERE statut = '4' ;

ALTER TABLE MEMBER_PROFILING2 DROP COLUMN student;
ALTER TABLE MEMBER_PROFILING2 DROP COLUMN pilot;
ALTER TABLE MEMBER_PROFILING2 DROP COLUMN cat;
ALTER TABLE MEMBER_PROFILING2 DROP COLUMN fullcat;
ALTER TABLE MEMBER_PROFILING2 DROP COLUMN statut;












 
 

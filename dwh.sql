create table Member_Profiling(
  memberno NUMBER(6,0),
  name VARCHAR2(50 BYTE),
  zipcode NUMBER(4,0),
  dateborn date,
  datejoined date,
  dateleft date
);
insert INTO Member_Profiling(memberno, name ,
  zipcode ,
  dateborn ,
  datejoined ,
  dateleft)
  (
SELECT DISTINCT memberno, name, ZIPCODE, DATEBORN, DATEJOINED, DATELEFT  from TAMEMBER
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
  crosscountrykm number(4,0)
);
/*
  LaunchAerotow char(1 byte),
  Launchwinch char(1 byte),
  Launchsafelaunch char(1 byte),
*/ 
INSERT into F_Flight(c_name, launchtime,landingtime,PlaneRegistration,Pilot1Init,Pilot2Init,cablebreak,crosscountrykm)
(
  Select 'TAFLIGHTSSG70', LAUNCHTIME, LANDINGTIME, PLANEREGISTRATION, PILOT1INIT, PILOT2INIT, CABLEBREAK, CROSSCOUNTRYKM from TAFLIGHTSSG70
);

INSERT into F_Flight(c_name, launchtime,landingtime,PlaneRegistration,Pilot1Init,Pilot2Init,cablebreak,crosscountrykm)
(
  Select 'TAFLIGHTSVEJLE', LAUNCHTIME, LANDINGTIME, PLANEREGISTRATION, PILOT1INIT, PILOT2INIT, CABLEBREAK, CROSSCOUNTRYKM from TAFLIGHTSVEJLE
);

/*SELECT * FROM F_Flight;*/

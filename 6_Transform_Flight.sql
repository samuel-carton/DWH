
create table F_Flight(
  c_id number,
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

create table F_Flight2(
  c_id number,
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

INSERT into F_Flight(c_id, launchtime,landingtime,PlaneRegistration,Pilot1Init,Pilot2Init,cablebreak,crosscountrykm,LaunchAerotow,Launchwinch,Launchsafelaunch)
(
  Select 3, LAUNCHTIME, LANDINGTIME, PLANEREGISTRATION, PILOT1INIT, PILOT2INIT, CABLEBREAK, CROSSCOUNTRYKM, LAUNCHAEROTOW, LAUNCHWINCH, LAUNCHSELFLAUNCH from Flight_Extract
  where club = 1
);

INSERT into F_Flight(c_id, launchtime,landingtime,PlaneRegistration,Pilot1Init,Pilot2Init,cablebreak,crosscountrykm,LaunchAerotow,Launchwinch,Launchsafelaunch)
(
  Select 2, LAUNCHTIME, LANDINGTIME, PLANEREGISTRATION, PILOT1INIT, PILOT2INIT, CABLEBREAK, CROSSCOUNTRYKM, LAUNCHAEROTOW, LAUNCHWINCH, LAUNCHSELFLAUNCH from Flight_Extract
  where club = 2
);

/*SELECT * FROM F_Flight;*/


insert into F_Flight2(
  c_id ,
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




 
 

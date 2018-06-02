DROP TABLE Flight_T;
DROP TABLE Flight_T2;
CREATE TABLE Flight_T
  (
    c_id              NUMBER,
    launchtime        DATE,
    landingtime       DATE,
    PlaneRegistration CHAR(3 byte),
    Pilot1Init        CHAR(4 byte),
    Pilot2Init        CHAR(4 byte),
    cablebreak        CHAR(1 byte),
    crosscountrykm    NUMBER(4,0),
    LaunchAerotow     CHAR(1 byte),
    Launchwinch       CHAR(1 byte),
    Launchsafelaunch  CHAR(1 byte)
  );
CREATE TABLE Flight_T2
  (
    c_id              NUMBER,
    launchtime        DATE,
    landingtime       DATE,
    PlaneRegistration CHAR(3 byte),
    Pilot1Init        CHAR(4 byte),
    Pilot2Init        CHAR(4 byte),
    cablebreak        CHAR(1 byte),
    crosscountrykm    NUMBER(4,0),
    LaunchAerotow     CHAR(1 byte),
    Launchwinch       CHAR(1 byte),
    Launchsafelaunch  CHAR(1 byte)
  );
INSERT    --merge the two flight sources
INTO Flight_T
  (
    c_id,
    launchtime,
    landingtime,
    PlaneRegistration,
    Pilot1Init,
    Pilot2Init,
    cablebreak,
    crosscountrykm,
    LaunchAerotow,
    Launchwinch,
    Launchsafelaunch
  )
  (SELECT 3,
      LAUNCHTIME,
      LANDINGTIME,
      PLANEREGISTRATION,
      PILOT1INIT,
      PILOT2INIT,
      CABLEBREAK,
      CROSSCOUNTRYKM,
      LAUNCHAEROTOW,
      LAUNCHWINCH,
      LAUNCHSELFLAUNCH
    FROM Flight_Extract
    WHERE club = 1
  );
INSERT
INTO Flight_T
  (
    c_id,
    launchtime,
    landingtime,
    PlaneRegistration,
    Pilot1Init,
    Pilot2Init,
    cablebreak,
    crosscountrykm,
    LaunchAerotow,
    Launchwinch,
    Launchsafelaunch
  )
  (SELECT 2,
      LAUNCHTIME,
      LANDINGTIME,
      PLANEREGISTRATION,
      PILOT1INIT,
      PILOT2INIT,
      CABLEBREAK,
      CROSSCOUNTRYKM,
      LAUNCHAEROTOW,
      LAUNCHWINCH,
      LAUNCHSELFLAUNCH
    FROM Flight_Extract
    WHERE club = 2
  );

INSERT   --data verification and merging of the lunching methods
INTO Flight_T2
  (
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
SELECT *
FROM Flight_T
WHERE ( (landingtime>launchtime)
AND (landingtime   <=SYSDATE)
AND (launchtime    >='17/12/1904')
AND (REGEXP_COUNT(LaunchAerotow
  ||Launchwinch
  ||Launchsafelaunch,'Y')=1) );
ALTER TABLE Flight_T2 ADD LaunchMethod INT;
UPDATE Flight_T2 SET LAUNCHMETHOD = '1' WHERE LaunchAerotow = 'Y';
UPDATE Flight_T2 SET LAUNCHMETHOD = '2' WHERE Launchwinch = 'Y';
UPDATE Flight_T2 SET LAUNCHMETHOD = '3' WHERE Launchsafelaunch = 'Y';
UPDATE Flight_T2 SET PILOT2INIT = 'PASS' WHERE PILOT2INIT = ' ';
ALTER TABLE Flight_T2
DROP COLUMN LaunchAerotow;
ALTER TABLE Flight_T2
DROP COLUMN Launchwinch;
ALTER TABLE Flight_T2
DROP COLUMN Launchsafelaunch;

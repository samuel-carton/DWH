DROP TABLE Flight_Extract;
CREATE TABLE Flight_Extract
  (
    launchtime        DATE,
    landingtime       DATE,
    PlaneRegistration CHAR(3 byte),
    Pilot1Init        CHAR(4 byte),
    Pilot2Init        CHAR(4 byte),
    cablebreak        CHAR(1 byte),
    crosscountrykm    NUMBER(4,0),
    LaunchAerotow     CHAR(1 byte),
    Launchwinch       CHAR(1 byte),
    LAUNCHSELFLAUNCH  CHAR(1 byte),
    club              NUMBER
  );
SELECT 'Extract Members at: '
  || TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI') AS extractTime
FROM dual ;
SELECT 'Row counts before: ' FROM dual
UNION ALL
SELECT 'Rows in extract table before (should be zero)'
  || TO_CHAR(COUNT(*))
FROM Flight_Extract
UNION ALL
SELECT 'Rows in Members table ' || TO_CHAR(COUNT(*)) FROM TAFLIGHTSSG70
UNION ALL
SELECT 'Rows in Members table (yesterday copy) '
  || TO_CHAR(COUNT(*))
FROM TAFLIGHTSSG70Yesterday ;
-- **** here goes the extract of added rows
-- **** (i.e. rows from today whose primary key is in the set of (PKs from today minus PKs yesterday)
INSERT
INTO Flight_Extract
  (
    launchtime ,
    landingtime ,
    PlaneRegistration,
    Pilot1Init ,
    Pilot2Init ,
    cablebreak ,
    crosscountrykm ,
    LaunchAerotow ,
    Launchwinch,
    LAUNCHSELFLAUNCH,
    club
  )
  (SELECT launchtime ,
      landingtime ,
      PlaneRegistration,
      Pilot1Init ,
      Pilot2Init ,
      cablebreak ,
      crosscountrykm ,
      LaunchAerotow ,
      Launchwinch,
      LAUNCHSELFLAUNCH,
      1
    FROM TAFLIGHTSSG70
    WHERE( LAUNCHTIME IN
      ( SELECT LAUNCHTIME FROM TAFLIGHTSSG70
      MINUS
      SELECT LAUNCHTIME FROM TAFLIGHTSSG70Yesterday
      )
    AND pilot1init IN
      ( SELECT pilot1init FROM TAFLIGHTSSG70
      MINUS
      SELECT pilot1init FROM TAFLIGHTSSG70Yesterday
      ))
  );
INSERT
INTO Flight_Extract
  (
    launchtime ,
    landingtime ,
    PlaneRegistration,
    Pilot1Init ,
    Pilot2Init ,
    cablebreak ,
    crosscountrykm ,
    LaunchAerotow ,
    Launchwinch,
    LAUNCHSELFLAUNCH,
    club
  )
  (SELECT launchtime ,
      landingtime ,
      PlaneRegistration,
      Pilot1Init ,
      Pilot2Init ,
      cablebreak ,
      crosscountrykm ,
      LaunchAerotow ,
      Launchwinch,
      LAUNCHSELFLAUNCH,
      2
    FROM TAFLIGHTSVEJLE
    WHERE( LAUNCHTIME IN
      ( SELECT LAUNCHTIME FROM TAFLIGHTSVEJLE
      MINUS
      SELECT LAUNCHTIME FROM TAFLIGHTSVEJLEYesterday
      )
    AND pilot1init IN
      ( SELECT pilot1init FROM TAFLIGHTSVEJLE
      MINUS
      SELECT pilot1init FROM TAFLIGHTSVEJLEYesterday
      ))
  );
SELECT 'Rows in extract table after, by operations type' FROM dual ;
SELECT operation , COUNT(*) FROM Flight_Extract GROUP BY operation ;
-- --------------------------------------------
-- copy the current TAFLIGHTSSG70 TAFLIGHTSVEJLE table in TAFLIGHTSSG70Yesterday and TAFLIGHTSVEJLEYesterday for the next extract
-- --------------------------------------------
DROP TABLE TAFLIGHTSSG70Yesterday;
DROP TABLE TAFLIGHTSVEJLEYesterday;
CREATE TABLE TAFLIGHTSSG70Yesterday
  (
    launchtime        DATE,
    landingtime       DATE,
    PlaneRegistration CHAR(3 byte),
    Pilot1Init        CHAR(4 byte),
    Pilot2Init        CHAR(4 byte),
    cablebreak        CHAR(1 byte),
    crosscountrykm    NUMBER(4,0),
    LaunchAerotow     CHAR(1 byte),
    Launchwinch       CHAR(1 byte),
    Launchselflaunch  CHAR(1 byte)
  );
CREATE TABLE TAFLIGHTSVEJLEYesterday
  (
    launchtime        DATE,
    landingtime       DATE,
    PlaneRegistration CHAR(3 byte),
    Pilot1Init        CHAR(4 byte),
    Pilot2Init        CHAR(4 byte),
    cablebreak        CHAR(1 byte),
    crosscountrykm    NUMBER(4,0),
    LaunchAerotow     CHAR(1 byte),
    Launchwinch       CHAR(1 byte),
    Launchselflaunch  CHAR(1 byte)
  );
INSERT
INTO TAFLIGHTSSG70Yesterday
  (
    launchtime ,
    landingtime ,
    PlaneRegistration,
    Pilot1Init ,
    Pilot2Init ,
    cablebreak ,
    crosscountrykm ,
    LaunchAerotow ,
    Launchwinch ,
    Launchselflaunch
  )
  (SELECT launchtime ,
      landingtime ,
      PlaneRegistration,
      Pilot1Init ,
      Pilot2Init ,
      cablebreak ,
      crosscountrykm ,
      LaunchAerotow ,
      Launchwinch ,
      Launchselflaunch
    FROM TAFLIGHTSSG70
  );
INSERT
INTO TAFLIGHTSVEJLEYesterday
  (
    launchtime ,
    landingtime ,
    PlaneRegistration,
    Pilot1Init ,
    Pilot2Init ,
    cablebreak ,
    crosscountrykm ,
    LaunchAerotow ,
    Launchwinch ,
    Launchselflaunch
  )
  (SELECT launchtime ,
      landingtime ,
      PlaneRegistration,
      Pilot1Init ,
      Pilot2Init ,
      cablebreak ,
      crosscountrykm ,
      LaunchAerotow ,
      Launchwinch ,
      Launchselflaunch
    FROM TAFLIGHTSVEJLE
  );
EXIT;

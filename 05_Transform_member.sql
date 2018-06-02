DROP TABLE Member_T;
DROP TABLE Member_T2;
CREATE TABLE Member_T     -- first transformation with a distinct
  (
    INITIALS     CHAR(4 BYTE),
    memberno     NUMBER(6,0),
    name         VARCHAR2(50 BYTE),
    zipcode      NUMBER(4,0),
    dateborn     DATE,
    datejoined   DATE,
    dateleft     DATE,
    student      CHAR(1 BYTE),
    pilot        CHAR(1 BYTE),
    cat          CHAR(1 BYTE),
    fullcat      CHAR(1 BYTE),
    CLUB         VARCHAR2(50 BYTE),
    typeOfChange NUMBER
  );
INSERT
INTO Member_T
  (
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
    CLUB,
    typeOfChange
  )
  ( SELECT DISTINCT INITIALS,
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
      CLUB,
      typeOfChange
    FROM Member_Extract
    WHERE(typeOfChange = 1
    OR typeOfChange    = 3)
  );
CREATE TABLE Member_T2    -- second transformation with data verification
  (
    memberid     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    INITIALS     CHAR(4 BYTE),
    memberno     NUMBER(6,0),
    name         VARCHAR2(50 BYTE),
    zipcode      NUMBER(4,0),
    dateborn     DATE,
    datejoined   DATE,
    dateleft     DATE,
    student      CHAR(1 BYTE),
    pilot        CHAR(1 BYTE),
    cat          CHAR(1 BYTE),
    fullcat      CHAR(1 BYTE),
    CLUB         VARCHAR2(50 BYTE),
    typeOfChange NUMBER
  );
INSERT
INTO Member_T2
  (
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
    CLUB,
    typeOfChange
  )
SELECT memberno,
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
  CLUB,
  typeOfChange
FROM Member_T
WHERE((DATELEFT  > DATEJOINED)
AND (DATEJOINED <= SYSDATE)
AND (DATEJOINED >= DATEBORN)
AND (REGEXP_COUNT(student
  ||pilot
  ||cat
  ||fullcat,'Y')=1 )
AND (DATEBORN  <= SYSDATE)
AND (DATEBORN   > '01/01/1920' ) );

ALTER TABLE Member_T2 ADD age INT;   --merge the four status in one
UPDATE Member_T2 SET age = ((SYSDATE-dateborn)/365);
ALTER TABLE Member_T2 ADD statut_member VARCHAR2(50);
UPDATE Member_T2 SET statut_member = 'student' WHERE STUDENT = 'Y' ;
UPDATE Member_T2 SET statut_member = 'pilot' WHERE PILOT = 'Y' ;
UPDATE Member_T2 SET statut_member = 'cat' WHERE CAT = 'Y' ;
UPDATE Member_T2 SET statut_member = 'fullcat' WHERE FULLCAT = 'Y' ;
ALTER TABLE Member_T2
DROP COLUMN student;
ALTER TABLE Member_T2
DROP COLUMN pilot;
ALTER TABLE Member_T2
DROP COLUMN cat;
ALTER TABLE Member_T2
DROP COLUMN fullcat;

ALTER TABLE Member_T2 ADD club_id NUMBER;  --replace the club name with an id
UPDATE Member_T2 SET club_id = 2 WHERE CLUB = 'Vejle';
UPDATE Member_T2 SET club_id = 3 WHERE CLUB = 'SG70';
ALTER TABLE Member_T2
DROP COLUMN CLUB;

UPDATE Member_T2 SET age = ((SYSDATE-dateborn)/365) WHERE (typeOfChange = 4);  --update the age

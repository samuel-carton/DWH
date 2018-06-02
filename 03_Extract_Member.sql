DROP TABLE Member_Extract;
CREATE TABLE Member_Extract
  (
    "MEMBERNO"      NUMBER(6,0) ,
    "INITIALS"      CHAR(4 BYTE) ,
    "NAME"          VARCHAR2(50 BYTE) ,
    "ADDRESS"       VARCHAR2(50 BYTE) ,
    "ZIPCODE"       NUMBER(4,0) ,
    "DATEBORN"      DATE ,
    "DATEJOINED"    DATE ,
    "DATELEFT"      DATE,
    "OWNSPLANEREG"  CHAR(3 BYTE) ,
    "STATUSSTUDENT" CHAR(1 BYTE) ,
    "STATUSPILOT"   CHAR(1 BYTE) ,
    "STATUSASCAT"   CHAR(1 BYTE) ,
    "STATUSFULLCAT" CHAR(1 BYTE) ,
    "SEX"           CHAR(1 BYTE) ,
    "CLUB"          VARCHAR2(50 BYTE) ,
    typeOfChange    NUMBER
  );
SELECT 'Extract Members at: '
  || TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI') AS extractTime
FROM dual ;
SELECT 'Row counts before: ' FROM dual
UNION ALL
SELECT 'Rows in extract table before (should be zero)'
  || TO_CHAR(COUNT(*))
FROM Member_Extract
UNION ALL
SELECT 'Rows in Members table ' || TO_CHAR(COUNT(*)) FROM taMember
UNION ALL
SELECT 'Rows in Members table (yesterday copy) '
  || TO_CHAR(COUNT(*))
FROM TaMemberYesterday ;
-- **** here goes the extract of added rows
-- **** (i.e. rows from today whose primary key is in the set of (PKs from today minus PKs yesterday)
INSERT
INTO Member_Extract
  (
    MEMBERNO ,
    INITIALS ,
    NAME ,
    ADDRESS ,
    ZIPCODE ,
    DATEBORN ,
    DATEJOINED ,
    DATELEFT ,
    OWNSPLANEREG ,
    STATUSSTUDENT ,
    STATUSPILOT ,
    STATUSASCAT ,
    STATUSFULLCAT,
    SEX ,
    CLUB,
    typeOfChange
  )
  (SELECT MEMBERNO ,
      INITIALS ,
      NAME ,
      ADDRESS ,
      ZIPCODE ,
      DATEBORN ,
      DATEJOINED ,
      DATELEFT ,
      OWNSPLANEREG ,
      STATUSSTUDENT ,
      STATUSPILOT ,
      STATUSASCAT ,
      STATUSFULLCAT,
      SEX ,
      CLUB,
      1
    FROM taMember
    WHERE MEMBERNO IN
      ( SELECT MEMBERNO FROM taMember
      MINUS
      SELECT MEMBERNO FROM taMemberYesterday
      )
  );
-- **** here goes the extract of deleted rows
-- **** (i.e. rows from yesterday whose primary key is in the set of (PKs from yesterday minus PKs today)
INSERT
INTO Member_Extract
  (
    MEMBERNO ,
    INITIALS ,
    NAME ,
    ADDRESS ,
    ZIPCODE ,
    DATEBORN ,
    DATEJOINED ,
    DATELEFT ,
    OWNSPLANEREG ,
    STATUSSTUDENT ,
    STATUSPILOT ,
    STATUSASCAT ,
    STATUSFULLCAT,
    SEX ,
    CLUB,
    typeOfChange
  )
  (SELECT MEMBERNO ,
      INITIALS ,
      NAME ,
      ADDRESS ,
      ZIPCODE ,
      DATEBORN ,
      DATEJOINED ,
      DATELEFT ,
      OWNSPLANEREG ,
      STATUSSTUDENT ,
      STATUSPILOT ,
      STATUSASCAT ,
      STATUSFULLCAT,
      SEX ,
      CLUB,
      2
    FROM taMemberYesterday
    WHERE MEMBERNO IN
      ( SELECT MEMBERNO FROM taMemberYesterday
      MINUS
      SELECT MEMBERNO FROM taMember
      )
  );
-- **** here goes the extract of changed rows
-- **** (i.e. (rows from today minus rows from yesterday) - new rows )
INSERT
INTO Member_Extract
  (
    MEMBERNO ,
    INITIALS ,
    NAME ,
    ADDRESS ,
    ZIPCODE ,
    DATEBORN ,
    DATEJOINED ,
    DATELEFT ,
    OWNSPLANEREG ,
    STATUSSTUDENT ,
    STATUSPILOT ,
    STATUSASCAT ,
    STATUSFULLCAT,
    SEX ,
    CLUB,
    typeOfChange
  )
  (SELECT MEMBERNO ,
      INITIALS ,
      NAME ,
      ADDRESS ,
      ZIPCODE ,
      DATEBORN ,
      DATEJOINED ,
      DATELEFT ,
      OWNSPLANEREG ,
      STATUSSTUDENT ,
      STATUSPILOT ,
      STATUSASCAT ,
      STATUSFULLCAT,
      SEX ,
      CLUB ,
      3
    FROM
      ( SELECT * FROM taMember
      MINUS
      SELECT * FROM taMemberYesterday
      ) changes
    WHERE NOT changes.MEMBERNO IN
      ( SELECT MEMBERNO FROM taMember
      MINUS
      SELECT MEMBERNO FROM taMemberYesterday
      )
  );
-- **** here goes the extract of Members whose age changed (i.e. those who have a birthday today)
-- **** (i.e. (rows from today with dateBorn(DDMM) = current date(DDMM) - already extracted PKs)
INSERT
INTO Member_Extract
  (
    MEMBERNO ,
    INITIALS ,
    NAME ,
    ADDRESS ,
    ZIPCODE ,
    DATEBORN ,
    DATEJOINED ,
    DATELEFT ,
    OWNSPLANEREG ,
    STATUSSTUDENT ,
    STATUSPILOT ,
    STATUSASCAT ,
    STATUSFULLCAT,
    SEX ,
    CLUB,
    typeOfChange
  )
  (SELECT MEMBERNO ,
      INITIALS ,
      NAME ,
      ADDRESS ,
      ZIPCODE ,
      DATEBORN ,
      DATEJOINED ,
      DATELEFT ,
      OWNSPLANEREG ,
      STATUSSTUDENT ,
      STATUSPILOT ,
      STATUSASCAT ,
      STATUSFULLCAT,
      SEX ,
      CLUB,
      4
    FROM taMember
    WHERE (EXTRACT(MONTH FROM dateborn) = EXTRACT(MONTH FROM SYSDATE))
    AND (EXTRACT(DAY FROM dateborn)     = EXTRACT(DAY FROM SYSDATE))
  ) ;
SELECT * FROM MEMBER_EXTRACT WHERE TYPEOFCHANGE=4;
-- --------------------------------------------
-- post-extract report
-- --------------------------------------------
SELECT 'Rows in extract table after, by operations type'
FROM dual ;
SELECT typeOfChange , COUNT(*) FROM Member_Extract GROUP BY typeOfChange ;

-- --------------------------------------------
-- copy the current taMember table in TaMemberYesterday for the next extract
-- --------------------------------------------
DROP TABLE TaMemberYesterday;
CREATE TABLE TaMemberYesterday
  (
    "MEMBERNO"      NUMBER(6,0) ,
    "INITIALS"      CHAR(4 BYTE) ,
    "NAME"          VARCHAR2(50 BYTE) ,
    "ADDRESS"       VARCHAR2(50 BYTE) ,
    "ZIPCODE"       NUMBER(4,0) ,
    "DATEBORN"      DATE ,
    "DATEJOINED"    DATE ,
    "DATELEFT"      DATE,
    "OWNSPLANEREG"  CHAR(3 BYTE) ,
    "STATUSSTUDENT" CHAR(1 BYTE) ,
    "STATUSPILOT"   CHAR(1 BYTE) ,
    "STATUSASCAT"   CHAR(1 BYTE) ,
    "STATUSFULLCAT" CHAR(1 BYTE) ,
    "SEX"           CHAR(1 BYTE) ,
    "CLUB"          VARCHAR2(50 BYTE)
  );
INSERT
INTO TaMemberYesterday
  (
    MEMBERNO ,
    INITIALS ,
    NAME ,
    ADDRESS ,
    ZIPCODE ,
    DATEBORN ,
    DATEJOINED ,
    DATELEFT ,
    OWNSPLANEREG ,
    STATUSSTUDENT ,
    STATUSPILOT ,
    STATUSASCAT ,
    STATUSFULLCAT,
    SEX ,
    CLUB
  )
  (SELECT * FROM tamember
  );
EXIT;

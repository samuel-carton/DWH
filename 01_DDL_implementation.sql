CREATE TABLE d_date (
  id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
  fullDate date
  );
create table Club(
  id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR2(50 byte),
  zipcode number(4,0)
  );
create table Member(
  id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  memberno NUMBER(6,0),
  name VARCHAR2(50 BYTE),
  zipcode NUMBER(4,0),
  dateborn date,
  datejoined date,
  dateleft date,
  statut VARCHAR2(50),
  age int,
  valid_to date,
  valid_from date,
  club_id number,
  constraint FK_clubM_id foreign key (club_id) references Club(id)
);
CREATE table Bridge(
id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
member1 char(4 byte),
member2 char(4 byte)
);
create table Flight(
  id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  PlaneRegistration char(3 byte),
  groupid NUMBER,
  Launchtime date,
  Landingtime date,
  CableBreak char(1 byte),
  CrossCountryKm number(4,0),
  LaunchMethod varchar2(50),
  club_id NUMBER,
  constraint FK_group_id foreign key(groupid) references Bridge(id),
  constraint FK_club_id foreign key (club_id) references Club(id),
  constraint FK_Launchtime foreign key(Launchtime) references d_date(id),
  constraint FK_Landingtime foreign key(Landingtime) references d_date(id)
);
INSERT into Club(name,zipcode)
(
  Select MANE, ZIPCODE from TACLUB
);

create table TAFLIGHTSSG70Yesterday(
  launchtime date,
  landingtime date,
  PlaneRegistration char(3 byte),
  Pilot1Init char(4 byte),
  Pilot2Init char(4 byte),
  cablebreak char(1 byte),
  crosscountrykm number(4,0),
  LaunchAerotow char(1 byte),
  Launchwinch char(1 byte),
  Launchselflaunch char(1 byte) 
);

 create table TAFLIGHTSVEJLEYesterday(
  launchtime date,
  landingtime date,
  PlaneRegistration char(3 byte),
  Pilot1Init char(4 byte),
  Pilot2Init char(4 byte),
  cablebreak char(1 byte),
  crosscountrykm number(4,0),
  LaunchAerotow char(1 byte),
  Launchwinch char(1 byte),
  Launchselflaunch char(1 byte) 
  );
  
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
/*
DROP TABLE Flight;
DROP TABLE Bridge;
DROP TABLE Member;
DROP TABLE Club;
DROP TABLE d_date;*/
                                    /*this document create the tables for the dimensional model
                                    and empty tables for the estracts files*/
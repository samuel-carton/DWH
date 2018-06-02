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
member1_id number,
member2_id number,
constraint FK_member1_id foreign key (member1_id) references Member(id),
constraint FK_member2_id foreign key (member2_id) references Member(id)
);
create table Flight(
  id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  PlaneRegistration char(3 byte),
  groupid NUMBER,
  Launchtime NUMBER,
  Landingtime NUMBER,
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

/*
DROP TABLE Flight;
DROP TABLE Bridge;
DROP TABLE Member;
DROP TABLE Club;
DROP TABLE d_date;*/

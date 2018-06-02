/* --------------------------------------------------- */
/*   ETLMemberExtract                                  */
/* --------------------------------------------------- */
/* extracts added, deleted and changed rows from the   */
/* members table + members who have a birthday on the  */
/* current date (since this represents a change of     */
/* age                                                 */
/*                                                     */
/* --------------------------------------------------- */

-- --------------------------------------------
-- pre-extract report
-- --------------------------------------------
drop table Member_Extract;
create table Member_Extract(
  memberno NUMBER(6,0),
  name VARCHAR2(50 BYTE),
  zipcode NUMBER(4,0),
  dateborn date,
  datejoined date,
  dateleft date,
  student CHAR(1 BYTE),
  pilot CHAR(1 BYTE),
  cat CHAR(1 BYTE),
  fullcat CHAR(1 BYTE),
  typeOfChange number
);



select 'Extract Members at: ' || to_char(sysdate,'YYYY-MM-DD HH24:MI') as extractTime
  from dual
  ;

  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero)' || to_char(count(*))
   from Member_Extract
union all
  select 'Rows in Members table ' || to_char(count(*))
   from taMember
union all
  select 'Rows in Members table (yesterday copy) ' || to_char(count(*))
   from TaMemberYesterday
 ;

-- **** here goes the extract of added rows 
-- **** (i.e. rows from today whose primary key is in the set of (PKs from today minus PKs yesterday)
insert into Member_Extract(
  MEMBERNO , 
	INITIALS , 
	NAME , 
	ADDRESS , 
	ZIPCODE  , 
	DATEBORN , 
	DATEJOINED , 
	DATELEFT , 
	OWNSPLANEREG , 
	STATUSSTUDENT , 
	STATUSPILOT  , 
	STATUSASCAT , 
	STATUSFULLCAT, 
	SEX , 
	CLUB,
  typeOfChange)
    (
    select *,1
			from taMember
			where id in
			(
			select ID
				from taMember
			minus
				select ID
					from taMemberYesterday
			));


-- **** here goes the extract of deleted rows 
-- **** (i.e. rows from yesterday whose primary key is in the set of (PKs from yesterday minus PKs today)

		insert into Member_Extract(
  MEMBERNO , 
	INITIALS , 
	NAME , 
	ADDRESS , 
	ZIPCODE  , 
	DATEBORN , 
	DATEJOINED , 
	DATELEFT , 
	OWNSPLANEREG , 
	STATUSSTUDENT , 
	STATUSPILOT  , 
	STATUSASCAT , 
	STATUSFULLCAT, 
	SEX , 
	CLUB,
  typeOfChange)
    (select *,2
			from taMember
			where id in
			(
				select ID
					from taMemberYesterday
			minus
				select ID
					from taMember
			));

-- **** here goes the extract of changed rows 
-- **** (i.e. (rows from today minus rows from yesterday) - new rows )
	insert into Member_Extract(
  MEMBERNO , 
	INITIALS , 
	NAME , 
	ADDRESS , 
	ZIPCODE  , 
	DATEBORN , 
	DATEJOINED , 
	DATELEFT , 
	OWNSPLANEREG , 
	STATUSSTUDENT , 
	STATUSPILOT  , 
	STATUSASCAT , 
	STATUSFULLCAT, 
	SEX , 
	CLUB,
  typeOfChange)
    (
		select *,3
			from (
				select * from taMember
			minus
				select * from taMemberYesterday
			) changes
		where not changes.id in
		(
				select ID from taMember
			minus
				select ID from taMemberYesterday
		));

	
		
-- **** here goes the extract of Members whose age changed (i.e. those who have a birthday today) 
-- **** (i.e. (rows from today with dateBorn(DDMM) = current date(DDMM) - already extracted PKs)
     insert into Member_Extract(
  MEMBERNO , 
	INITIALS , 
	NAME , 
	ADDRESS , 
	ZIPCODE  , 
	DATEBORN , 
	DATEJOINED , 
	DATELEFT , 
	OWNSPLANEREG , 
	STATUSSTUDENT , 
	STATUSPILOT  , 
	STATUSASCAT , 
	STATUSFULLCAT, 
	SEX , 
	CLUB,
  typeOfChange)
    (   
    select*,4 
        from taMember    
    where taMember.dateborn = CURDATE()) ;


commit
;
-- --------------------------------------------
-- post-extract report
-- --------------------------------------------

select 'Rows in extract table after, by operations type'
 from dual
;
select operation
     , count(*)
from ETLMembersExtract
 group by operation
 ;
 
 drop table TaMemberYesterday;
 create table TaMemberYesterday(
  "MEMBERNO" NUMBER(6,0) , 
	"INITIALS" CHAR(4 BYTE) , 
	"NAME" VARCHAR2(50 BYTE) , 
	"ADDRESS" VARCHAR2(50 BYTE) , 
	"ZIPCODE" NUMBER(4,0) , 
	"DATEBORN" DATE , 
	"DATEJOINED" DATE , 
	"DATELEFT" DATE, 
	"OWNSPLANEREG" CHAR(3 BYTE) , 
	"STATUSSTUDENT" CHAR(1 BYTE) , 
	"STATUSPILOT" CHAR(1 BYTE) , 
	"STATUSASCAT" CHAR(1 BYTE) , 
	"STATUSFULLCAT" CHAR(1 BYTE) , 
	"SEX" CHAR(1 BYTE) , 
	"CLUB" VARCHAR2(50 BYTE) 
);
 insert into TaMemberYesterday(
 MEMBERNO , 
	INITIALS , 
	NAME , 
	ADDRESS , 
	ZIPCODE  , 
	DATEBORN , 
	DATEJOINED , 
	DATELEFT , 
	OWNSPLANEREG , 
	STATUSSTUDENT , 
	STATUSPILOT  , 
	STATUSASCAT , 
	STATUSFULLCAT, 
	SEX , 
	CLUB)
 (select * from tamember);
 
 
exit;






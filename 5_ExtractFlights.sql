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
  Launchsafelaunch char(1 byte)
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
  Launchsafelaunch char(1 byte)
);


drop table Flight_Extract;
create table Flight_Extract(
  launchtime date,
  landingtime date,
  PlaneRegistration char(3 byte),
  Pilot1Init char(4 byte),
  Pilot2Init char(4 byte),
  cablebreak char(1 byte),
  crosscountrykm number(4,0),
  LaunchAerotow char(1 byte),
  Launchwinch char(1 byte),
  Launchsafelaunch char(1 byte),
  club number
);



select 'Extract Members at: ' || to_char(sysdate,'YYYY-MM-DD HH24:MI') as extractTime
  from dual
  ;

  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero)' || to_char(count(*))
   from Flight_Extract
union all
  select 'Rows in Members table ' || to_char(count(*))
   from TAFLIGHTSSG70
union all
  select 'Rows in Members table (yesterday copy) ' || to_char(count(*))
   from TAFLIGHTSSG70Yesterday
 ;

-- **** here goes the extract of added rows 
-- **** (i.e. rows from today whose primary key is in the set of (PKs from today minus PKs yesterday)
insert into Flight_Extract(
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
			from TAFLIGHTSSG70
			where id in
			(
			select ID
				from TAFLIGHTSSG70
			minus
				select ID
					from TAFLIGHTSSG70Yesterday
			));
			
insert into Flight_Extract(
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
    select *,2
			from TAFLIGHTSVEJLE
			where id in
			(
			select ID
				from TAFLIGHTSVEJLE
			minus
				select ID
					from TAFLIGHTSVEJLEYesterday
			));

commit
;

select 'Rows in extract table after, by operations type'
 from dual
;
select operation
     , count(*)
from Flight_Extract
 group by operation
 ;

exit;






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
  LAUNCHSELFLAUNCH char(1 byte),
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
    (
    select  
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
  1
  
			from TAFLIGHTSSG70
			where(
       LAUNCHTIME in
			(
			select LAUNCHTIME
				from TAFLIGHTSSG70
			minus
				select LAUNCHTIME
					from TAFLIGHTSSG70Yesterday
			)
      and
       pilot1init in
			(
			select pilot1init
				from TAFLIGHTSSG70
			minus
				select pilot1init
					from TAFLIGHTSSG70Yesterday
			)));
			
insert into Flight_Extract(
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
    (
    select  
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
  2
			from TAFLIGHTSVEJLE
			where(
       LAUNCHTIME in
			(
			select LAUNCHTIME
				from TAFLIGHTSVEJLE
			minus
				select LAUNCHTIME
					from TAFLIGHTSVEJLEYesterday
			)
      and
       pilot1init in
			(
			select pilot1init
				from TAFLIGHTSVEJLE
			minus
				select pilot1init
					from TAFLIGHTSVEJLEYesterday
			)));

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
 
 
 drop table TAFLIGHTSSG70Yesterday,TAFLIGHTSVEJLEYesterday;
 
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
  )

 
 insert into TAFLIGHTSSG70Yesterday (launchtime ,landingtime ,PlaneRegistration,Pilot1Init ,Pilot2Init ,cablebreak ,crosscountrykm ,LaunchAerotow ,Launchwinch ,Launchsafelaunch )
 select * from TAFLIGHTSSG70;
 
 insert into TAFLIGHTSVEJLEYesterday (launchtime ,landingtime ,PlaneRegistration,Pilot1Init ,Pilot2Init ,cablebreak ,crosscountrykm ,LaunchAerotow ,Launchwinch ,Launchsafelaunch)
 select * from TAFLIGHTSVEJLE;

exit;






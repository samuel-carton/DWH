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

select 'Extract Members at: ' || to_char(sysdate,'YYYY-MM-DD HH24:MI') as extractTime
  from dual 
  ;

  select 'Row counts before: '
    from dual
union all
  select 'Rows in extract table before (should be zero)' || to_char(count(*))
   from ETLMembersExtract
union all
  select 'Rows in Members table ' || to_char(count(*))
   from taMember
union all
  select 'Rows in Members table (yesterday copy) ' || to_char(count(*))
   from taMemberYesterday
 ;

-- **** here goes the extract of added rows 
-- **** (i.e. rows from today whose primary key is in the set of (PKs from today minus PKs yesterday)


-- **** here goes the extract of deleted rows 
-- **** (i.e. rows from yesterday whose primary key is in the set of (PKs from yesterday minus PKs today)

-- **** here goes the extract of changed rows 
-- **** (i.e. (rows from today minus rows from yesterday) - new rows )
	select (
	
		(select column_name          
			from dba_tab_cols
			where owner = 'DWH'
			and table_name = 'TAMEMBER' 
			; )
		-
		(select column_name
			from dba_tab_cols
			where owner = 'DWH'
			and table_name = 'D_MEMBER' 
			; )
		-
		(select * from MEMBER_new
			; )
	)
		
-- **** here goes the extract of Members whose age changed (i.e. those who have a birthday today) 
-- **** (i.e. (rows from today with dateBorn(DDMM) = current date(DDMM) - already extracted PKs)

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
 
exit;






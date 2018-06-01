CREATE TABLE d_date AS
 SELECT
   n AS Date_ID,
   TO_TIMESTAMP('31/12/1959 00:01','DD/MM/YYYY HH24:MI') + NUMTODSINTERVAL(n,'minute') AS Full_Date,
   TO_CHAR(TO_DATE('31/12/1959','DD/MM/YYYY') + NUMTODSINTERVAL(n,'minute'),'DD') AS Days,
   TO_CHAR(TO_DATE('31/12/1959','DD/MM/YYYY') + NUMTODSINTERVAL(n,'minute'),'Mon') AS Month_Short,
   TO_CHAR(TO_DATE('31/12/1959','DD/MM/YYYY') + NUMTODSINTERVAL(n,'minute'),'MM') AS Month_Num,
   TO_CHAR(TO_DATE('31/12/1959','DD/MM/YYYY') + NUMTODSINTERVAL(n,'minute'),'Month') AS Month_Long,
   TO_CHAR(TO_DATE('31/12/1959','DD/MM/YYYY') + NUMTODSINTERVAL(n,'minute'),'YYYY') AS Year,
   TO_CHAR(TO_DATE('31/12/1959','DD/MM/YYYY') + NUMTODSINTERVAL(n,'minute'),'HH24') AS Hour,
   TO_CHAR(TO_DATE('31/12/1959','DD/MM/YYYY') + NUMTODSINTERVAL(n,'minute'),'MI') AS Minute
   FROM (
   select level n
   from dual
   connect by level <= 52560000
   );
   
   DROP TABLE d_date;
   SELECT * FROM d_date;
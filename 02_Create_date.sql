DECLARE
  oneFineMinute interval DAY TO second := to_dsInterval ('000 00:01:00');
  firstDate DATE                       := to_date('31/12/1959 00:00:00','DD/MM/YYYY HH24:MI:SS');
BEGIN
  FOR i IN 1..52560000
  LOOP
    INSERT
    INTO d_date
      (
        FULLDATE
      )
      VALUES
      (
        firstDate
      );
    firstDate := firstDate + oneFineMinute;
  END LOOP;
END;
COMMIT;
/* fill the date dimension with all of the minutes that happended and that will happend between 1960 and 2060 */

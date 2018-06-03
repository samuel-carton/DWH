UPDATE Member --change valid_to date when we delete or change members
SET valid_to    = SYSDATE
WHERE MEMBERNO IN
  (SELECT MEMBERNO
  FROM Member_T2
  WHERE typeOfChange = 2
  OR typeOfChange    = 3
  OR typeOfChange    = 4 --or when there is a birthday
  );
INSERT --change valid_from date when we create or change members
INTO Member
  (
    memberno ,
    name ,
    zipcode ,
    dateborn ,
    datejoined ,
    dateleft ,
    statut ,
    age ,
    valid_to ,
    valid_from,
    club_id
  )
  (SELECT memberno,
      name,
      zipcode,
      dateborn,
      datejoined,
      dateleft,
      statut_member,
      age,
      '31/12/9999',
      SYSDATE,
      club_id
    FROM Member_T2
    WHERE MEMBERNO IN
      (SELECT MEMBERNO
      FROM Member_T2
      WHERE typeOfChange = 1
      OR typeOfChange    = 3
      OR typeOfChange    = 4 --or when there is a birthday
      )
  );


INSERT INTO Bridge
  (member1 ,member2
  ) /*--fill the bridge table with the pilots*/
SELECT Pilot1Init ,Pilot2Init FROM Flight_T2;
INSERT
INTO Flight
  ( --fill the flight table with the data from Flight_T2 and the group.id of the bridge table
    PlaneRegistration,
  --  groupid,
    Launchtime ,
    Landingtime ,
    CableBreak,
    CrossCountryKm,
    LaunchMethod,
    club_id
  )
SELECT PlaneRegistration,
 -- Bridge.id,
  Launchtime,
  Landingtime,
  cablebreak,
  crosscountrykm ,
  LAUNCHMETHOD,
  c_id
FROM Flight_T2/*,bridge*/; --we didn't find the corect way to make the bridge table work properly

/*
Select PlaneRegistration, Bridge.id, lau.id, lan.id, cablebreak, crosscountrykm , LAUNCHMETHOD,c_id from Flight_T2
join Bridge
on Bridge.member1 = Flight_T2.Pilot1Init and Bridge.member2 = Flight_T2.Pilot2Init
join D_date lau on lau.FULLDATE = Flight_T2.launchtime
join D_date lan on lan.FULLDATE = Flight_T2.landingtime
;*/
-- we tried to use id for launchtime and landingtime but we had to search for 1 line in our 52Million line Date table twice for every flight
-- the query was loading but we could never see the result
select * from flight;
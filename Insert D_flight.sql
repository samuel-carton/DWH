Insert into Bridge (member1 ,member2)
select Pilot1Init ,Pilot2Init from F_Flight2;

Insert into Flight (
	PlaneRegistration,
	groupid,
	Launchtime ,
	Landingtime ,
	CableBreak,
	CrossCountryKm,
	LaunchMethod,
	club_id )
Select PlaneRegistration, Bridge.id, lau.id, lan.id, cablebreak, crosscountrykm , LAUNCHMETHOD,c_id from F_Flight2
join Bridge 
on Bridge.member1 = F_Flight2.Pilot1Init and Bridge.member2 = F_Flight2.Pilot2Init
join D_date as lau on lau.FULLDATE = F_Flight2.launchtime
join D_date as lan on lan.FULLDATE = F_Flight2.landingtime
;

	
	
	
	



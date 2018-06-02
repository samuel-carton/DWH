Insert into Bridge (member1 ,member2)
select Pilot1Init ,Pilot2Init from F_Flight2

Insert into Flight (
	PlaneRegistration,
	groupid,
	Launchtime ,
	Landingtime ,
	CableBreak,
	CrossCountryKm,
	LaunchMethod,
	club_id )
Select Bridge.id, PlaneRegistration, launchtime, landingtime, cablebreak, crosscountrykm , LAUNCHMETHOD,c_id from F_Flight2
join Bridge 
on Bridge.member1 = F_Flight2.Pilot1Init and Bridge.member2 = F_Flight2.Pilot2Init
	
	
	
	



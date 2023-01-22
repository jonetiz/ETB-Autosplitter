//Now supporting 1.21 and 2.8, however 2.8 does not have level splitting.
//by Xero

state ("Backrooms-Win64-Shipping")
{
	bool version_check: 0x49B0868; // seems to be zero on v1.21 and big number on 2.8
}


state ("Backrooms-Win64-Shipping", "2.8")
{
	long level		: 0x49B0968; // 13194139536091 is always start, 13194139536054 is main menu, seems inconsistent for most other levels though
	//bool loading	: 0x49AD844; // loading == 1, seems consistent
	//byte loading2	: 0x04AE06C0, 0x30, 0x590, 0x3D8, 0x278, 0xD8, 0x618, 0x2ED; // 1 or 127 when loading; 81 in pause screen, 0 in regular gameplay
	//int  end		: 0x458C8A0; // end = 1019122; same for 1.2 @ 0x458C868 & 0x458C878 = 104?
}

state ("Backrooms-Win64-Shipping", "1.21")
{
	long level 	: 0x4A44C28;
	/* seems consistent
	main menu 			= 13194139535979
	level 0 			= 13194139536007
	habitable 			= 13194139535993
	pipes				= 13194139535989
	fun					= 13194139536001
	pool 				= 13194139535984
	run					= 13194139535996
	end					= 13194139535990
	9223372036854775807	= 13194139535986
	*/
	
	bool loading: 0x468B37C; // loading == 1
	int end		: 0x461B920; // 0x461B8E8 end = 79; other offsets: 0x461B8F8 = 79, 0x461B920 = 390156
}

startup
{
	settings.Add("multisplit", false, "Split on same area?");
	//settings.Add("coop", false, "Co-op? (v2.8 Only)");
	vars.enteredLevels = new List<long>() { 13194139535979, 13194139536007 };
	vars.validLevels_old = new List<long>() { 13194139536007, 13194139535993, 13194139535989, 13194139536001, 13194139535984, 13194139535996, 13194139535990, 13194139535986 };
}

init
{
	// Temporary, might not be consistent; if anything it will always default to latest version which is fine in theory
	if (current.version_check) {
		version = "2.8";
	} else {
		version = "1.21";
	}
}

start
{
	switch (version)
	{
		case "1.21":
			vars.enteredLevels = new List<long>() { 13194139535979, 13194139536007 };
			return (current.level == 13194139536007 && current.loading);
			break;
		
		case "2.8":
			return (current.level == 13194139536091);
			break;
		
		default:
			break;
	}
}

reset
{
	switch (version)
	{
		case "1.21":
			return current.level == 13194139535979;
			break;
		
		case "2.8":
			return current.level == 13194139536054;
			break;
		
		default:
			break;
	}
}

split
{
	switch (version)
	{
		case "1.21":
			if (current.level != old.level && vars.validLevels_old.Contains(current.level))
			{
				if (!vars.enteredLevels.Contains(current.level)) {
					print(current.level.ToString());
					vars.enteredLevels.Add(current.level);
					return true;
				} else {
					return settings["multisplit"];
				}
			}
			return (current.end == 390156 && current.level == 13194139535986);
			break;
			
		case "2.8":
			// 2.8 needs level splitting
			//return (current.end == 1019122);
			break;
			
		default:
			break;
	}
}

isLoading
{	
	// Load removal disabled while full RTA
	// version independent, will always be bool
	/*if (settings["coop"] && version == "2.8") {
		return (current.loading2 != 0 && current.loading2 != 81);
	} else {
		return current.loading;
	}*/
}

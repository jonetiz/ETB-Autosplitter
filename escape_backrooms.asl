//Deprecated v1.21 functionality. Added splitting working for current version, no load removal.
//by Xero

state ("Backrooms-Win64-Shipping")
{
	bool version_check: 0x49B0868; // seems to be zero on v1.21 and big number on 2.9
}


state ("Backrooms-Win64-Shipping", "2.9")
{
	long level		: 0x49B0968; // 13194139536091 is always start, 13194139536054 is main menu, seems inconsistent for most other levels though
	int  loading	: 0x4567994; // loading == 1, seems consistent
	int  rslcheck	: 0x4A489F0; // if it's > 1, we're almost certainly *not* restarting level, and want to split
	int  end		: 0x458C908; // end = 99
}

startup
{
	//settings.Add("multisplit", false, "Split on same area?");
	//settings.Add("coop", false, "Co-op? (v2.9 Only)");
	// vars.enteredLevels = new List<long>() { 13194139535979, 13194139536007 };
	// vars.validLevels_old = new List<long>() { 13194139536007, 13194139535993, 13194139535989, 13194139536001, 13194139535984, 13194139535996, 13194139535990, 13194139535986 };
}

init
{
	// Temporary, might not be consistent; if anything it will always default to latest version which is fine in theory
	// if (current.version_check) {
	// 	version = "2.9";
	// } else {
	// 	version = "1.21";
	// }
	version = "2.9";
	vars.loadingThreshold = 1;
	vars.loading = false;
}

start
{
	switch (version)
	{
		case "2.9":
			return (current.level == 13194139536091);
			break;
		
		default:
			break;
	}
}

/* Disabled for now because the game seems to cycle through the value when switching levels, kinda weird

reset 
{
	switch (version)
	{
		case "2.9":
			return (current.level == 13194139536054);
			break;
		
		default:
			break;
	}
}*/

split
{
	switch (version)
	{
		case "2.9":
			// split when loading, when the current level != old level, and when restart level check is == 65793
			return (current.loading % 2 != 0 && current.loading != old.loading && current.rslcheck == 65793);
			return (current.end == 99);
			break;
			
		default:
			break;
	}
}

isLoading
{	
	// Load removal disabled while full RTA

	// version independent, will always be bool
	/*if (settings["coop"] && version == "2.9") {
		return (current.loading2 != 0 && current.loading2 != 81);
	} else {
		return current.loading;
	}*/
}

//Added support for MP, 2.9 only confirmed working.
//by Xero

state ("Backrooms-Win64-Shipping", "2.9")
{
	bool mp   		: 0x45FA838; // detects co-op lobby. other candidates: 0x45FA834 != 0 | 0x45FA83C = 4; != 0 | 0x45FA840 = 1 != 2
	long level		: 0x49B0968; // 13194139536091 is always start, 13194139536054 is main menu, seems inconsistent for most other levels though
	int  loading	: 0x4567994; // loading == odd, seems consistent
	int  loading_mp : 0x04AF4E68, 0x0, 0x0, 0x30, 0x380, 0x10, 0xE0, 0x80, 0x2AF0, 0xC; // loading == 2 on first lobby, then 3.
	int  rslcheck	: 0x4A489F0; // if it's > 1, we're almost certainly *not* restarting level, and want to split (sp only)
	bool ingame		: 0x45624E4; // if true, player is ingame (not in main menu);
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
	version = "2.9";
	vars.loadingThreshold = 2;
	vars.loading = false;
}

update
{
	if (current.loading_mp == 3) {
		vars.loadingThreshold = 3; // handle lobbies after first having loading == 3
	}
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

reset 
{
	return (!current.ingame);
}

split
{
	switch (version)
	{
		case "2.9":
			if (current.mp) {
				return (current.loading_mp == vars.loadingThreshold && current.loading_mp != old.loading_mp);
			} else {
				// split when loading, when the current level != old level, and when restart level check is == 65793
				return (current.loading % 2 != 0 && current.loading != old.loading && current.rslcheck == 65793);
			}
			break;
			
		default:
			break;
	}
}

isLoading
{	
	if (current.mp) {
		return (current.loading_mp == vars.loadingThreshold);
	} else {
		return (current.loading % 2 != 0 && current.rslcheck == 65793);
	}
}

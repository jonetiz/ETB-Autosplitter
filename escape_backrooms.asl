//Added support for MP, 2.9 and 2.3 confirmed working.
//by Xero

state ("Backrooms-Win64-Shipping", "2.9")
{
	bool mp   		: 0x45FA838; // detects co-op lobby. other candidates: 0x45FA834 != 0 | 0x45FA83C = 4; != 0 | 0x45FA840 = 1 != 2
	long level		: 0x49B0968; // 13194139536091 is always start, 13194139536054 is main menu, seems inconsistent for most other levels though
	int  loading	: 0x4567994; // loading == odd, seems consistent
	int  loading_mp : 0x491E0E0, 0x68, 0x80, 0x2AF0, 0xC; // loading == 2 on first lobby, then 3.
	int  rslcheck	: 0x4A489F0; // if it's > 1, we're almost certainly *not* restarting level, and want to split (sp only)
}

state ("Backrooms-Win64-Shipping", "2.3")
{
	bool mp   		: 0x45FA6F8; // detects co-op lobby. other candidates: 0x45FA834 != 0 | 0x45FA83C = 4; != 0 | 0x45FA840 = 1 != 2
	long level		: 0x49B07E8; // 13194139536091 is always start, 13194139536054 is main menu, seems inconsistent for most other levels though
	int  loading_mp : 0x491FED0, 0x30, 0x48, 0x80, 0x2330, 0xC; // loading == 2 on first lobby, then 3.
	int  loading	: 0x49AD744; // loading == odd, seems consistent
}

startup
{
	settings.Add("23_addr", false, "Game Version 2.3 (Restart game to apply)");
}

init
{
	if (settings["23_addr"]) {
		version = "2.3";
	} else {
		version = "2.9";
	}
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
		case "2.3":
			return (current.level == 13194139536090);
			break;
		default:
			break;
	}
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
		case "2.3":
			if (current.mp) {
				return (current.loading_mp == vars.loadingThreshold && current.loading_mp != old.loading_mp);
			} else {
				return (current.loading % 2 != 0 && current.loading != old.loading);
			}
			break;
		default:
			break;
	}
}

isLoading
{	
	switch (version) {
		case "2.9":
			if (current.mp) {
				return (current.loading_mp == vars.loadingThreshold);
			} else {
				return (current.loading % 2 != 0 && current.rslcheck == 65793);
			}
		break;

		case "2.3":
			if (current.mp) {
				return (current.loading_mp == vars.loadingThreshold);
			} else {
				return (current.loading % 2 != 0);
			}
			break;

		default:
			break;
	}
}

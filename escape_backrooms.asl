//Only currently supports 13 August 2022 version of game.

//by Xero

/*state ("Backrooms-Win64-Shipping")
{
	long level	: 0x45FB234;
} for current version TODO */

state ("Backrooms-Win64-Shipping")
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
	
	long loading: 0x49B3D18; // loading == 4294967295 when loading seems to work
	int end		: 0x461B920; // 0x461B8E8 end = 79; other offsets: 0x461B8F8 = 79, 0x461B920 = 390156
}

startup
{
	settings.Add("multisplit", false, "Split on same area?");
	vars.enteredLevels = new List<long>() { 13194139535979, 13194139536007 };
	vars.validLevels = new List<long>() { 13194139536007, 13194139535993, 13194139535989, 13194139536001, 13194139535984, 13194139535996, 13194139535990, 13194139535986 };
}

start
{
	vars.enteredLevels = new List<long>() { 13194139535979, 13194139536007 };
	return (current.level == 13194139536007 && current.loading == 4294967295);
}

reset
{
	return current.level == 13194139535979;
}

split
{
	if (current.level != old.level && vars.validLevels.Contains(current.level))
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
}

isLoading
{
	return current.loading == 4294967295;
}

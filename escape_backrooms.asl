/*
==3.0+ Autosplitter==
	Authored by Permamiss & HeXaGoN
		isLoading1, wasLoading1 variables found by HeXaGoN
		isLoading2, wasLoading2, multiplayer variables found by Permamiss

	Shoutouts to Xero for consulting, and to Shad0w & for being our Fancy messenger!

==2.3/2.9 Autosplitter==
	Authored by Xero
		This should be considered a legacy product. Use at your own risk.

	
==Documentation Notes==

	Better and more general documentation for LiveSplit autosplitters can be found at https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md
	Timer code can be found at https://github.com/LiveSplit/LiveSplit/blob/master/LiveSplit/LiveSplit.Core/Model/TimerModel.cs

	"vars" is a persistent object that is able to contain persistent variables
	"old" contains the values of all the defined variables in the last update
	"current" contains the current values of all the defined variables
	"settings" is an object used to add or get settings
*/

state("Backrooms-Win64-Shipping", "3.0+")
{
	bool isLoading1		: 0x04C5F398, 0xD28, 0x320; // sets to true when starting to fade to black, false when loading screen finishes
	bool isLoading2		: 0x04C5F998, 0x8, 0x60, 0x320; // sets to true when starting to fade to black, false when loading screen finishes, backup
	bool wasLoading1	: 0x4C3CFED; // 0 when done loading, 0-2 (maybe higher?) when loading
	bool wasLoading2	: 0x4C3CFF0; // 0 when done loading, > 0 when loading, backup
	bool multiplayer	: 0x4760BE8; // set to true when in multiplayer is detected (including simply being in a multiplayer lobby)
}

state ("Backrooms-Win64-Shipping", "2.9")
{
	bool multiplayer	: 0x45FA838; // detects co-op lobby. other candidates: 0x45FA834 != 0 | 0x45FA83C = 4; != 0 | 0x45FA840 = 1 != 2
	long level			: 0x49B0968; // 13194139536091 is always start, 13194139536054 is main menu, seems inconsistent for most other levels though
	bool isLoading		: 0x49AD8C4; // 33 C0 0F 57 C0 F2 0F 11 05 and 89 43 60 8B 05
}

state ("Backrooms-Win64-Shipping", "2.3") // offset -180 from 2.9
{
	bool multiplayer	: 0x45FA6F8; // detects co-op lobby. other candidates: 0x45FA834 != 0 | 0x45FA83C = 4; != 0 | 0x45FA840 = 1 != 2
	long level			: 0x49B07E8; // 13194139536090 is always start, 13194139536054 is main menu, seems inconsistent for most other levels though
	bool isLoading		: 0x49AD744; // 33 C0 0F 57 C0 F2 0F 11 05 and 89 43 60 8B 05
}

//startup
//{
//	settings.Add("29_addr", false, "Game Version 2.9 (Restart game to apply)");
//	settings.Add("23_addr", false, "Game Version 2.3 (Restart game to apply)");
//}

init
{
	vars.inLobby = false;

	IntPtr loadStartPtr = game.MainModule.BaseAddress;
	IntPtr loadEndPtr = game.MainModule.BaseAddress;

	if (modules.First().ModuleMemorySize == 83517440) // ModuleMemorySize for 2.3 and 2.9
	{
		if (settings["23_addr"])
		{
			version = "2.3";

			loadStartPtr = game.MainModule.BaseAddress + 0x22719DE;
			loadEndPtr = game.MainModule.BaseAddress + 0x191F048;
		}
		else if (settings["29_addr"])
		{
			version = "2.9";
			
			loadStartPtr = game.MainModule.BaseAddress + 0x22722DE;
			loadEndPtr = game.MainModule.BaseAddress + 0x191F948;
		}
	}
	else if (modules.First().ModuleMemorySize == 85086208)
	{
		version = "3.0+";
		
		current.isLoading = current.isLoading1 || current.isLoading2;
		current.wasLoading = current.wasLoading1 || current.wasLoading2;
	}

	print("[EtB Autosplitter] DEBUG: Escape the Backrooms Autosplitter loaded");
	print("[EtB Autosplitter] DEBUG: Detected game version: " + (version == "" ? "Unknown version - heap size " + modules.First().ModuleMemorySize.ToString() + ", please contact the autosplitter authors for help!" : version));
	
	if (version == "2.3" || version == "2.9")
	{
		vars.isLoadingDetourPtr = game.AllocateMemory(72); // allocate 72 bytes for detour
	
		var isLoadingDetourBytes = new byte[]
		{
			0x4C, 0x8B, 0x0E,
			0x48, 0x63, 0xC1,
			0x4C, 0x6B, 0xC0, 0x70,
			0x41, 0x8D, 0x04, 0x2E,
			0x48, 0x63, 0xC8,
			0x48, 0x6B, 0xD1, 0x70,
			0x4B, 0x8D, 0x0C, 0x39,
			0x49, 0x03, 0xD1,
			0xC7, 0x05, 0x21, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 
			0xC3, // ret
			
			0xCC,
			
			0x49, 0x89, 0x5B, 0x10,
			0x41, 0x8B, 0xDC,
			0x49, 0x89, 0x7B, 0x20,
			0x4C, 0x89, 0x65, 0x97,
			0x4C, 0x89, 0x65, 0x9F, 
			0xC7, 0x05, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0xC3, // ret
			0xCC,
			0x00 // value read for load == 1
		};
	
		// bytes to detour load start function
		var loadStartDetourBytes = new List<byte>()
		{
			0xFF, 0x15, 0x02, 0x00, 0x00, 0x00, 0xEB, 0x08
		};
		loadStartDetourBytes.AddRange(BitConverter.GetBytes((ulong)vars.isLoadingDetourPtr));
		loadStartDetourBytes.AddRange(new byte[] {0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90});
	
		// bytes to detour load end function
		var loadEndDetourBytes = new List<byte>()
		{
			0xFF, 0x15, 0x02, 0x00, 0x00, 0x00, 0xEB, 0x08
		};
		loadEndDetourBytes.AddRange(BitConverter.GetBytes((ulong)vars.isLoadingDetourPtr+0x28));
		loadEndDetourBytes.AddRange(new byte[] {0x90, 0x90, 0x90});
	
		// suspend game while writing so it doesn't crash
		game.Suspend();
		try
		{
			// write the detour code at the allocated memory address
			game.WriteBytes((IntPtr)vars.isLoadingDetourPtr, isLoadingDetourBytes);
	
			// write detour calls
			game.WriteBytes(loadStartPtr, loadStartDetourBytes.ToArray());
			game.WriteBytes(loadEndPtr, loadEndDetourBytes.ToArray());
		}
		catch
		{
			vars.FreeMemory(game);
			throw;
		}
		finally
		{
			game.Resume();
		}
	}
}

update
{
	if (version == "2.3" || version == "2.9")
		current.loading_mp = game.ReadValue<bool>((IntPtr)vars.isLoadingDetourPtr + 0x47);
	else
	{
		current.isLoading = current.isLoading1 || current.isLoading2; // lazy fix for finding the right pointer, since 1 works for most, 2 works for others
		current.wasLoading = current.wasLoading1 || current.wasLoading2; // lazy fix for finding the right pointer, since 1 works for most, 2 works for others
	}
}

start
{
	switch (version)
	{
		case "2.9":
			return (current.level == 13194139536091 && (current.isLoading || current.loading_mp));
			break;
		case "2.3":
			return (current.level == 13194139536090 && (current.isLoading || current.loading_mp));
			break;
		case "3.0+":
			if (!current.wasLoading && old.wasLoading) // if we just finished loading, then (have to use this since there is no fade to black when starting from Main Menu)
			{
				if (current.multiplayer && !vars.inLobby) // prevent multiplayer lobby from starting timer
				{
					vars.inLobby = true;
					return false;
				}

				vars.inLobby = false; // if not in multiplayer OR we were in the lobby, then start the timer
				return true;
			}
			break;
		default:
			break;
	}
}

split
{
	if (version != "3.0+" && current.multiplayer)
		return (current.loading_mp && current.loading_mp != old.loading_mp);
	
	return current.isLoading && !old.isLoading;
}

isLoading
{
	if (version != "3.0+" && current.multiplayer)
		return (current.loading_mp);

	return current.isLoading;
}

shutdown 
{
	vars.inLobby = false;
}
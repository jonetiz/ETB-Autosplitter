/*
==4.0+ Autosplitter==
	Variables for 4.0+ found by Reokin, thanks to theframeburglar for teaching me how to do it!
	Restructured init
==3.13 (Christmas) Autosplitter==
==3.11 (Halloween) Autosplitter==
==3.10 Autosplitter==
	Authored by Permamiss & HeXaGoN
		3.0 - 3.9 variables updated to work with newer versions by theframeburglar

==3.0 - 3.9 Autosplitter==
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
state("Backrooms-Win64-Shipping", "4.0+")
{
	bool isLoading1		: 0x04C63B18, 0xD28, 0x330; // sets to true when starting to fade to black, false when loading screen finishes
	bool isLoading2		: 0x04C64118, 0x8, 0x60, 0x330; // sets to true when starting to fade to black, false when loading screen finishes, backup
	bool wasLoading1	: 0x4C4176D; // 0 when done loading, 0-2 (maybe higher?) when loading
	bool wasLoading2	: 0x4C41770; // 0 when done loading, > 0 when loading, backup
	bool multiplayer	: 0x4765228; // set to true when in multiplayer is detected (including simply being in a multiplayer lobby)
}
state("Backrooms-Win64-Shipping", "3.13 (Christmas)")
{
	bool isLoading1		: 0x04C605D8, 0xD28, 0x328; // sets to true when starting to fade to black, false when loading screen finishes
	bool isLoading2		: 0x04C60BD8, 0x8, 0x60, 0x328; // sets to true when starting to fade to black, false when loading screen finishes, backup
	bool wasLoading1	: 0x4C3E22D; // 0 when done loading, 0-2 (maybe higher?) when loading
	bool wasLoading2	: 0x4C3E230; // 0 when done loading, > 0 when loading, backup
	uint playerInLevel : 0x4C2CE28, 0x128, 0xF70; // non-zero when set
	bool multiplayer	: 0x4761D18; // set to true when in multiplayer is detected (including simply being in a multiplayer lobby)
}
state("Backrooms-Win64-Shipping", "3.11 (Halloween)")
{
	bool isLoading1		: 0x04C5F458, 0xD28, 0x328; // sets to true when starting to fade to black, false when loading screen finishes
	bool isLoading2		: 0x04C5FA58, 0x8, 0x60, 0x328; // sets to true when starting to fade to black, false when loading screen finishes, backup
	bool wasLoading1	: 0x4C3D0AD; // 0 when done loading, 0-2 (maybe higher?) when loading
	bool wasLoading2	: 0x4C3D0B0; // 0 when done loading, > 0 when loading, backup
	uint playerInLevel : 0x4C2BCA8, 0x128, 0xF70; // non-zero when set
	bool multiplayer	: 0x4760C78; // set to true when in multiplayer is detected (including simply being in a multiplayer lobby)
}
state("Backrooms-Win64-Shipping", "3.10")
{
	bool isLoading1		: 0x04C60558, 0xD28, 0x328; // sets to true when starting to fade to black, false when loading screen finishes
	bool isLoading2		: 0x04C60B58, 0x8, 0x60, 0x328; // sets to true when starting to fade to black, false when loading screen finishes, backup
	bool wasLoading1	: 0x4C3E1AD; // 0 when done loading, 0-2 (maybe higher?) when loading
	bool wasLoading2	: 0x4C3E1B0; // 0 when done loading, > 0 when loading, backup
	ulong playerInLevel : 0x4C1EE10, 0x8, 0x30, 0x80, 0x00, 0x00, 0x108; // non-zero when set
	bool multiplayer	: 0x4761C78; // set to true when in multiplayer is detected (including simply being in a multiplayer lobby)
}

state("Backrooms-Win64-Shipping", "3.0 - 3.9")
{
	bool isLoading1		: 0x04C5F398, 0xD28, 0x320; // sets to true when starting to fade to black, false when loading screen finishes
	bool isLoading2		: 0x04C5F998, 0x8, 0x60, 0x320; // sets to true when starting to fade to black, false when loading screen finishes, backup
	bool wasLoading1	: 0x4C3CFED; // 0 when done loading, 0-2 (maybe higher?) when loading
	bool wasLoading2	: 0x4C3CFF0; // 0 when done loading, > 0 when loading, backup
	uint playerInLevel : 0x4C2BBE8, 0x128, 0xF70; // non-zero when set
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

startup
{
	settings.Add("30_addr", false, "Game Version 3.0-3.13 (Restart game to apply)");
	settings.Add("29_addr", false, "Game Version 2.9 (Restart game to apply)");
	settings.Add("23_addr", false, "Game Version 2.3 (Restart game to apply)");
}

init
{
	vars.inLobby = false;
	vars.timerStarted = false;
	var scanner = new SignatureScanner(game, game.MainModule.BaseAddress, modules.First().ModuleMemorySize);
	
	IntPtr loadStartPtr = game.MainModule.BaseAddress;
	IntPtr loadEndPtr = game.MainModule.BaseAddress;

	if (settings["23_addr"])
	{
		if (modules.First().ModuleMemorySize == 83517440) // ModuleMemorySize for 2.3 and 2.9
		{
			version = "2.3";
			
			loadStartPtr = game.MainModule.BaseAddress + 0x22719DE;
			loadEndPtr = game.MainModule.BaseAddress + 0x191F048;
		}
	}
	else if (settings["29_addr"])
	{
		if (modules.First().ModuleMemorySize == 83517440) // ModuleMemorySize for 2.3 and 2.9
		{
			version = "2.9";

			loadStartPtr = game.MainModule.BaseAddress + 0x22722DE;
			loadEndPtr = game.MainModule.BaseAddress + 0x191F948;
		}
	}
	else if (settings["30_addr"])
	{
		if (modules.First().ModuleMemorySize == 85086208) // ModuleMemorySize for 3.0 - 3.9
		{
			// Versions "3.0 - 3.9" and "3.11 (Halloween)" share the same ModuleMemorySize but have different base address/offsets for their variables.
			// This is the array of bytes I use to capture "isLoading1" variable. 
			IntPtr ptr = scanner.Scan(new SigScanTarget(0, // target the 0th byte
			"48 83 3d ?? ?? ?? ?? 00", // cmp qword ptr ds:[target],0
			"74 52", // je rel
			"49 8b 8f c0 00 00 00", // mov rcx, qword ptr ds:[r15+0xc0]
			"41 0f ba ec 07", // bts r12d,0x7
			"48 85 c9", // test rcx, rcx
			"74 38", // je rel
			"48 8b 01", // mov rax,qword ptr ds:[rcx]
			"ff 10", // call rax
			"48 85 c0" // test rax, rax
			));
			if (ptr == IntPtr.Zero)
			{
				throw new Exception("Could not find isLoading1!");
			}
		
			ulong instrAddr = (ulong)ptr;
			ulong nextInstrAddr = (ulong)ptr + 8;
			ulong instrOperand = game.ReadValue<uint>((IntPtr)instrAddr + 3); // We only want 4 bytes in "48 8d 3d ?? ?? ?? ??"
			ulong isLoading1Base = (nextInstrAddr + instrOperand)  - (ulong)game.MainModule.BaseAddress;
			
			if(0x04C5F458 == isLoading1Base)
			{
				version = "3.11 (Halloween)";
			}
			else if(0x04C5F398 == isLoading1Base)
			{
				version = "3.0 - 3.9";
			}
			
			current.isLoading = current.isLoading1 || current.isLoading2;
			current.wasLoading = current.wasLoading1 || current.wasLoading2;
		}
		else if (modules.First().ModuleMemorySize == 85090304) // ModuleMemorySize for 3.10
		{
			// Versions "3.10" and "3.13 (Christmas)" share the same ModuleMemorySize but have different base address/offsets for their variables.
			// This is the array of bytes I use to capture "isLoading1" variable. 
			IntPtr ptr = scanner.Scan(new SigScanTarget(0, // target the 0th byte
			"48 83 3d ?? ?? ?? ?? 00", // cmp qword ptr ds:[target],0
			"74 52", // je rel
			"49 8b 8f c0 00 00 00", // mov rcx, qword ptr ds:[r15+0xc0]
			"41 0f ba ec 07", // bts r12d,0x7
			"48 85 c9", // test rcx, rcx
			"74 38", // je rel
			"48 8b 01", // mov rax,qword ptr ds:[rcx]
			"ff 10", // call rax
			"48 85 c0" // test rax, rax
			));
			if (ptr == IntPtr.Zero)
			{
				throw new Exception("Could not find isLoading1!");
			}
			
			ulong instrAddr = (ulong)ptr;
			ulong nextInstrAddr = (ulong)ptr + 8;
			ulong instrOperand = game.ReadValue<uint>((IntPtr)instrAddr + 3); // We only want 4 bytes in "48 8d 3d ?? ?? ?? ??"
			ulong isLoading1Base = (nextInstrAddr + instrOperand)  - (ulong)game.MainModule.BaseAddress;
			
			if(0x04C605D8 == isLoading1Base)
			{
				version = "3.13 (Christmas)";
			}
			else if(0x04C60558 == isLoading1Base)
			{
				version = "3.10";
			}
			
			current.isLoading = current.isLoading1 || current.isLoading2;
			current.wasLoading = current.wasLoading1 || current.wasLoading2;

			//version = "3.10";

			//current.isLoading = current.isLoading1 || current.isLoading2;
			//current.wasLoading = current.wasLoading1 || current.wasLoading2;
		}
	}
	else if (modules.First().ModuleMemorySize == 85102592)
	{
		version = "4.0+";
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
	
	else if (settings["30_addr"])
	{
		// For any non 2.3/2.9 version create a wasLoading3 variable so we can still capture when we start iffy levels like Poolrooms
		// ^ outdated, only active if 3.0-3.13 is selected
		
		// first hook
		IntPtr ptrWasLoading3Addr = scanner.Scan(new SigScanTarget(0, // target the 0th byte
		"24 FE", // and al, 0xFE
		"49 8D 8D ?? ?? ?? ??", // lea rcx, ds:[r13+????]
		"88 82 ?? ?? ?? ??", // mov byte ptr ds:[rdx+????], al
		"45 33 C0" // xor r8d, r8d
		));
		if (ptrWasLoading3Addr == IntPtr.Zero)
		{
			throw new Exception("Could not find wasLoading3 detour!");
		}
		
		// wasLoading3 == 0 means not loading
		// wasLoading3 == 1 means done loading
		vars.wasLoading3 = game.AllocateMemory(80); // allocate 80 bytes for detour, first two bytes are for my variable
		memory.WriteValue<byte>((IntPtr)vars.wasLoading3, 0); // Set wasLoading3 to 0 which is the default "not loading" state
		vars.wasLoading3Detour = vars.wasLoading3 + 2;

		var wasLoading3DetourBytes = new byte[]
		{
			0x66, 0xC7, 0x05, 0xF5, 0xFF, 0xFF, 0xFF, 0x01, 0x00,	// mov word ptr ds:[7FF78D6366BD],1 (set wasLoading3 to 1)
			// original instructions
			0x24, 0xFE, 											// and al, 0xFE
			0x49, 0x8D, 0x8D, 0xD0, 0x00, 0x00, 0x00, 				// lea rcx, ds:[r13+0xD0]
			0x88, 0x82, 0x0B, 0x01, 0x00, 0x00, 					// mov byte ptr ds:[rdx+0x10B], al
			0xC3													// ret
		};
		
		// bytes to detour load start function
		var wasLoading3HookBytes = new List<byte>()
		{
			0x53,														// push rbx
			0x48, 0xBB													// mov rax, jumploc
		};
		wasLoading3HookBytes.AddRange(BitConverter.GetBytes((ulong)vars.wasLoading3Detour));
		wasLoading3HookBytes.AddRange(new byte[] {
			0xFF, 0xD3,													// call rbx
			0x5B,														// pop rbx
			0x90														// nop
		});
		
		// suspend game while writing so it doesn't crash
		game.Suspend();
		try
		{
			// write the detour code at the allocated memory address
			game.WriteBytes((IntPtr)vars.wasLoading3Detour, wasLoading3DetourBytes);
			// write detour calls
			game.WriteBytes(ptrWasLoading3Addr, wasLoading3HookBytes.ToArray());
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
	{
		current.loading_mp = game.ReadValue<bool>((IntPtr)vars.isLoadingDetourPtr + 0x47);
	}
	else if (settings["30_addr"])
	{
		if(vars.timerStarted)
		{
			var wasLoading3 = memory.ReadValue<byte>((IntPtr)vars.wasLoading3);
			if(1 == wasLoading3)
			{
				memory.WriteValue<byte>((IntPtr)vars.wasLoading3, 0); // not loading
			}
		}
		current.isLoading = current.isLoading1 || current.isLoading2; // lazy fix for finding the right pointer, since 1 works for most, 2 works for others
		current.wasLoading = current.wasLoading1 || current.wasLoading2; // lazy fix for finding the right pointer, since 1 works for most, 2 works for others
	}
	else
	{
		current.isLoading = current.isLoading1 || current.isLoading2; // lazy fix for finding the right pointer, since 1 works for most, 2 works for others
		current.wasLoading = current.wasLoading1 || current.wasLoading2; // lazy fix for finding the right pointer, since 1 works for most, 2 works for others
	}
}

start
{
	vars.timerStarted = false;
	switch (version)
	{

		case "2.9":
			return (current.level == 13194139536091 && (current.isLoading || current.loading_mp));
			break;
		case "2.3":
			return (current.level == 13194139536090 && (current.isLoading || current.loading_mp));
			break;
		case "3.13 (Christmas)":
		case "3.11 (Halloween)":
		case "3.10":
		case "3.0 - 3.9":
			// wasLoading3 is only 1 when the game finishes the loading screen
			var wasLoading3 = memory.ReadValue<byte>((IntPtr)vars.wasLoading3);
			
			// if we just finished loading, then (have to use this since there is no fade to black when starting from Main Menu)
			
			// NOTE: wasLoading3 is set to 1 in our detour. For some reason the function that sets wasLoading1 and wasLoading2 to 0 does NOT
			// do so when it loads certain levels via save, so we create our own variable that works as expected
			if ((!current.wasLoading && old.wasLoading) || (wasLoading3 == 1 && current.playerInLevel == 1)) 
			{
				// Finished loading
				memory.WriteValue<byte>((IntPtr)vars.wasLoading3, 0); // not loading
				if (current.multiplayer && !vars.inLobby) // prevent multiplayer lobby from starting timer
				{
					vars.inLobby = true;
					return false;
				}
				
				vars.inLobby = false; // if not in multiplayer OR we were in the lobby, then start the timer
				vars.timerStarted = true;
				return true;
			}
			else if (wasLoading3 == 1)
			{
				memory.WriteValue<byte>((IntPtr)vars.wasLoading3, 0); // not loading
			}
			break;
		case "4.0+":
			if (!current.wasLoading && old.wasLoading) // have to use this since there is no fade to black when starting from Main Menu
			{
				if (current.multiplayer && !vars.inLobby)
				{
					vars.inLobby = true;
					return false;
				}

				vars.inLobby = false;
				vars.timerStarted = true;
				return true;
			}
			break;
		default:
			break;
	}
}

split
{
	if ((version == "2.3" || version == "2.9") && current.multiplayer)
		return (current.loading_mp && current.loading_mp != old.loading_mp);

	return current.isLoading && !old.isLoading;
}

isLoading
{
	if ((version == "2.3" || version == "2.9") && current.multiplayer)
		return (current.loading_mp);

	return current.isLoading;
}

shutdown 
{
	vars.inLobby = false;
}

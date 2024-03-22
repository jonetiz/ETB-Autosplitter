/*
==1.21 - 4.0+ Autosplitter==
	Reworked by theframeburglar
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

state("Backrooms-Win64-Shipping", "1.21 - 4.0+")
{

}

startup
{
	settings.Add("disable_restart_time_removal", false, "Disable pausing of autosplitter when restarting levels");
}

init
{
	game.Suspend();
	
	// Latent action UUIDs to check
	// Keep last one as 0 so we know when to stop
	// 1.0 - Mostly the same for 2.0 and 3.0
	// sp 00000000D4D1BDD5
	// mp 000000008FD0BC64
	// end game sp 0x0000000085969B25
	// 3.0
	// end game sp 000000004CBFBB29
	// 4.0
	// sp 000000002F9930F6
	// mp 000000008E2A5E5E
	// end game sp 0000000080D6D177
	var UUIDs = new ulong[] {0x0000000085969B25, 0x00000000D4D1BDD5, 0x000000008FD0BC64, 0x000000004CBFBB29, 0x000000002F9930F6, 0x000000008E2A5E5E, 0x0000000080D6D177, 0};

	vars.arrUUIDs = game.AllocateMemory(8 * UUIDs.Length);
	
	for (int i = 0; i < UUIDs.Length; i++)
	{
		memory.WriteValue<ulong>((IntPtr)vars.arrUUIDs + (i * 8), UUIDs[i]);
	}
	
	vars.watchers = new MemoryWatcherList();
	var scanner = new SignatureScanner(game, game.MainModule.BaseAddress, modules.First().ModuleMemorySize);

	// RestartGame hook
	IntPtr ptrIsRestartingAddr = scanner.Scan(new SigScanTarget(0, // target the 0th byte
	"48 8B F9", // mov rdi, rcx
	"48 8B 89 78 02 00 00" // mov rcx, qword ptr ds:[rcx+0x278]

	));
	if (ptrIsRestartingAddr == IntPtr.Zero)
	{
		throw new Exception("Could not find isRestarting detour!");
	}
	
	// If the scan was successful then we probably have a good version
	
	version = "1.21 - 4.0+";
		
	// isRestarting == 1 means restarting
	// isRestarting == 0 means not restarting
	
	vars.isRestarting = game.AllocateMemory(80); // allocate 80 bytes for detour, first two bytes are for variable
	memory.WriteValue<byte>((IntPtr)vars.isRestarting, 0); // Set isRestarting to 0 which is the default "not restarting" state
	vars.isRestartingDetour = vars.isRestarting + 2; // skip over the first two bytes
	vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer((IntPtr)vars.isRestarting)){ Name = "isRestarting" });
	
	var isRestartingDetourBytes = new byte[]
	{
		0x66, 0xC7, 0x05, 0xF5, 0xFF, 0xFF, 0xFF, 0x01, 0x00,	// mov word ptr ds:[7FF78D6366BD],1 (set isRestarting to 1)
		// original instructions
		0x48, 0x8B, 0xF9, // mov rdi, rcx
		0x48, 0x8B, 0x89, 0x78, 0x02, 0x00, 0x00, // mov rcx, qword ptr ds:[rcx+0x278]
		0x48, 0x8b, 0x01, //mov rax, qword ptr ds:[rcx]
		0xC3 // ret
	};
	
	// bytes to detour load start function
	var isRestartingHookBytes = new List<byte>()
	{
		0x48, 0xBF													// mov rdi, jumploc
	};
	isRestartingHookBytes.AddRange(BitConverter.GetBytes((ulong)vars.isRestartingDetour));
	isRestartingHookBytes.AddRange(new byte[] {
		0xFF, 0xD7,													// call rdi 													
		0x90
	});

	print("[EtB Autosplitter] DEBUG: Escape the Backrooms Autosplitter loaded");
	print("[EtB Autosplitter] DEBUG: Detected game version: " + (version == "" ? "Unknown version - heap size " + modules.First().ModuleMemorySize.ToString() + ", please contact the autosplitter authors for help!" : version));
	
	// Load level hook -- isLoadingLevel which tells us if the game is loading a level and which map we're coming from
	IntPtr ptrisLoadingLevelAddr = scanner.Scan(new SigScanTarget(0, // target the 0th bytes
	"45 33 C9", // xor r9d, r9d
	"48 8B D7", // mov rdx, rdi
	"49 8B CC", // mov rcx, r12
	"FF 93 70 04 00 00", // call qword ptr ds:[rbx+470] - assume 470 for all versions but it could change
	"84 C0", // test al, al
	"49 8B CE", // mov rcx, r14
	"40 0F 94 C6" // sete sil
	));
	
	if (ptrisLoadingLevelAddr == IntPtr.Zero)
	{
		throw new Exception("Could not find isLoadingLevel detour!");
	}

	// isLoadingLevel == 1 means loading (before fade to black)
	// isLoadingLevel == 0 means not loading (after spinning loading screen)
	
	vars.isLoadingLevel = game.AllocateMemory(80); // allocate 80 bytes for detour, first two bytes are for my variable
	memory.WriteValue<byte>((IntPtr)vars.isLoadingLevel, 0); // Set isLoadingLevel to 0 which is the default "not loading" state
	memory.WriteValue<ulong>((IntPtr)vars.isLoadingLevel + 2, 0x006E00690061004D); // first 4 letters of "MainMenuMap"
	memory.WriteValue<ulong>((IntPtr)vars.isLoadingLevel + 10, 0x00620062006f004c); // first 4 letters of "Lobby"
	vars.isLoadingLevelDetour = vars.isLoadingLevel + 2 + 16; // skip over the first two bytes plus 16 to account for our map strings		
	vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer((IntPtr)vars.isLoadingLevel)){ Name = "isLoadingLevel" });
	
	var isLoadingLevelDetourBytes = new byte[]
	{
		// Check to see what map we are loading
		0x50, // push rax
		0x53, // push rbx
		0x49, 0x8B, 0x46, 0x28, // mov rax, qword ptr ds:[r14+0x28]
		0x48, 0x83, 0xC0, 0x16, // add rax, 0x16
		0x48, 0x8B, 0x00, // mov rax, qword ptr ds:[rax]
		0x48, 0x8B, 0x1D, 0xDC, 0xFF, 0xFF, 0xFF, // mov rbx, [string1]
		0x48, 0x39, 0xC3, // cmp rbx,rax
		0x74, 0x15, // je orig
		0x48, 0x8B, 0x1D, 0xD8, 0xFF, 0xFF, 0xFF, // mov rbx, [string2]
		0x48, 0x39, 0xC3, // cmp rbx,rax
		0x74, 0x09, // je orig

		0x66, 0xC7, 0x05, 0xC0, 0xFF, 0xFF, 0xFF, 0x01, 0x00,	// mov word ptr ds:[7FF78D6366BD],1 (set isLoadingLevel to 1)
		// original instructions
		0x5b, // pop rbx
		0x58, // pop rax
		0x45, 0x33, 0xC9, // xor r9d, r9d
		0x48, 0x8B, 0xD7, // mov rdx, rdi
		0x49, 0x8B, 0xCC, // mov rcx, r12
		0x41, 0x5c,
		0x5F,
		0xFF, 0x93, 0x70, 0x04, 0x00, 0x00, // call qword ptr ds:[rbx+470] - assume 470 for all versions but it could change with a different engine
		0x57,
		0x41, 0x54,
		0x66, 0xC7, 0x05, 0xA0, 0xFF, 0xFF, 0xFF, 0x00, 0x00,	// mov word ptr ds:[7FF78D6366BD],1 (set isLoadingLevel to 0)
		0x84, 0xC0, // test al, al
		0x49, 0x8B, 0xCE, // mov rcx, r14
		0x40, 0x0F, 0x94, 0xC6, // sete sil
		0xC3 // ret
	};
	
	// bytes to detour load start function
	var isLoadingLevelHookBytes = new List<byte>()
	{
		0x50,														// push rax
		0x48, 0xB8													// mov rax, jumploc
	};
	isLoadingLevelHookBytes.AddRange(BitConverter.GetBytes((ulong)vars.isLoadingLevelDetour));
	isLoadingLevelHookBytes.AddRange(new byte[] {
		0xFF, 0xD0,													// call rax			
		0x58,														// pop rax
		0x90, 0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90
	});

	// Place hook on FLatentActionManager::AddNewAction	 
	IntPtr ptrIsExitingZoneAddr = scanner.Scan(new SigScanTarget(0, // target the 0th bytes
	"48 83 EC 40",// sub rsp, 0x40
	"48 8B D9", // mov rbx, rcx
	"48 8B EA", // mov rbp, rdx
	"48 8D 4C 24 20" // lea rcx, ss:[rsp+0x20]
	));
	
	if (ptrIsExitingZoneAddr == IntPtr.Zero)
	{
		throw new Exception("Could not find ptrIsExitingZoneAddr detour!");
	}

	// isExitingZone == 1 means exiting zone
	// isExitingZone == 0 means not exiting zone
	
	vars.isExitingZone = game.AllocateMemory(80); // allocate 80 bytes for detour, first two bytes are for variable
	memory.WriteValue<byte>((IntPtr)vars.isExitingZone, 0); // Set isExitingZone to 0 which is the default "not exiting" state
	memory.WriteValue<ulong>((IntPtr)vars.isExitingZone + 2, (ulong)vars.arrUUIDs); // Set isExitingZone to 0 which is the default "not exiting" state
	vars.isExitingZoneDetour = vars.isExitingZone + 2 + 8; // skip over the first 2 bytes plus 8 for our array address
	vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer((IntPtr)vars.isExitingZone)){ Name = "isExitingZone" });
	var isExitingZoneDetourBytes = new byte[]
	{
		0x53,//push rbx
		0x50,//push rax
		0x48, 0x31, 0xc0,// xor rax, rax
		0x48, 0x8b, 0x1d, 0xEC, 0xFF, 0xFF, 0xFF,//mov rbx, array
		// loop
		0x48, 0x8b, 0x3c, 0x03,// mov rdi, [rbx + rax]
		0x48, 0x83, 0xff, 0x00,// cmp rdi, 0
		0x74, 0x14,// je end
		0x4c, 0x39, 0xc7,// cmp rdi, r8
		0x74, 0x06,//je set
		0x48, 0x83, 0xc0, 0x08,// add rax,8
		0xeb, 0xeb,//jmp loop
		0x66, 0xC7, 0x05, 0xCC, 0xFF, 0xFF, 0xFF, 0x01, 0x00,	// mov word ptr ds:[7FF78D6366BD],1 (set isExitingZone to 1)
		0x58, //pop rax
		0x5b, //pop rbx
		// original instructions
		0x58, //pop rax
		0x48, 0x83, 0xEC, 0x40,// sub rsp, 0x40
		0x48, 0x8B, 0xD9, // mov rbx, rcx
		0x48, 0x8B, 0xEA, // mov rbp, rdx
		0x48, 0x8D, 0x4C, 0x24, 0x20, // lea rcx, ss:[rsp+0x20]
		0x50,//push rax
		0xC3 // ret
	};
	
	// bytes to detour load start function
	var isExitingZoneHookBytes = new List<byte>()
	{
		//0x57,														// push rdi
		0x48, 0xB8													// mov rax, jumploc
	};
	isExitingZoneHookBytes.AddRange(BitConverter.GetBytes((ulong)vars.isExitingZoneDetour));
	isExitingZoneHookBytes.AddRange(new byte[] {
		0xFF, 0xD0,													// call rdi 
		//0x5F,														// pop rdi														
		0x90, 0x90, 0x90
	});
	
	// suspend game while writing so it doesn't crash
	
	try
	{
		// write the detour code at the allocated memory address
		game.WriteBytes((IntPtr)vars.isLoadingLevelDetour, isLoadingLevelDetourBytes);
		game.WriteBytes((IntPtr)vars.isExitingZoneDetour, isExitingZoneDetourBytes);
		game.WriteBytes((IntPtr)vars.isRestartingDetour, isRestartingDetourBytes);
		// write detour calls
		game.WriteBytes(ptrisLoadingLevelAddr, isLoadingLevelHookBytes.ToArray());
		game.WriteBytes(ptrIsExitingZoneAddr, isExitingZoneHookBytes.ToArray());
		game.WriteBytes(ptrIsRestartingAddr, isRestartingHookBytes.ToArray());
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

	// Get isSeamlessTravel (UWorld::Tick variable)
	IntPtr ptrIsSeamlessTravel = scanner.Scan(new SigScanTarget(0, // target the 0th byte
	"48 83 EC 28", // sub rsp, 0x28
	"48 8B D1", // mov rdx, rcx
	"48 8B 0D ?? ?? ?? ??", // mov rcx, qword ptr ds:[0x????]
	"E8 ?? ?? ?? ??", // call ??
	"0F B6 80 90 00 00 00" // movzx eax, byte ptr ds:[rax+0x90]
	));
	if (ptrIsSeamlessTravel == IntPtr.Zero)
	{
		throw new Exception("Could not find ptrIsSeamlessTravel!");
	}
	
	ulong instrAddrRst = (ulong)ptrIsSeamlessTravel;
	ulong nextInstrAddrRst = (ulong)ptrIsSeamlessTravel + 14; // mov is referenced from the instruction after the mov
	ulong instrOperandRst = game.ReadValue<uint>((IntPtr)instrAddrRst + 10); // We only want 4 bytes in "48 8d 3d ?? ?? ?? ??"
	ulong isSeamlessTravelBase = (nextInstrAddrRst + instrOperandRst)  - (ulong)game.MainModule.BaseAddress;
	ulong readAddr = (ulong)game.MainModule.BaseAddress + isSeamlessTravelBase;
	vars.watchers.Add(new MemoryWatcher<bool>(new DeepPointer((IntPtr)readAddr,0xc38,0x0, 0x98)){ Name = "isSeamlessTravel" });	
}

update
{
	vars.watchers.UpdateAll(game);
	
	var isLoadingLevel = !vars.watchers["isLoadingLevel"].Current && vars.watchers["isLoadingLevel"].Old;
	var isSeamlessTravel = !vars.watchers["isSeamlessTravel"].Current && vars.watchers["isSeamlessTravel"].Old;

	if(isLoadingLevel || isSeamlessTravel)
	{
		// Finished loading or restarting
		memory.WriteValue<byte>((IntPtr)vars.isExitingZone, 0); // Set isExitingZone to 0
		memory.WriteValue<byte>((IntPtr)vars.isRestarting, 0); // Set isRestarting to 0
	}
}

start
{
	var isLoadingLevel = !vars.watchers["isLoadingLevel"].Current && vars.watchers["isLoadingLevel"].Old;
	var isSeamlessTravel = !vars.watchers["isSeamlessTravel"].Current && vars.watchers["isSeamlessTravel"].Old;
	
	return isLoadingLevel || isSeamlessTravel;
}

split
{
	var isExitingZone = vars.watchers["isExitingZone"].Current && !vars.watchers["isExitingZone"].Old;
	return isExitingZone;
}

isLoading
{	
	if(vars.watchers["isRestarting"].Current && settings["disable_restart_time_removal"])
	{
		return false;
	}
	return vars.watchers["isLoadingLevel"].Current || vars.watchers["isSeamlessTravel"].Current || vars.watchers["isExitingZone"].Current;
}

shutdown 
{
}

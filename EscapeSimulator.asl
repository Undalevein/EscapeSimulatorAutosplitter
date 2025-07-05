/*
    Code inspiration from CaptainRektbeard's Viewfinder Autosplitter and mauer01's 5D Chess with
    Multiverse Time Travel Autosplitter, and hatkirby's Lingo 2 Autosplitter (thank for helping me
    on making a log filing system).

    Continuation of Jonc4's TAS that was worked since the Steampunk Update. Credit to them 
    for getting some of the work done on this autosplitter that I have continued.

    Author: Undalevein
    Last worked: July 5, 2025.
*/

state("Escape Simulator") 
{
    float roomTimer : "UnityPlayer.dll", 0x01CB9700, 0x0, 0x58, 0x28, 0x2E8, 0x38, 0x20, 0x14F8;
    int playerState : "mono-2.0-bdwgc.dll", 0x00774358, 0x280, 0xCF0, 0x70, 0x200, 0x120, 0xE0, 0xF28, 0x3C;
    int gameOverlay : "gameoverlayrenderer64.dll", 0x00153B24;

    // Pointer below checks if player is active or not. Celebration and inspecting are always 3. Maybe has some use in other versions?
    //byte playerState1 : "UnityPlayer.dll", 0x01D23C50, 0x2B0, 0x10, 0x10, 0x238, 0x18, 0x10, 0x10, 0x160, 0xEA8;
}

startup
{
    // Relative to Livesplit.exe (thank you hatkirby)
    vars.logFilePath = Directory.GetCurrentDirectory() + "\\autosplitter_escapesimulator.log";
    vars.log = (Action<string>)((string logLine) => {
        string time = System.DateTime.Now.ToString("dd/MM/yy hh:mm:ss.fff");
        print("[Escape Simulator ASL] " + logLine);
        // AppendAllText will create the file if it doesn't exist.
        System.IO.File.AppendAllText(vars.logFilePath, "[" + time + "] - " + logLine + "\r\n");
    });

    var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
    var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
    vars.Helper = Activator.CreateInstance(type, timer, this);
    vars.Helper.LoadSceneManager = true;

    settings.Add("last_pack_split", false, "Split when you complete the last level in the pack.");
    settings.Add("level_completion_split", true, "Split when completing any level.");
    settings.Add("tutorial_start", false, "Full Game Runs: Start timings with the Tutorial level.");
    settings.Add("first_chamber_start", false, "First # Runs: Start timings with The First Chamber level.");
    settings.Add("il_mode", false, "Individual Level Runs: timer starts in opening first level, ends at last. Resets when entering menu.");

    vars.MenuName = "MenuPC";

    List<string> IndividualLevelStart = new List<string>();
    IndividualLevelStart.Add("Toy1");               // Tutorial (first part)
    IndividualLevelStart.Add("Adventure1");         // First Chamber
    IndividualLevelStart.Add("Space1");             // Emergency Awakening
    IndividualLevelStart.Add("Victorian1");         // Brain Checkup
    IndividualLevelStart.Add("Corporation1");       // The Lobby
    IndividualLevelStart.Add("Holiday1");           // Santa's Workshop
    IndividualLevelStart.Add("Holiday2");           // Graveyard
    IndividualLevelStart.Add("Holiday3");           // Cats in Time
    IndividualLevelStart.Add("Holiday4");           // 70's Room
    IndividualLevelStart.Add("Holiday5");           // Leonardo's Workshop
    IndividualLevelStart.Add("Holiday6");           // Treasure Island
    IndividualLevelStart.Add("Holiday7");           // Detective's Office
    IndividualLevelStart.Add("Race1");              // Versus Apprentice
    IndividualLevelStart.Add("Mayan1");             // Jaguar's Gate
    IndividualLevelStart.Add("Magic1");             // Magic Shop
    IndividualLevelStart.Add("Western1");           // The Jail
    IndividualLevelStart.Add("Dieselpunk1");        // The Crew Quarters
    IndividualLevelStart.Add("Portal1");            // Portal Escape Chamber
    IndividualLevelStart.Add("AmongUs1");           // Among Us DLC
    IndividualLevelStart.Add("PowerWash1");         // PowerWash DLC
    IndividualLevelStart.Add("Talos1");             // The Talos Principle DLC
    vars.IndividualLevelStart = IndividualLevelStart;

    List<string> IndividualLevelTerminate = new List<string>();
    IndividualLevelTerminate.Add("Toy2");           // Tutorial (second part)
    IndividualLevelTerminate.Add("Adventure5");     // The Top
    IndividualLevelTerminate.Add("Space5");         // Space Walk
    IndividualLevelTerminate.Add("Victorian5");     // The Underground Lab
    IndividualLevelTerminate.Add("Corporation5");   // Metaverse
    IndividualLevelTerminate.Add("Holiday1");       // Santa's Workshop
    IndividualLevelTerminate.Add("Holiday2");       // Graveyard
    IndividualLevelTerminate.Add("Holiday3");       // Cats in Time
    IndividualLevelTerminate.Add("Holiday4");       // 70's Room
    IndividualLevelTerminate.Add("Holiday5");       // Leonardo's Workshop
    IndividualLevelTerminate.Add("Holiday6");       // Treasure Island
    IndividualLevelTerminate.Add("Holiday7");       // Detective's Office
    IndividualLevelTerminate.Add("Race2");          // Versus Expert
    IndividualLevelTerminate.Add("Mayan4");         // Monkey Temple
    IndividualLevelTerminate.Add("Magic4");         // Divination Towers
    IndividualLevelTerminate.Add("Western4");       // The Train
    IndividualLevelTerminate.Add("Dieselpunk4");    // The Helm Room
    IndividualLevelTerminate.Add("Portal1");        // Portal Escape Chamber
    IndividualLevelTerminate.Add("AmongUs1");       // Among Us DLC
    IndividualLevelTerminate.Add("PowerWash1");     // PowerWash DLC
    IndividualLevelTerminate.Add("Talos1");         // The Talos Principle DLC
    vars.IndividualLevelTerminate = IndividualLevelTerminate;

    List<string> NonSplitableScenes = new List<string>();
    NonSplitableScenes.Add(vars.MenuName);          // Main Menu
    NonSplitableScenes.Add("Empty");                // Loading Scene
    NonSplitableScenes.Add(null);                   // Loading Transition
    NonSplitableScenes.Add("Toy1");                 // Tutorial (first part)
    vars.NonSplitableScenes = NonSplitableScenes;

    vars.isLoading = false;
    vars.hasSplit = false;
    vars.canLogLoading = true;
    vars.split = false;
}

init
{
    vars.Helper.Load();
    old.SceneId = -2;
    old.SceneName = "null";
    old.roomTimer = -1.0f;
    old.playerState = 0;
}

update
{
    if (!vars.Helper.Update())
        return false;

    // Level ids are inconsistent between versions, but still used to
    // check if the index is different for efficiency.
    current.SceneId = vars.Helper.Scenes.Active.Index;
    // Level names is used for logging and accurate comparaisons.
    current.SceneName = vars.Helper.Scenes.Active.Name;

    // Check if scene is in a loading screen. Resume if the player has control.
    if (current.SceneName == "Empty" || current.SceneName == null)
    {
        vars.isLoading = true;
    }
    else if (old.gameOverlay == 256 && current.gameOverlay == 0)
    {
        vars.isLoading = false;
    }

    // When changing scenes, reset the split latch.
    if (old.SceneId != current.SceneId)
    {
        vars.hasSplit = false;
        vars.log("Entered scene " + current.SceneName);
    }

    // Log changes in player state.
    if (old.playerState != current.playerState)
    {
        vars.log("Current player state: " + current.playerState + " " + current.gameOverlay);
    }

    // Split when you finish a level that is not Toy1, the menu, or loading screens.
    if (!vars.NonSplitableScenes.Contains(current.SceneName) && 
        !vars.hasSplit && 
        (current.playerState == 1112570761 || current.playerState == 1121216102))       // These are the numbers that indicate room completion.
    {
        vars.split = settings["level_completion_split"] || 
                     settings["last_pack_split"] && vars.IndividualLevelTerminate.Contains(current.SceneName);
        vars.hasSplit = true;
    }   
    else
    {
        vars.split = false;
    }
}

start
{
    /*
        We start the timer depending on the player settings.
            - If the player is playing in IL Mode, then start when the player
              has control on any of the first levels of a pack.
            - If the player is playing in Full Game Mode, then start once the
              player has control in Tutorial (the first section).
    */
    if (old.SceneId != current.SceneId && 
        (settings["il_mode"] && vars.IndividualLevelStart.Contains(current.SceneName) ||
         settings["tutorial_start"] && current.SceneName == "Toy1" ||
         settings["first_chamber_start"] && current.SceneName == "Adventure1"))
    {
        vars.log("Timer started in " + current.SceneName);
        return true;
    }
}

reset
{
    /*
        We reset the timer if the player is playing in IL Mode. If so then we reset if the player
        resets the first room of the pack OR they return to the menu at any time.
    */
    if (settings["il_mode"] && current.SceneName == vars.MenuName && old.SceneId != current.SceneId)
    {
        vars.log("Timer restarted in " + current.SceneName);
        return true;
    }
}

split
{
    // We split the timer whenever the player completes a level (when the player celebrates)
    if (vars.split) 
    {
        vars.log("Split occured in " + current.SceneName);
        return true;
    }
}

isLoading
{
    // Loading times happen when the player is transitioning between different scenes.
    // Resumes if the scene is rendered.
    if (vars.isLoading && vars.canLogLoading) 
    {
        vars.log("Level is loading, timer paused.");
        vars.canLogLoading = false;
    }
    else if (!vars.isLoading)
    {
        if (!vars.canLogLoading)
            vars.log("Level has finished loading, timer resumed.");
        vars.canLogLoading = true;
    }
    return vars.isLoading;
}

exit
{
    vars.Helper.Dispose();
}

shutdown
{
    vars.Helper.Dispose();
}
/*
    Code inspiration from CaptainRektbeard's Viewfinder Autosplitter and mauer01's 5D Chess with
    Multiverse Time Travel Autosplitter.

    Continuation of Jonc4's TAS that was worked since the Steampunk Update. Credit to them 
    for getting some of the work done on this autosplitter that I have continued.

    Author: Undalevein
    Last worked: July 2, 2025.
*/

state("Escape Simulator") 
{
    float roomTimer : "UnityPlayer.dll", 0x01CB9700, 0x0, 0x58, 0x28, 0x2E8, 0x38, 0x20, 0x14F8;
    int playerPose : "UnityPlayer.dll", 0x01C412C0, 0x368, 0x50, 0x8, 0x8, 0x8, 0x170, 0x18;
}

startup
{
    var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
    var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
    vars.Helper = Activator.CreateInstance(type, timer, this);
    vars.Helper.LoadSceneManager = true;

    settings.Add("last_pack_split", false, "Split at the moment when you complete the last level in the pack.");
    settings.Add("level_completion_split", true, "Split when completing a level.");
    settings.Add("tutorial_start", false, "Full Game Runs: Start timings with the Tutorial level.");
    settings.Add("first_chamber_start", false, "First # Runs: Start timings with The First Chamber level.");
    settings.Add("il_mode", false, "Individual Level Runs: timer starts in opening first level, ends at last.");

    vars.MenuName = "MenuPC";

    List<string> LevelSplits = new List<string>();
    LevelSplits.Add("Toy2");            // Tutorial (Level Ends in Toy2)
    LevelSplits.Add("Adventure1");      // Labyrinth of Egypt
    LevelSplits.Add("Adventure2");
    LevelSplits.Add("Adventure3");
    LevelSplits.Add("Adventure4");
    LevelSplits.Add("Adventure5");
    LevelSplits.Add("Space1");          // Lost in Space
    LevelSplits.Add("Space2");
    LevelSplits.Add("Space3");
    LevelSplits.Add("Space4");
    LevelSplits.Add("Space5");
    LevelSplits.Add("Victorian1");      // Edgewood Mansion
    LevelSplits.Add("Victorian2");
    LevelSplits.Add("Victorian3");
    LevelSplits.Add("Victorian4");
    LevelSplits.Add("Victorian5");
    LevelSplits.Add("Corporation1");    // Omega Corporation
    LevelSplits.Add("Corporation2");
    LevelSplits.Add("Corporation3");
    LevelSplits.Add("Corporation4");
    LevelSplits.Add("Corporation5");
    LevelSplits.Add("Holiday1");        // Santa's Workshop
    LevelSplits.Add("Holiday2");        // Graveyard
    LevelSplits.Add("Holiday3");        // Cats in Time
    LevelSplits.Add("Holiday4");        // 70's Room
    LevelSplits.Add("Holiday5");        // Leonardo's Workshop
    LevelSplits.Add("Holiday6");        // Treasure Island
    LevelSplits.Add("Holiday7");        // Detective's Office
    LevelSplits.Add("Race1");           // Versus
    LevelSplits.Add("Race2");
    LevelSplits.Add("Mayan1");          // Mayan DLC
    LevelSplits.Add("Mayan2");
    LevelSplits.Add("Mayan3");
    LevelSplits.Add("Mayan4");
    LevelSplits.Add("Magic1");          // Magic DLC
    LevelSplits.Add("Magic2");
    LevelSplits.Add("Magic3");
    LevelSplits.Add("Magic4");
    LevelSplits.Add("Western1");        // Wild West DLC
    LevelSplits.Add("Western2");
    LevelSplits.Add("Western3");
    LevelSplits.Add("Western4");
    LevelSplits.Add("Dieselpunk1");     // Steampunk DLC
    LevelSplits.Add("Dieselpunk2");
    LevelSplits.Add("Dieselpunk3");
    LevelSplits.Add("Dieselpunk4");
    LevelSplits.Add("Portal1");         // Portal DLC
    LevelSplits.Add("AmongUs1");        // Among Us DLC
    LevelSplits.Add("PowerWash1");      // PowerWash Simulator DLC
    LevelSplits.Add("Talos1");          // The Talos Principle DLC

    List<string> IndividualLevelStart = new List<string>();
    IndividualLevelStart.Add("Toy1");
    IndividualLevelStart.Add("Adventure1");
    IndividualLevelStart.Add("Space1");
    IndividualLevelStart.Add("Victorian1");
    IndividualLevelStart.Add("Corporation1");
    IndividualLevelStart.Add("Holiday1");
    IndividualLevelStart.Add("Holiday2");
    IndividualLevelStart.Add("Holiday3");
    IndividualLevelStart.Add("Holiday4");
    IndividualLevelStart.Add("Holiday5");
    IndividualLevelStart.Add("Holiday6");
    IndividualLevelStart.Add("Holiday7");
    IndividualLevelStart.Add("Race1");
    IndividualLevelStart.Add("Mayan1");
    IndividualLevelStart.Add("Magic1");
    IndividualLevelStart.Add("Western1");
    IndividualLevelStart.Add("Dieselpunk1");
    IndividualLevelStart.Add("Portal1");
    IndividualLevelStart.Add("AmongUs1");
    IndividualLevelStart.Add("PowerWash1");
    IndividualLevelStart.Add("Talos1");

    List<string> IndividualLevelTerminate = new List<string>();
    IndividualLevelTerminate.Add("Toy1");
    IndividualLevelTerminate.Add("Adventure5");
    IndividualLevelTerminate.Add("Space5");
    IndividualLevelTerminate.Add("Victorian5");
    IndividualLevelTerminate.Add("Corporation5");
    IndividualLevelTerminate.Add("Holiday6");
    LevelSplits.Add("Holiday1");
    LevelSplits.Add("Holiday2");
    LevelSplits.Add("Holiday3");
    LevelSplits.Add("Holiday4");
    LevelSplits.Add("Holiday5");
    LevelSplits.Add("Holiday6");
    LevelSplits.Add("Holiday7");
    IndividualLevelTerminate.Add("Race2");
    IndividualLevelTerminate.Add("Mayan4");
    IndividualLevelTerminate.Add("Magic4");
    IndividualLevelTerminate.Add("Western4");
    IndividualLevelTerminate.Add("Dieselpunk4");
    IndividualLevelTerminate.Add("Portal1");
    IndividualLevelTerminate.Add("AmongUs1");
    IndividualLevelTerminate.Add("PowerWash1");
    IndividualLevelTerminate.Add("Talos1");

    vars.LevelSplits = LevelSplits;
    vars.IndividualLevelStart = IndividualLevelStart;
    vars.IndividualLevelTerminate = IndividualLevelTerminate;
    vars.isLoading = false;
    vars.canLogLoading = true;
    vars.celebrationPoseCounter = 0;
    vars.hasJustCounted = false;
    vars.split = false;
}

init
{
    vars.Helper.Load();
    old.SceneId = -2;
    old.SceneName = "null";
    old.roomTimer = -1.0f;
    old.playerPose = -1;
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

    // Check if scene is in a loading screen. 
    vars.isLoading = current.SceneName == "Empty" || current.SceneName == "";

    // Reset split flag and logging scene changes.
    if (old.SceneId != current.SceneId)
    {
        vars.celebrationPoseCounter = 0;
        print("[" + DateTime.Now.ToString("M/d/yyyy hh:mm:ss.fff") + "] - Entered scene " + current.SceneName);
    }

    // Split when you finish a level that is not Toy1.
    if (old.playerPose != current.playerPose)
    {
        print("[" + DateTime.Now.ToString("M/d/yyyy hh:mm:ss.fff") + "] - Current Pose: " + current.playerPose);
    }   

    if (!vars.hasJustCounted && current.SceneName != "MenuPC" && current.SceneName != "Empty" && current.SceneName != "" && current.playerPose >= 0 && current.playerPose <= 3)
    {
        print("[" + DateTime.Now.ToString("M/d/yyyy hh:mm:ss.fff") + "] - Pose Checked!");
        vars.celebrationPoseCounter++;
        if (vars.celebrationPoseCounter == 1)
        {
            vars.split = true;
            print("[" + DateTime.Now.ToString("M/d/yyyy hh:mm:ss.fff") + "] - We've split!");
        }
        vars.hasJustCounted = true;
    } 
    else
    {
        if (current.playerPose >= 5 && current.playerPose <= 6)
        {
            vars.hasJustCounted = false;
        }
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
        print("[" + DateTime.Now.ToString("M/d/yyyy hh:mm:ss.fff") + "] - Timer started in " + current.SceneName);
        return true;
    }
}

reset
{
    /*
        We reset the timer depending on the player settings.
            - If the player is playing in IL Mode, then we reset if the player
              resets the first room of the pack OR they return to the menu at
              any time.
    */
    if (settings["il_mode"] && current.SceneName == vars.MenuName)
    {
        print("[" + DateTime.Now.ToString("M/d/yyyy hh:mm:ss.fff") + "] - Timer restarted in " + current.SceneName);
        return true;
    }
}

split
{
    // We split the timer whenever the player completes a level (when the player celebrates)
    // We're using the in-game timer. This is a bit scuffed if the player takes too long to
    // solve the room, but this should suffice for now.
    if (vars.split) 
    {
        print("[" + DateTime.Now.ToString("M/d/yyyy hh:mm:ss.fff") + "] - Split occured in " + current.SceneName);
        return true;
    }
}

isLoading
{
    // Loading times happen when the player is transitioning between different scenes.
    // Timer should resume based on the room timer (it can be invisible), regardless of player settings.
    if (vars.isLoading && vars.canLogLoading) 
    {
        print("[" + DateTime.Now.ToString("M/d/yyyy hh:mm:ss.fff") + "] - Level is loading, timer paused.");
        vars.canLogLoading = false;
    }
    else if (!vars.isLoading)
    {
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
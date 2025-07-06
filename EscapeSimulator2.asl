/*
    Yep, a continuation of losing my mind in pointer scanning 2.0. Luckily there's carry over from
    the previous game, and if you are wondering, yes, I do enjoy doing pointer scannings.

    Author: Undalevein
    Last worked: July 5, 2025.
*/

state("Escape Simulator 2") 
{
    float roomTimer : "UnityPlayer.dll", 0x01CB9700, 0x0, 0x58, 0x28, 0x2E8, 0x38, 0x20, 0x14F8;
    // int playerState : "mono-2.0-bdwgc.dll", 0x00774358, 0x280, 0xCF0, 0x70, 0x200, 0x120, 0xE0, 0xF28, 0x3C;         // Broken
    int gameOverlay : "gameoverlayrenderer64.dll", 0x00153B24;
}

startup
{
    // Relative to Livesplit.exe (thank you hatkirby)
    vars.logFilePath = Directory.GetCurrentDirectory() + "\\autosplitter_escapesimulator2.log";
    vars.log = (Action<string>)((string logLine) => {
        string time = System.DateTime.Now.ToString("dd/MM/yy hh:mm:ss.fff");
        print("[Escape Simulator 2 ASL] " + logLine);
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
    settings.Add("il_mode", false, "Individual Level Runs: timer starts in opening first level, ends at last. Resets when entering menu.");

    List<string> IndividualLevelStart = new List<string>();
    IndividualLevelStart.Add("Tutorial1");               // Tutorial
    IndividualLevelStart.Add("Dracula1");                // Courtyard
    IndividualLevelStart.Add("Eos1");                    // Hybernation Pods    (These and below are guesses, please change later)
    IndividualLevelStart.Add("Treasure1");               // Tavern
    vars.IndividualLevelStart = IndividualLevelStart;

    List<string> IndividualLevelTerminate = new List<string>();
    IndividualLevelTerminate.Add("Tutorial1");           // Tutorial
    IndividualLevelTerminate.Add("Dracula4");            // Crypt
    IndividualLevelTerminate.Add("Eos4");                // Into the Unknown    (These and below are guesses, please change later)
    IndividualLevelTerminate.Add("Treasure4");           // Hideout
    vars.IndividualLevelTerminate = IndividualLevelTerminate;

    List<string> DarkestPuzzles = new List<string>();
    DarkestPuzzles.Add("DraculaDarkest1");
    DarkestPuzzles.Add("DraculaDarkest2");
    DarkestPuzzles.Add("DraculaDarkest3");
    DarkestPuzzles.Add("DraculaDarkest4");
    DarkestPuzzles.Add("EosDarkest1");
    DarkestPuzzles.Add("EosDarkest2");
    DarkestPuzzles.Add("EosDarkest3");
    DarkestPuzzles.Add("EosDarkest4");
    DarkestPuzzles.Add("TreasureDarkest1");
    DarkestPuzzles.Add("TreasureDarkest2");
    DarkestPuzzles.Add("TreasureDarkest3");
    DarkestPuzzles.Add("TreasureDarkest4");
    vars.DarkestPuzzles = DarkestPuzzles;

    List<string> NonSplitableScenes = new List<string>();
    NonSplitableScenes.Add("Lobby1");                   // Lobby Menu
    NonSplitableScenes.Add("Empty");                    // Loading Scene
    NonSplitableScenes.Add(null);                       // Loading Transition
    vars.NonSplitableScenes = NonSplitableScenes;

    vars.isLoading = false;
    vars.hasSplit = false;
    vars.canLogLoading = true;
    vars.split = false;
    vars.savedPreviousScene = "null";
}

init
{
    vars.Helper.Load();
    old.SceneId = -2;
    old.SceneName = "null";
    old.roomTimer = -1.0f;
    old.playerState = 0;
    old.gameOverlay = 256;
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
    else if (old.gameOverlay == 256 && current.gameOverlay == 0 || 
             current.SceneName == "Lobby1" && old.playerState == 0 && current.playerState == 1123090432)
    {
        vars.isLoading = false;
    }

    // When changing scenes, reset the split latch and save old scene.
    if (old.SceneId != current.SceneId)
    {
        vars.savedPreviousScene = old.SceneId;
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
              player has control in Tutorial.
    */
    if (old.gameOverlay == 256 && 
        current.gameOverlay == 0 && 
        vars.savedPreviousScene != current.SceneId &&
        (settings["il_mode"] && vars.IndividualLevelStart.Contains(current.SceneName) ||
         settings["tutorial_start"] && current.SceneName == "Tutorial1"))
    {
        vars.log("Timer started in " + current.SceneName);
        vars.savedPreviousScene = current.SceneId;
        return true;
    }
}

reset
{
    /*
        We reset the timer if the player is playing in IL Mode. If so then we reset if the player
        resets the first room of the pack OR they return to the menu at any time.
    */
    if (settings["il_mode"] && current.SceneName == "Lobby1" && old.SceneId != current.SceneId)
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
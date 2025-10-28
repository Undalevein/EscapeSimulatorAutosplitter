/*
    Yep, a continuation of losing my mind in pointer scanning 2.0. Luckily there's carry over from
    the previous game.

    Author: Undalevein
    Last worked: October 28, 2025.
*/

state("Escape Simulator 2") {}


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

    Assembly.Load(File.ReadAllBytes("Components/uhara6")).CreateInstance("Main");
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Escape Simulator 2";
    vars.Helper.LoadSceneManager = true;    
    
    settings.Add("last_pack_split", false, "Split when you complete the last level in the pack.");
    settings.Add("level_completion_split", true, "Split when completing any level.");
    settings.Add("tutorial_start", false, "Full Game Runs: Start timings with the Tutorial level.");
    settings.Add("il_mode", false, "Individual Level Runs: timer starts in opening first level, ends at last. Resets when entering menu.");
    settings.Add("token_split", false, "Split when you collect any Token.");
    settings.Add("all_tokens_split", false, "Split when you collect the eighth Token in the same room.");

    List<string> IndividualLevelStart = new List<string>();
    IndividualLevelStart.Add("Tutorial1");               // Tutorial
    IndividualLevelStart.Add("Dracula1");                // Courtyard
    IndividualLevelStart.Add("Space1");                  // Hybernation Pods    (These and below are guesses, please change later)
    IndividualLevelStart.Add("Pirate1");                 // Tavern
    vars.IndividualLevelStart = IndividualLevelStart;

    List<string> IndividualLevelTerminate = new List<string>();
    IndividualLevelTerminate.Add("Tutorial1");           // Tutorial
    IndividualLevelTerminate.Add("Dracula4");            // Crypt
    IndividualLevelTerminate.Add("Space4");              // Into the Unknown    (These and below are guesses, please change later)
    IndividualLevelTerminate.Add("Pirate4");             // Hideout
    vars.IndividualLevelTerminate = IndividualLevelTerminate;

    List<string> DarkestPuzzles = new List<string>();
    DarkestPuzzles.Add("DraculaDarkest1");
    DarkestPuzzles.Add("DraculaDarkest2");
    DarkestPuzzles.Add("DraculaDarkest3");
    DarkestPuzzles.Add("DraculaDarkest4");
    DarkestPuzzles.Add("SpaceDarkest1");
    DarkestPuzzles.Add("SpaceDarkest2");
    DarkestPuzzles.Add("SpaceDarkest3");
    DarkestPuzzles.Add("SpaceDarkest4");
    DarkestPuzzles.Add("PirateDarkest1");
    DarkestPuzzles.Add("PirateDarkest2");
    DarkestPuzzles.Add("PirateDarkest3");
    DarkestPuzzles.Add("PirateDarkest4");
    vars.DarkestPuzzles = DarkestPuzzles;

    List<string> NonSplitableScenes = new List<string>();
    NonSplitableScenes.Add("Lobby1");                   // Lobby Menu
    NonSplitableScenes.Add("Empty");                    // Loading Scene
    NonSplitableScenes.Add(null);                       // Loading Transition
    vars.NonSplitableScenes = NonSplitableScenes;

    vars.tokenCounter = 0;

    vars.isLoading = false;
}


init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var jit = vars.Uhara.CreateTool("UnityCS", "JitSave");
        jit.SetOuter("EscapeSimulator.Core");

        var gameClass = mono["EscapeSimulator.Core", "Game"];
        var gameInstance = jit.AddInst("Game");
        var gameFlag = jit.AddFlag("Game", "handleToken");
        // var puzzleCompletedFlag = jit.AddFlag("Game", "finishPuzzle");

        var menuClass = mono["EscapeSimulator.Core", "Menu"];
        var menuInstance = jit.AddInst("Menu");

        var loadingCanvasClass = mono["EscapeSimulator.Core", "LoadingCanvas"];
        var loadingCanvasInstance = jit.AddInst("LoadingCanvas");
;

        jit.ProcessQueue();

        vars.Helper["levelCompleted"] = vars.Helper.Make<bool>(gameInstance, gameClass["isLevelCompleted"]);
        vars.Helper["exiting"] = vars.Helper.Make<bool>(gameInstance, gameClass["exiting"]);
        vars.Helper["gotToken"] = vars.Helper.Make<int>(gameFlag);
        // vars.Helper["puzzleCompleted"] = vars.Helper.Make<int>(puzzleCompletedFlag);
        
        return true;
    });
    
    old.SceneName = "MenuPC";
    current.SceneName = "MenuPC";
    old.levelCompleted = false;
    old.exiting = false;
    old.gotToken = 0;
}


update
{   
    // Level names is used for logging and accurate comparaisons.
    current.SceneName = vars.Helper.Scenes.Active.Name;

    // Token Counter Logic
    if (old.gotToken != current.gotToken)
    {
        vars.tokenCounter++;
    }
    if (vars.isLoading)
    {
        vars.tokenCounter = 0;
    }

    // Logging Swamp
    if (old.levelCompleted != current.levelCompleted)
    {
        vars.log("Level Completed: " + current.levelCompleted);
    }
    if (old.exiting != current.exiting)
    {
        vars.log("Exiting: " + current.exiting);
    }
    if (old.SceneName != current.SceneName)
    {
        vars.log("Current Scene Name: " + current.SceneName);
    }
    if (old.gotToken != current.gotToken)
    {
        vars.log("Got Token: " + current.gotToken);
    }
}


start
{
    /*
        Player starts upon player getting control.

        One of the other conditions below must be satisfied as well, based on user's settings:
            - il_mode is toggled on and the level is the beginning of the pack.
            - tutorial_start is toggled on and the level is the Tutorial Level (first area).
            - first_chamber_start is toggled on and the level is the First Chamber level.
        
        One last thing: NEVER START THE SPLIT TWICE OR MORE ON THE SAME LEVEL!!!
    */
    bool doStart = old.exiting && !current.exiting && 
                   (settings["il_mode"] && vars.IndividualLevelStart.Contains(current.SceneName) ||
                    settings["tutorial_start"] && current.SceneName == "Tutorial1");
    if (doStart) vars.log("Splits has started!");
    return doStart;
}

reset
{
    /*
        Reset only if the following conditions have been satisfied:
            - The condition il_mode has been checked from the user settings.
            - The player enters the Menu.

        This assumes that no new strategies will involve going to the menu. However,
        I believe that if the player leaves to the menu when running for IL runs,
        most certainly they are doing this because they want to reset the entire
        run.
    */
    return settings["il_mode"] && current.SceneName == "MenuPC";
}

onReset
{
    /*
        This method exists because vars.isLoading is a flip-flop variable, so reset it.
    */
    vars.isLoading = false;
}


split
{
    /*
        For all situations, the timer should split the moment the player gets the credit for 
        completing the level. Unless the player restarts the level or moves on to the next 
        level, the timer should never split again during the same level.

        In addition, one of the following conditions must be satisfied according to user settings:
            - level_completion_split is toggled on and any level has been completed
            - last_pack_split is toggled on and the player completed the final level in a pack OR any
              of the Extra levels.
    */
    bool doSplit = !old.levelCompleted && current.levelCompleted && !vars.NonSplitableScenes.Contains(current.SceneName) &&
                   (settings["level_completion_split"] ||
                    settings["last_pack_split"] && vars.IndividualLevelTerminate.Contains(current.SceneName))
                   ||
                   (settings["token_split"] && old.gotToken != current.gotToken ||
                   settings["all_tokens_split"] && old.gotToken != current.gotToken && vars.tokenCounter == 8);
    if (doSplit) vars.log("Split has occurred!");
    return doSplit;
}


isLoading
{
    if (vars.isLoading && old.exiting && !current.exiting) 
    {   
        vars.log("Level has finished loading, timer resumed.");
        vars.isLoading = false;
    }
    else if (!vars.isLoading && !old.exiting && current.exiting)
    {
        vars.log("Level is loading, timer paused.");
        vars.isLoading = true;
    }
    return vars.isLoading;
}
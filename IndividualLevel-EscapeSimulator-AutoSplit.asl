state("Escape Simulator") {}

startup
{
    var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
    var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
    vars.Helper = Activator.CreateInstance(type, timer, this);
    vars.Helper.LoadSceneManager = true;
    
    settings.Add("il_mode", false, "Time ends at the end of the pack with automatic resets activated.");
    settings.Add("3_levels", false, "Speedrun of First 3 Levels.");
    settings.Add("4_levels", false, "Speedrun of First 4 Levels.");
    settings.Add("5_levels", false, "Speedrun of First 5 Levels.");
    settings.Add("6_levels", false, "Speedrun of First 6 Levels.");
    settings.Add("last_pack_split", true, "Split at the moment when you complete the last level in the pack.")

    vars.LoadingIndex = 0;
    vars.MenuIndex = 2;

    int[] StartIndex = { 3, 5, 10, 15, 22, 27, 28 };
    List<string> LevelSplits = new List<string>();
    LevelSplits.Add("Toy1");            // Tutorial
    // LevelSplits.Add("Toy2");
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
    LevelSplits.Add("Holiday1");        // Extras
    LevelSplits.Add("Holiday2");
    LevelSplits.Add("Holiday3");
    LevelSplits.Add("Holiday4");
    LevelSplits.Add("Holiday5");
    LevelSplits.Add("Holiday6");
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
    IndividualLevelTerminate.Add("Race2");
    IndividualLevelTerminate.Add("Mayan4");
    IndividualLevelTerminate.Add("Magic4");
    IndividualLevelTerminate.Add("Western4");
    IndividualLevelTerminate.Add("Dieselpunk4");
    IndividualLevelTerminate.Add("Portal1");
    IndividualLevelTerminate.Add("AmongUs1");
    IndividualLevelTerminate.Add("PowerWash1");
    IndividualLevelTerminate.Add("Talos1");

    List<string> SteamPunkSplits = new List<string>();
    SteamPunkSplits.Add("Dieselpunk2");
    SteamPunkSplits.Add("Dieselpunk3");
    SteamPunkSplits.Add("Dieselpunk4");
    bool IsStartIndex = false;
    bool Split = false;

    vars.StartIndex = StartIndex;
    vars.LevelSplits = LevelSplits;
    vars.IndividualLevelStart = IndividualLevelStart;
    vars.IndividualLevelTerminate = IndividualLevelTerminate;
    vars.IsStartIndex = IsStartIndex;
    vars.Split = Split;
}

init
{
    vars.Helper.Load();
}

update
{
    if (!vars.Helper.Update())
        return false;

    current.Scene       = vars.Helper.Scenes.Active.Index;
    current.SceneName   = vars.Helper.Scenes.Active.Name;
    vars.IsStartIndex   = false;
    vars.Split          = false;

    for (int i = 0; i < vars.StartIndex.GetLength(0); i++)
    {
        // SteamPunk DLC levels do not use index, use SceneName instead
        if (current.Scene == vars.StartIndex[i] || vars.IndividualLevelStart.Contains(current.SceneName))
        {
            
            vars.IsStartIndex = true;
            break;
        }
    }

    if (current.Scene > vars.MenuIndex || vars.LevelSplits.Contains(current.SceneName))
    {
        vars.Split = true;
    }


}

start
{
    return (old.Scene == current.Scene && vars.IsStartIndex);
}

reset
{
    return (current.Scene == vars.MenuIndex);
}

split
{
    return (old.Scene != current.Scene && vars.Split);
}

isLoading
{
    return (current.SceneName == "Empty" || current.SceneName == "");
}

exit
{
    vars.Helper.Dispose();
}

shutdown
{
    vars.Helper.Dispose();
}
state("Escape Simulator") {}

startup
{
    var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
    var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
    vars.Helper = Activator.CreateInstance(type, timer, this);
    vars.Helper.LoadSceneManager = true;

    vars.LoadingIndex = 0;
    vars.MenuIndex = 2;
    // 3 - Tutorial
    // 5 - Space1
    // 10 - Egypt1
    // 15 - Mansion1
    // 22 - Omega1
    // 27 - Santa's Workshop
    // 28 - Cats In Time
    int[] StartIndex = { 3, 5, 10, 15, 22, 27, 28 };
    List<string> SteamPunkSplits = new List<string>();
    SteamPunkSplits.Add("Dieselpunk2");
    SteamPunkSplits.Add("Dieselpunk3");
    SteamPunkSplits.Add("Dieselpunk4");
    bool IsStartIndex = false;
    bool Split = false;

    vars.StartIndex = StartIndex;
    vars.SteamPunkSplits = SteamPunkSplits;
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
        if (current.Scene == vars.StartIndex[i] || current.SceneName == "Dieselpunk1")
        {
            
            vars.IsStartIndex = true;
            break;
        }
    }

    if (current.Scene > vars.MenuIndex || vars.SteamPunkSplits.Contains(current.SceneName))
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
    return (current.Scene == vars.LoadingIndex);
}

exit
{
    vars.Helper.Dispose();
}

shutdown
{
    vars.Helper.Dispose();
}
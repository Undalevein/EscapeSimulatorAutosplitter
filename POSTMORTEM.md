# Escape Simulator - Post Mortem

## Brief Synopsis

* Project Name: Escape Simulator AutoSplitter
* Description: An AutoSplitter that removes load times and automatrically start the LiveSplit timer for runners who want to have an even playing field with those with better hardware or for runners who want precise timings provided by the AutoSplitter
* Timeline: July 2025 – Present
* Collaborators:
  * Jonc4 - previously worked on the AutoSplitter and I picked up his work to make it work.

## Motivations

I picked up this project because I was quite frustrated that when I was doing an individual level run for the Wild West DLC in *Escape Simulator*, I felt like my loading times are putting me at a disadvantage. Though the load times take around 7-11 seconds, which in the run had 3, the world record holder had load times around 3-4 seconds, which for a 4-5 minute run was too much of a disadvantage.

This was previously worked on by Jonc4, who made the autosplitter but it was not working properly nor did it satisfy the runner's need. Still, his work was great to continue on since he had the template of how he got certain values from the game, including using asl-helper made by ero. For the summer of 2025, I decided to dedicate my time to improving the script. Later on, I will then go and create the AutoSplitter for the sequel, *Escape Simulator 2*, which has similarities to the first game.

## Project Analysis

### Things that Went Well

The AutoSplitter Language (ASL) uses C#, which is a language that although I was not too familiar with, I knew what to do in the case of not knowing a specific programming languages and in addition, I have done Java a lot in the past. As for the syntax with ASL, it was easy to figure out because of the documentation provided by the developers and the code from Jonc4's work. 

Requirements gathering was also pretty simple because the AutoSplitter follows the game's Speedrun.com (SRC) rules. I need to start the timer once the player gets control, then split once the level is complete, and remove times during loading screens until the player regains control. This is also because I have done *Escape Simulator* speedruns before, so I was familiar with what the community wants and what the previous AutoSplitter was lacking.

### Things that Didn't Go As Planned

What slowed down the project was bad solutions. When I was about to add my AutoSplitter to the official AutoSplitter XML page, I received criticism for using magic numbers I obtained with Cheat Engine. It is not bad to use use for some games, but because *Escape Simulator* constantly updates with new content and bug fixes, the magic numbers I found before the update becomes obsolete which would lead to contant heavy maintenance, which looking back now, I should have accounted for earlier. If I did not have the AutoSplitter be more resilient, I would have trouble finding the time to constantly rebuild the script over and over again.

Another difficulty was hacking. As hinted, I used Cheat Engine when trying to find magic numbers. Even if magic numbers were the solution, which they were not, finding the values took so long to find. Each time when I am searching for a specific value, I would surmise what value the developers used, then constantly play Edgewood Mansion's Brain Checkup and Library levels as they were the quickest to solve and test, and fail, and try again. Even when changing to ILSpy, it was still brute force when trying to find the right variables. I was not too patient using these tools, which did make it difficult to find motivations to test my script rigorously. It was only later where I started reading what ILSpy was giving me and understanding the game's logic, which helped me precisely finding a good variable to use for *Escape Simulator 2*.

Testing was something I could not get ahold of. I know that my script works on my computer, but what about on a different computer? On a different OS like Mac? On VR? With mutliplayer? Or maybe a combination of all of these. I was happy I got one person to test out my script and get feedback, but the community was largely inactive. This is an issue since not everyone has *Escape Simulator*, so the people who can test it are those who are using it before recording their runs. Only there can I fix my script.

### Things that Can Be Improved

For the most part, what I think should greatly improve was communication. While this was a solo project, I could seek active help from the developers earlier before pushing a problematic solution onto the XML file, where I ask my concerns about working on an AutoSplitter for a game that is constantly updating. I was comfortable talking in communities I am a part of, but seeking help outside still makes me uneasy. After getting feedback from ero and rumii, it greatly improved my script's resilience to future game updates, and I am grateful for them helping.

While I couldn't get help for testing phase, I can make it easier for people to file an issue by linking them to the GitHub issues page to post their problems. While the community is not active, that does not mean that there would be runners here and there that would pick up the game for the bit. If the game was more active for runners we could have a different discussion, but this was the cards I was dealt with.

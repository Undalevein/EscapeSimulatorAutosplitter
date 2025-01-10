# Escape Simulator Autosplitter

### Motivations

As Escape Simulator gets more updates, loading times continue to get worse and worse. As someone who likes to speedrun this game during my leisure, I often lose time due to hardware differences and I would find myself not being able to compete for the world record for the IL leaderboards. This is especially compounded for coop runs.

This autosplitter is meant to address this issue by not only giving accurate split times for comparison, but to also remove loading times to make running Escape Simulator more accesssible to players.

### Credit

This is a continuation on Jonc4's autosplitter that was made in the beginning, with the last update being the Steampunk update. With his work, I was able to fix some of the features he made, so I am grateful for his efforts.

## Autosplitter Roadmap

Here is a roadmap on what I would add during development:

1. **Timer Start/Split Control** - I want the autosplitter to start and split automatically for the speedrun. Currently, the Autosplitter does start when you enter a level, but if you try to reset your splits, the autosplitter will start again. This is a bug that I am working to resolve.
2. **Remove Loading Times** - To make competition fair, I plan to remove loading times for the Autosplitter. The hope is to remove the time between opening up the level and when the player has complete control of their character. The Autosplitter somewhat can do that by referencing the level name and checking if it is not the string Empty or a null type, but it does not remove the times where the player cannot move.
3. **Coop Support** - For those who want to speedrun together with friends, this is what I want to include. Similarly to my plan to remove loading times, I plan to make sure that the run does not start until all players have total control (or at least 1 of the players).
4. **IL Auto Reset** - I want to include an automatic reset option for players who want to automatically reset their splits when they reset. This can be either returning to the main menu or resetting the level they once are currently on. This is not on by default, but it's an option for runners.
5. **Legacy Version Support** - For runs that are better ran on the legacy version than on the current version, I plan to implement those based on popular demand since there's too many versions of Escape Simulator especailly as it continues to get new updates.

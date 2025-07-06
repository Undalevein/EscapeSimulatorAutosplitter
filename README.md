# Escape Simulator Autosplitter

### Motivations

As Escape Simulator gets more updates, loading times continue to get worse and worse. As someone who likes to speedrun this game during my leisure, I often lose time due to hardware differences and I would find myself not being able to compete for the world record for the IL leaderboards. This is especially compounded for coop runs.

This autosplitter is meant to address this issue by not only giving accurate split times for comparison, but to also remove loading times to make running Escape Simulator more accesssible to players.

### Implementation

To implement the autosplitter (at the moment), you cannot do the conventional way of activating the autosplitter. Instead, you must follow these steps.

1. Download the file `EscapeSimulator.asl` and the `Components` folder with the helper file and put somewhere in your computer. They should both be in the same directory. Copy the file location of the `.asl` file onto your clipboard.
2. Right click your Livesplit timer and select "Edit Layout..."
3. Add a new component by clicking on the "+" button. Go to "Control" and add the "Scriptable Auto Splitter" component.
4. Select the added component. There, you can paste your file location into the "Script Path" textbox. Otherwise, you can click on "Browse" to select that asl file. 
5. Toggle the options like you would normally with an Auto Splitter.
6. Boot up the game and test it!


### Credit

This is a continuation on Jonc4's autosplitter that was made in the beginning, with the last update being the Steampunk update. With his work, I was able to fix some of the features he made, so I am grateful for his efforts.

## Autosplitter Milestones

Here's what has been completed so far:
- Add 1 second delay to 1st split, player control is about 1 second after the 1st scene is "loaded" [Completed 7/5/2025, used a base address]
- Split when player has completed the level (basically when the celebration starts for the first time). [Completed 7/5/2025]
- Resets timer when you go back to Menu (For IL runs). [Completed 7/5/2025]
- Figure out a way to remove load times. [Completed 7/5/2025]
- Timer must automatically start. [Completed 7/5/2025]

Here is a roadmap on what I would add during development, which may or may not be accomplished:

1. **Coop Support** - For those who want to speedrun together with friends, this is what I want to include. Similarly to my plan to remove loading times, I plan to make sure that the run does not start until all players have total control (or at least 1 of the players). I have yet to test this autosplitter in a multiplayer setting though.
2. **Legacy Version Support** - For runs that are better ran on the legacy version than on the current version, I plan to implement those based on popular demand since there's too many versions of Escape Simulator especailly as it continues to get new updates. Since glitches get patched out, I figure I might as well integrate the autosplitter there.
3. **100% Runs** - If you complete a level but have not collected all of the Tokens, the autosplitter should not split if you have not collected all of the Tokens. I will need to keep track of the levels you have completed first, but I do need an address pointer to these Tokens themselves.

Though, here are some things that I may not be willing to do:
1. **VR** - I don't own Escape Simulator in VR, nor do I know how to configure one. Unless there are some demand, I may try, but this is something that is the bottom of the barrel in terms of priorities.
2. **Other Consoles** - My Mac is busted, and I don't think I will get another anytime soon. XBox, PlayStation, and other console versions I may not consider.

## Escape Simulator 2 Roadmap

Yep, I plan to make the autosplitter for Escape Simulator 2. From the demos, it appears that the gameplay and feel of Escape Simulator 2 is the same as Escape Simulator 1, except with a touch of dark realism paint. From the demo, I was able to carry over the load time removal. However, I will need to retrofit the later features into the run.
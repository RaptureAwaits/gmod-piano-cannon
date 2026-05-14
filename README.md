# gmod-piano-cannon
An old gmod addon of mine designed for the TTT gamemode.
https://steamcommunity.com/sharedfiles/filedetails/?id=2102162556

## Developer Notes
It's 5 years since I last touched this silly little thing and I had no idea what I was doing because "self-taught" programmer me didn't document or understand anything.

Here's how to do the stuff.

### Developing

- VS Code has a nice extension for GMod Lua, highly recommended.
https://marketplace.visualstudio.com/items?itemName=venner.vscode-glua-enhanced

### Compiling
```bat
"...\steamapps\common\GarrysMod\bin\gmad.exe" create -folder "...\gmod-piano-cannon" -out "...\gmod-piano-cannon\gma\ttt_piano_launcher.gma"
```

### Testing
- After compiling the .gma, run it back through gmad to get a folder with only the important stuff.
- Drop it in ...\steamapps\common\GarrysMod\garrysmod\addons

### Publishing
```bat
"...\steamapps\common\GarrysMod\bin\gmpublish.exe" update -addon "...\gmod-piano-cannon\gma\ttt_piano_launcher.gma" -id "2102162556" -changes "lorem ipsum"

:end
```
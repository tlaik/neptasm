# Neptasm Mod
Graphical improvements mod for Megadimension Neptunia VII.
## Features:
- FPS Unlock
- Resolution upscaling and downscaling
- Fitting resolution to the window size (Base game always renders at 1080p)
- Camera angles unlock
- Nep Nep
## Install:
 1. Download the latest .zip file from [Releases](https://github.com/tlaik/neptasm/releases/)
 2. Extract both files inside, dinput8.dll and nep.ini into the game's base folder.
     - You can find the game folder by right-clicking on your Nep game in Steam library, choosing "Properties", going to "Local files" tab and clicking "Browse".
## Configure:
 Default configuration already provides all the improvements, including unlocked framerate and 2.0x resolution.\
 If you wish to tune it yourself - open the nep.ini file with any text editor. If needed, right-click on it and go to "Open With".\
 All the options have self-explanatory names, mirroring the list of features, and have comments explaining their effect and suggested values.
## Notes:
Tested only with the Steam version. GoG might or might not be supported - feel free to find it out yourself and report back.\
If you wish to partake in the delightful misery of editing the source code, there are two .cmd files set up to assemble the project:
- build\_ms.cmd - Assumes installed Visual Studio 2019 and uses MS assembler and linker. You can edit the path to *vcvars32.bat* inside if you have a different version of Visual Studio or MSBuild.
- build\_uasm\_polink.cmd - Uses [UASM](http://www.terraspace.co.uk/uasm.html) assembler and polink from [MASM32](https://masm32.com). Produces smaller binaries, which is nice and cool and recommended.
## Credits:
 - [MegaresolutionNeptunia](https://github.com/AterialDawn/MegaresolutionNeptunia) - Research into controlling the game resolution.
 - Jack Daniel's & My friends - Moral support during my dives into the abhorrent abomination that is this game's engine.
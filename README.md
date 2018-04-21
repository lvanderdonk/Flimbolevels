# Flimbo level editor and levels

This repository is used for hosting the Flimbo's Quest level editor and levels. The repository is not used for source control of the editor. Please find some technical details and a small guide of the editor below.

If you find any errors, and there will be errors ;-) , on this page or any errors in the level editor. Please inform me by sending a personal message to https://www.facebook.com/laurensvanderdonk , I will try to fix the errors and update this page. This is an ongoing project. 

# The editor
The editor was used in 1989/1990 to build the levels for Flimbo's Quest on the Commodore 64. The editor is written in 6502 assembly code by Laurens van der Donk. It is specially made for Flimbo's Quest.

# Flimbo's Quest
Is a game for the commodore 64 and several other platforms. The game was published in 1990. 

# Credits Flimbo's Quest C64
* Programmed by: Laurens van der Donk
* Game design by: Jacco van het Riet, Arthur van Jole, Laurens van der Donk
* Graphics by: Arthur van Jole, Jacco van het Riet
* Music by: Johannes Bjerregaard, Reyn Ouwehand
* Demo by: Patrick Witteman + (will be added in the next days...)

# Getting started with the editor
The download consists of a D64 image file. You can use the disk image in Vice (C64 emulator). You can download Vice here: http://vice-emu.sourceforge.net/index.html#download

The D64 image file contains the Flimbo level editor and all 7 levels of Flimbo's Quest.

Startup Vice, Goto file (top menu), Attach disk image, Drive 8. Choose the downloaded disk image "Flimbo levels".

Once attached. Type: LOAD"FLIMBO-EDITOR",8 [Enter] .  And type RUN [Enter]
  
In the editor press: L  (shift+l) and type the name of the level:
Names of the levels:
* LEVEL1
* LEVEL2
etc. To LEVEL7

# Glossary
* Character editor = For editing the characterset. The characters in a characterset are the building blocks for a level.
* Level editor = For editing the level. You build a level with the characters created in the character editor. In the level editor you can edit the foreground and background(parallax). You can also edit the data on which Flimbo and the enemies can walk on(see bumpdata).
* Bumpdata = You can assign bumpdata to characters. It is the data on which Flimbo and the enemies can walk on.

Level details.
* 1 Characterset (4 charactersets for parallax scrolling)
* 18 Lines of characters
* 400 Characters wide (10 screens)
* Parallax 10 lines of characters
* 3 Colors. 2 Multicolors, 1 character color (Switched multicolors on line 17 and 18)
* Consists of 3 files, LV> (Level) , CH> (Characterset), CO> (Character colors)

The editor exists of 2 main modes.
* Character editor
* Level editor

Below are the options of the editor. Take care of the capital keyboard options.

Functions (keyboard options) in character editor.
* s = In characterset left
* d = In characterset right
* e = In characterset up
* x = In characterset down
* Cursor-left	= In character edit left
* Cursor-right = In character edit right
* Cursor-up = In character edit up
* Cursor-down = In character edit down
* F1 = Goto leveleditor
* F5 = Next character color
* F6 = Previous character color
* F7 = Show directory
* 1 = Set pixel multicolor 1
* 2 = Set pixel multicolor 2
* 3 = Set pixel character color
* 4 = Next multicolor 1 
* 5 = Next multicolor 2
* 6 = Next background color
* 7 = Previous multicolor 1
* 8 = Previous multicolor 2
* 9 = Previous background color
* Space = Clear pixel
* X = Clear editchar
* L = Load level
* S = Save level
* Q = Fill character with multicolor 1
* W = Fill character with multicolor 2
* E = Fill character with character color
* r = RepeatKeys
* u = Switch colors between top / bottom
* c = Copy characters in characterset
* CTRL + u = Fill unused characters

Functions (keyboard options) in level editor.
* s = In characterset left
* d = In characterset right
* e = In characterset up
* x = In characterset down
* Cursor-left	= In level left
* Cursor-right = In level right
* Cursor-up = In level up
* Cursor-down = In level down
* F1 = Goto character editor
* F3 = Switch foreground/background mode
* F7 = Show directory
* 4 = Next multicolor 1 
* 5 = Next multicolor 2
* 6 = Next background color
* 7 = Previous multicolor 1
* 8 = Previous multicolor 2
* 9 = Previous background color
* Space = Clear character in level
* Enter = Place character in level
* Shift+Enter = Goto character of level
* L = Load level
* S = Save level
* B = Bumpdata
* X = Block copy start
* C = Block copy end
* V = Block copy paste
* b = Bumpdata
* u = Switch colors between top / bottom
* w = Hide foreground
* r = RepeatKeys
* CTRL + u = Fill unused chars
* CTRL + n = Background char start
* CTRL + m = Background char end
* < = Scroll left to right
* > = Scroll right to left
* . = Scroll left to right 40 characters
* , = Scroll right to left 40 characters

# Flimbo leveleditor and levels

This repository is used for hosting the Flimbo level editor and levels. The repository is not used for source control of the editor. Please find some technical details and a small guide of the editor below.

# Getting started
The download consists of a D64 image file. You can use the disk image in Vice (C64 emulator). You can download Vice here http://vice-emu.sourceforge.net/index.html#download 


# Glossary
* Character editor = For editing the characterset. The characters in a characterset are the building blocks for a level.
* Level editor = For editing the level. You build a level with the characters created in the character editor. In the level editor you can edit the foreground and background(parallax). You can also edit the data on which Flimbo and the enemies can walk on(see bumpdata).
* Bumpdata = You can assign bumpdata to characters. It is the data on which FLimbo and the enemies can walk on.

Level details.
* 1 Characterset (4 charactersets for parallax scrolling)
* 18 Lines of characters
* 400 Characters wide (10 screens)
* Parallax 10 lines of characters
* 3 Colors. 2 Multicolors, 1 character color
* Consists of 3 files, LV> (Level) , CH> (Characterset), CO> (Character colors)

The editor exists of 2 main modes.
* Character editor
* Level editor

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
* u = UpDownMode
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
* L = Load level
* S = Save level
* B = Bumpdata
* w = Hide foreground
* r = RepeatKeys
* < = Scroll left to right
* > = Scroll right to left
* . = Scroll left to right 40 characters
* , = Scroll right to left 40 characters

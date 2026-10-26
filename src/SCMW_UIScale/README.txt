SCMW - UI Scale  v1.0.0
========================

Makes SCUM's interface smaller or bigger while you play. It uses the game's
own layout scale, so mouse clicks stay on the control you aimed at.

No game files are edited.


KEYS
----
Ctrl + -   10 points smaller
Ctrl + +   10 points bigger (Ctrl + Shift + + on some keyboards)
Ctrl + 0   back to 100%

The number-pad - and + keys work too.


SAVED SETTING
-------------
The chosen size is remembered between game sessions. It is stored here:

  %LOCALAPPDATA%\SCUM\Saved\SCMW_UIScale.txt

Delete that file to start at 100% again.


REQUIREMENTS
------------
- UE4SS installed in SCUM\Binaries\Win64
- Launch SCUM with -nobattleye -fileopenlog (a shortcut is easiest)
- Single-player or private servers only; BattlEye must be off


HOW TO INSTALL
--------------
Extract the zip into:

  SCUM\Binaries\Win64

Then add this line to:

  SCUM\Binaries\Win64\ue4ss\Mods\mods.txt

  SCMW_UIScale : 1


HOW TO REMOVE
-------------
Set SCMW_UIScale to 0 in mods.txt, or delete the SCMW_UIScale mod folder.
The interface returns to normal on the next launch. Delete the saved setting
file too if you want a clean reset.


TROUBLESHOOTING
---------------
After launching, open:

  SCUM\Binaries\Win64\ue4ss\UE4SS.log

Look for lines starting with [SCMW]. They show the version, the saved scale,
and any error.


LICENSE
-------
MIT License. See LICENSE.txt in this folder, or the project repository.

You may use, modify and redistribute this mod, including commercially, as long
as the copyright notice and the licence text stay with it. Attribution is the
only requirement.


Version 1.0.0

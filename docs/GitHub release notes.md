# SCMW UI Scale v1.0.0

First release.

- **Nexus page:** https://www.nexusmods.com/scum/mods/339
- **Source:** https://github.com/scummoddingworkshop-byte/SCMW-UI-Scale

## What it does

- Adjustable UI scale for SCUM, in 10-point steps.
- **Ctrl + −** smaller, **Ctrl + +** bigger, **Ctrl + 0** back to 100%.
- Number-pad keys supported.
- The chosen size is saved between sessions.
- Works in the inventory, crafting, HUD and main menus.
- No game files are edited.

## Requirements

- UE4SS 3.x (tested with 3.0.1).
- Launch SCUM with `-nobattleye -fileopenlog`.
- Single-player or private servers only.

## Download

Use `SCMW_UIScale_v1.0.0.zip` from this release. Extract it into
`SCUM\Binaries\Win64`, then add `SCMW_UIScale : 1` to
`ue4ss\Mods\mods.txt`.

A SHA256 checksum is attached next to the zip. Full instructions are in the
repository README and in the zip.

## Tested on

SCUM 1.3.4.2 (build 25804202) with UE4SS 3.0.1.

## Licence

MIT License. Attribution is the only requirement.

## Notes

UE4SS is a separate project and is not included. Game updates may require a
newer UE4SS build.

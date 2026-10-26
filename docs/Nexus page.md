# SCMW — UI Scale

**Make SCUM's interface smaller or bigger while you play — in 10-point steps — and keep the size you like between sessions.**

This uses the game's own layout scale, so mouse clicks and highlights stay on the control you aimed at. It is not a picture-only zoom.

> **Important:** this is a UE4SS mod. It needs BattlEye off, so it works in single-player and on private servers only — not on official servers.

---

## What it does

SCUM's interface is fixed at a size that is too large for many PC screens. This mod adds a simple, adjustable UI scale:

- **Ctrl + −** — 10 points smaller
- **Ctrl + +** — 10 points bigger (Ctrl + Shift + + on some keyboards)
- **Ctrl + 0** — back to 100%

The number-pad **−** and **+** keys work too. The scale goes from **40%** to **150%**.

It affects the inventory, crafting, HUD and the main menus.

The chosen size is **saved automatically** and used again the next time you start the game.

No game files are edited. Remove the mod and the interface returns to normal.

---

## Screenshots

The **Images** tab shows the inventory at **100%**, **80%** and **60%**, plus the
crafting menu at **60%**.

---

## Requirements

- **UE4SS** installed in `SCUM\Binaries\Win64`
- SCUM launched with **`-nobattleye -fileopenlog`**
- A recent **UE4SS 3.x** build (tested with **3.0.1**)
- Single-player or private servers only

UE4SS is a separate project and is **not** included in this download. Install it
from the official UE4SS releases first:
<https://github.com/UE4SS-RE/RE-UE4SS/releases>

---

## Installation

1. Install **UE4SS** and check that it loads.
2. Extract this mod's zip into:

   ```
   SCUM\Binaries\Win64
   ```

   The zip already contains the correct `ue4ss\Mods\SCMW_UIScale` folders.

3. Open:

   ```
   SCUM\Binaries\Win64\ue4ss\Mods\mods.txt
   ```

   Add this line:

   ```
   SCMW_UIScale : 1
   ```

4. Launch SCUM from a shortcut that uses:

   ```
   -nobattleye -fileopenlog
   ```

   Steam's normal **Play** button does not load UE4SS.

5. Open the inventory and use the keys above.

**Vortex:** this release is tested with a manual install. If Vortex handles archive
installs for SCUM, check that the files land in `ue4ss\Mods\SCMW_UIScale`;
otherwise use the manual steps above.

---

## Saved setting

Your chosen size is stored here:

```
%LOCALAPPDATA%\SCUM\Saved\SCMW_UIScale.txt
```

It is per Windows user and survives game updates. Delete the file to start at **100%** again.

---

## Uninstall

- Set `SCMW_UIScale : 0` in `ue4ss\Mods\mods.txt`, **or**
- delete the `ue4ss\Mods\SCMW_UIScale` folder.

The interface returns to normal on the next launch. Nothing else is changed.

---

## Compatibility

- **Tested on:** SCUM 1.3.4.2 (build 25804202) with UE4SS 3.0.1
- **Client-side only.** It changes your own interface; it does not change the game world or other players.
- **Game updates:** UE4SS may need an update after a SCUM patch. If the mod stops loading, update UE4SS first.
- **Official servers:** not usable, because UE4SS needs BattlEye off.

---

## Troubleshooting

After launching, open:

```
SCUM\Binaries\Win64\ue4ss\UE4SS.log
```

Look for lines starting with `[SCMW]`. They show:

- the loaded version,
- the saved scale,
- the applied scale,
- any file or settings error.

If the keys do nothing:

1. Check that UE4SS loaded at all.
2. Check that SCUM was started with `-nobattleye -fileopenlog`.
3. Check that `SCMW_UIScale : 1` is in `mods.txt`.

---

## Source and licence

The source is available on GitHub:

https://github.com/scummoddingworkshop-byte/SCMW-UI-Scale

The project is licensed under the **MIT License**: you may use, modify and
redistribute it, including commercially, as long as the copyright notice and the
licence text are kept.

**Attribution is the only requirement.** Please link back to this page instead
of reuploading the compiled zip unchanged.

---

## Credits

- **Fran (SCMW)** — project owner and testing
- **UE4SS** — the Lua mod loader
- **SCUM** — Gamepires / Jagex

---

## Changelog

### 1.0.0 — 26 October 2026

- First release.
- Adjustable UI scale with **Ctrl + − / Ctrl + +**, in 10-point steps.
- **Ctrl + 0** resets to 100%.
- Number-pad keys supported.
- The chosen size is saved between sessions.
- Works in the inventory, crafting, HUD and main menus.
- No game files are edited.

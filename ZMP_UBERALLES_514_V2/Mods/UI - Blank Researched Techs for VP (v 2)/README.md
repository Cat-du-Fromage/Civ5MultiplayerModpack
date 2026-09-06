# UI - Blank Researched Techs for VP

Blanks out already-researched techs in the tech tree: their portrait and their small
unlock icons are not drawn, and the card collapses back to its normal height.

**v2** — researched cards now shrink back to the standard 60px height. In v1 a card that
had been given the tall 6–10 icon layout kept that height after it was blanked, leaving
double-height empty gold boxes.

**Why:** Civ5 is a 32-bit executable and dies somewhere around the 4 GB mark. The tech
tree is one of the heaviest UI screens in the game, and "CTD when opening the tech tree"
is a report that goes back years. From the Industrial era on, most of the tree is already
researched — those icons cost memory and draw calls for information you no longer need.

The same behaviour ships in the VoxPopuli Modpacks — [where it came up](https://forums.civfanatics.com/threads/voxpopuli-modpacks-update-4-22.685164/page-29).
I don't know who originally wrote it there; if that's you, say so and I'll credit you.
This is an independent implementation, patched into `(3a)`'s tech tree — same idea, not
the same code.

I have **not** measured the memory saving and can't promise it fixes anyone's crashes.
It just draws a lot less.

For context, the modpack maintainer's answer when a user reported the blank cards as a bug:

> "It's a recently added feature. Removing icons reduces the load on memory hence the
> likelyhood of crash to desktop in late game (industrial era and onwards)."
> — jarcast2, [VoxPopuli Modpacks thread, post #563](https://forums.civfanatics.com/threads/voxpopuli-modpacks-update-4-22.685164/page-29)

Background on the crash theory:
[Improved TechTree Screen for VP/EUI](https://forums.civfanatics.com/threads/improved-techtree-screen-for-vp-eui.680641/)

---

## Install

Drop the whole `UI - Blank Researched Techs for VP (v 2)` folder into:

```
<Documents>/My Games/Sid Meier's Civilization 5/MODS/
```

Enable it in Mods alongside your usual VP list. Nothing else to do — no cache clearing,
no file overwriting.

**Requires** `(3a) VP - EUI Compatibility Files`. It is declared as a hard dependency so
the game always loads this mod *after* it; that ordering is what lets it replace
`ImprovedTechTree/TechTree.lua`.

Safe to add to or remove from an in-progress save: UI only, `AffectsSavedGames=0`,
no database changes, no gamecore changes.

## Turning it off without disabling the mod

Line ~32 of `ImprovedTechTree/TechTree.lua`:

```lua
local hideResearchedTechIcons = true
```

Set it to `false` for the vanilla look. Takes effect on game restart. (Editing the file
changes its checksum, so you'll need to delete `<My Games>/Sid Meier's Civilization 5/cache/`
and re-enable your mods after doing this.)

---

## If the override doesn't take

Civ5 resolves two mods importing the same filename by load order, and load order is
occasionally unreliable. If the tech tree still looks stock with the mod enabled:

1. Disable this mod.
2. Back up `MODS/(3a) VP - EUI Compatibility Files/ImprovedTechTree/TechTree.lua`.
3. Copy this mod's `ImprovedTechTree/TechTree.lua` over it.
4. Delete `<My Games>/Sid Meier's Civilization 5/cache/` and re-enable your mod list.

`HideResearchedTechIcons.patch` in this folder is the same change as a unified diff, for
anyone on a different version of `(3a)` who needs to apply it by hand.

---

## What it actually changes

Five hunks in `ImprovedTechTree/TechTree.lua` (the psparky/bc1 EUI tech tree). Nothing
else in the 772-line file is touched.

**1.** New option in the "Options for VP" block near the top:

```lua
local hideResearchedTechIcons = true
```

**2.** In `RefreshDisplayOfSpecificTech`, replacing the "Rebuild the small buttons if
needed" block. For a researched tech it skips `AddSmallButtonsToTechButton` entirely — so
no icon lookups and no `IconHookup` calls happen at all — and hides `StuffBox` (the
container holding B1–B10) plus the portrait:

```lua
	-- Rebuild the small buttons if needed
	local bBlankOut = hideResearchedTechIcons and g_activeTeamTechs:HasTech( techID )
	if bBlankOut then
		-- Already researched: skip AddSmallButtonsToTechButton entirely (no icon
		-- lookups, no IconHookup calls) and hide the icon strip and the portrait.
		thisTechButton.StuffBox:SetHide( true )
		thisTechButton.TechPortrait:SetHide( true )
	else
		if g_NeedsFullRefresh then
			AddSmallButtonsToTechButton( thisTechButton, tech, g_maxSmallButtons, 45, g_activePlayerID)
		end
		thisTechButton.StuffBox:SetHide( false )
		thisTechButton.TechPortrait:SetHide( not thisTechButton.HasPortrait )
	end
```

**3.** A new `SetTechCardHeight( thisTechButton, iCard, iFrame, iStuffBox )` helper above
`RefreshDisplayOfSpecificTech`, which sets the height of all 21 layers of a tech card in
one call. `60 / 64 / 38` are the XML defaults; `102 / 106 / 76` is the tall layout the
tree switches to for 6–10 unlock icons.

**4.** In the card-sizing block, a blanked card is collapsed back to the default height
instead of keeping the tall layout it was given while still unresearched:

```lua
	if bBlankOut then
		SetTechCardHeight( thisTechButton, 60, 64, 38 )
	elseif showLarge then
		...unchanged...
```

**5.** In the tech-button build loop, remember whether the portrait hooked up so the
`else` branch in hunk 2 can restore it correctly:

```lua
	-- picture
	-- (remembered so the portrait can be restored if hideResearchedTechIcons is off)
	thisTechButton.HasPortrait = IconHookup( tech.PortraitIndex, 64, tech.IconAtlas, thisTechButton.TechPortrait )
	thisTechButton.TechPortrait:SetHide( not thisTechButton.HasPortrait )
```

## Behaviour notes

- Tech names, era bars, research turns, queue numbers, right-click-to-Civilopedia and
  the hover tooltip all still work on researched techs. Only the pictures go away.
- Espionage view (looking at another civ's tree) blanks the techs **that civ** has, which
  is the useful behaviour — you see at a glance what they're missing.
- A tech researched mid-session is hidden on the next tree refresh, so its icons stay
  resident for that session. The benefit compounds as the tree fills in, and loading a
  late-game save gets the full effect immediately.
- Every researched card ends up at the same standard height, including techs that used
  the tall 6–10 icon layout before you researched them.

## Built and tested against

- `(1) Community Patch` v151, `(2) Vox Populi` v17, `(3a) VP - EUI Compatibility Files` v1
- Lua 5.1 syntax-checked (Civ5's Lua version); `.modinfo` XML validated.
- v1 confirmed working in-game. v2 adds the card-height collapse.

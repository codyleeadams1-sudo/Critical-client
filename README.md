# Critical Client (Fabric, Minecraft 26.3)

Red-themed survival QoL client. Press **Right Shift** in game to open the module menu.

## Build the .jar
Requirements: **JDK 25** and **Gradle 9.x** (or just open the folder in IntelliJ IDEA, which sets both up).

    gradle build

Your mod is `build/libs/criticalclient-1.0.0.jar` (ignore the `-sources` jar).
Drop it in `.minecraft/mods` together with **Fabric Loader 0.19.5+** and **Fabric API 0.160.5+26.3**.

No local setup? Push this folder to a GitHub repo - the included workflow (`.github/workflows/build.yml`)
builds the jar and attaches it as a downloadable artifact.

## Modules
Visuals: Fullbright, Zoom (hold C). HUD: Armor Durability, Tool Durability, Numbered Hotbar,
Coordinates, FPS Counter, Clock, Totem Counter. Movement: Auto Sprint.
Toggles are saved to `config/criticalclient.json`. Keybinds can be changed in Options > Controls.

## If the build complains
- Text sits a pixel high/low: adjust `"shift"` in `assets/criticalclient/font/ui.json` and `ui_bold.json`.
- Every Minecraft drawing call lives in `util/Gfx.java`, so any API rename is a one-file fix.

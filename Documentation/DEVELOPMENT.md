# Development and Contributing Guide

This guide covers setting up your local environment, building Kiko from the command line or Xcode, running tests, and debugging desktop pet behavior.

---

## 1. Prerequisites

- **macOS:** macOS 13.0 (Ventura) or newer (macOS 14 Sonoma / macOS 15 Sequoia recommended).
- **Swift:** Swift 5.9+ (Swift 6 compatible).
- **Xcode or Command Line Tools:** Xcode 15+ or Apple Command Line Tools.
- **Python 3:** Required for running the sprite extraction script (`scripts/slice_sprites.py`).

---

## 2. Quick Start

```bash
# 1. Clone repository
git clone https://github.com/rtomswastaken/kiko-desktop-pet.git
cd kiko-desktop-pet

# 2. Build the project
swift build

# 3. Run the unit test suite
swift test

# 4. Run Kiko locally
swift run Kiko
```

---

## 3. Setting Up Sprite Artwork

Because raw asset redistribution is prohibited by the creator's license, you must download the sprite sheet once:

1. Download `RetroCatsFree.png` from [ToffeeCraft on itch.io](https://toffeecraft.itch.io/cat-pack-pochi).
2. Save it to `assets/sprites/original/RetroCatsFree.png`.
3. Run the slice script:
   ```bash
   python3 scripts/slice_sprites.py
   ```
4. Verify the extracted frames in `assets/sprites/processed/`.

---

## 4. Opening in Xcode

To edit with Xcode's IDE features (code completion, debugger, visual canvas):
```bash
open Package.swift
```
Select the **Kiko** executable scheme and press `Cmd + R` to run.

---

## 5. Debugging Tips

### Visualizing Desktop Safe Areas
In `PetWindow.swift`, you can enable `debugDrawBounds = true` to draw a subtle colored border around Kiko's active collision boundaries and the display work area.

### Simulating Behaviors
You can force specific states via the status bar menu or in code:
```swift
// Force zoomies immediately
BehaviourEngine.shared.triggerZoomies()

// Force sleep mode
BehaviourEngine.shared.forceSleep()
```

### Checking CPU & Memory
Monitor Kiko's consumption using Activity Monitor or `top`:
```bash
top -pid $(pgrep Kiko) -stats pid,command,cpu,mem
```
Expected idle CPU is `< 0.5%`.

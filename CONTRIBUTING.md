# Contributing to Kiko 🐈

Thank you for your interest in making Kiko even more playful, charming, and chaotic! We welcome contributions ranging from bug fixes and performance improvements to new autonomous cat behaviours and animations.

---

## 🛠️ Getting Started

1. **Fork & Clone** the repository:
   ```bash
   git clone https://github.com/rtomswastaken/kiko-desktop-pet.git
   cd kiko-desktop-pet
   ```
2. **Setup Sprite Assets**:
   Download the free sprite pack `RetroCatsFree.png` from [ToffeeCraft on itch.io](https://toffeecraft.itch.io/cat-pack-pochi) and place it in:
   ```bash
   cp /path/to/RetroCatsFree.png assets/sprites/original/RetroCatsFree.png
   python3 scripts/slice_sprites.py
   ```
3. **Build and Test**:
   ```bash
   swift build
   swift test
   ```
4. **Open in Xcode** (optional):
   ```bash
   open Package.swift
   ```

---

## 📐 Architecture & Principles

Kiko is structured modularly across focused subsystems:

- **`Sources/App/`**: Application lifecycle, NSApplication delegate, and menu bar control.
- **`Sources/Core/`**: Pet state models, mood equations, personality traits, and energy levels.
- **`Sources/Animation/`**: Sprite playback engine, frame timer, and flip transforms.
- **`Sources/Behaviour/`**: Autonomous AI decision tree, roaming pathfinder, and zoomie triggers.
- **`Sources/Interaction/`**: Mouse tracking, draggable physics, petting gestures, and cursor reaction.
- **`Sources/Desktop/`**: Borderless floating window, multi-display support, and screen dock edge collisions.
- **`Sources/Audio/`**: Sound effects (purrs, meows, footsteps) via `NSSound` / `AVFoundation`.
- **`Sources/Settings/`**: User preferences, avatar selection, and speed toggles.

### Core Rules
- **Native Swift & AppKit**: No heavy third-party runtime dependencies; keep Kiko lightweight, battery-efficient, and fast.
- **Battery & CPU conscious**: Kiko should idle at under 1% CPU when sleeping or idle. Timer intervals should back off when stationary.
- **No asset piracy**: Never commit copyrighted third-party art assets without explicit redistribution licenses.

---

## 🧪 Testing Guidelines

- Always run `swift test` prior to opening a pull request.
- Add unit tests for any new behavior state, mood transition, or mathematical model under `Tests/`.
- Verify behavior across multiple screen resolutions and macOS display spaces if touching windowing code.

---

## 🌿 Git & Pull Request Workflow

1. Create a feature branch from `main`:
   ```bash
   git checkout -b feature/cardboard-box-sleep
   ```
2. Make atomic, well-described commits:
   ```bash
   git commit -m "feat(behaviour): add cardboard box exploration state"
   ```
3. Push to your fork and submit a Pull Request against `main`.
4. Ensure your PR description includes:
   - What changed and why.
   - Any visual impact (attach a GIF or screenshot if applicable).
   - Confirmation that all tests pass.

---

## 📋 Code of Conduct

Be kind, patient, and collaborative. Remember: we're building a joyful little companion for people's desktops.

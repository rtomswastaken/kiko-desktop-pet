# Contributing to Kiko

Thank you for your interest in making Kiko even more playful, charming, and chaotic! We welcome contributions ranging from bug fixes and performance improvements to new autonomous cat behaviours and animations.

---

## Getting Started

1. **Fork & Clone** the repository:
   ```bash
   git clone https://github.com/rtomswastaken/kiko-desktop-pet.git
   cd kiko-desktop-pet
   ```
2. **Build and Test**:
   ```bash
   swift build
   swift test
   ```
3. **Open in Xcode** (optional):
   ```bash
   open Package.swift
   ```

---

## Architecture & Principles

Kiko is structured modularly across focused subsystems:

- **Sources/Kiko/**: Application entry point (`main.swift`).
- **Sources/KikoCore/App/**: Application lifecycle, NSApplication delegate, and menu bar control.
- **Sources/KikoCore/Core/**: Pet state models, mood equations, personality traits, and energy levels.
- **Sources/KikoCore/Animation/**: Sprite playback engine, frame timer, and flip transforms.
- **Sources/KikoCore/Behaviour/**: Autonomous AI decision tree, roaming pathfinder, and zoomie triggers.
- **Sources/KikoCore/Interaction/**: Mouse tracking, draggable physics, petting gestures, and mini-games.
- **Sources/KikoCore/Desktop/**: Borderless floating window, multi-display support, and window titlebar detection.
- **Sources/KikoCore/Audio/**: Sound effects via `NSSound`.
- **Sources/KikoCore/Settings/**: User preferences, avatar selection, and speed toggles.

### Core Rules
- **Native Swift & AppKit**: No heavy third-party runtime dependencies; keep Kiko lightweight, battery-efficient, and fast.
- **Battery & CPU conscious**: Kiko should idle at under 0.5% CPU when sleeping or idle. Timer intervals back off when stationary.
- **No unnecessary emojis**: Use clean text formatting throughout the codebase and documentation.

---

## Testing Guidelines

- Always run `swift test` prior to opening a pull request.
- Add unit tests for any new behavior state, mood transition, or mathematical model under `Tests/`.
- Verify behavior across multiple screen resolutions and macOS display spaces if touching windowing code.

---

## Git & Pull Request Workflow

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
   - Any visual impact.
   - Confirmation that all tests pass.

---

## Code of Conduct

Be kind, patient, and collaborative. Remember: we are building a joyful little companion for people's desktops.

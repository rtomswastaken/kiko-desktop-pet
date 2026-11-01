<div align="center">

<img src="assets/branding/kiko-banner.png" alt="Kiko Desktop Pet Banner" width="100%" />

<br/><br/>

<img src="assets/branding/kiko-avatar.png" alt="Kiko Cat Avatar" width="140" height="140" />

# Kiko 🐈

**A little cat. A big personality.**

A tiny animated desktop companion that lives on your macOS desktop.

Kiko walks, sleeps, plays, follows your cursor, discovers cardboard boxes and occasionally gets zoomies.

<br/>

[![macOS](https://img.shields.io/badge/macOS-13.0%2B-blue?logo=apple&style=flat-square)](https://apple.com/macos)
[![Swift](https://img.shields.io/badge/Swift-5.9%20%7C%206.0-orange?logo=swift&style=flat-square)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen?style=flat-square)](#installation)

</div>

---

## 🌟 Features

Kiko is built from the ground up to feel like an authentic, low-maintenance desktop companion. Here is the current implementation status:

### Completed & Working
- **🐾 Animated Desktop Companion:** Runs as an ultra-lightweight, borderless, transparent floating window (`NSPanel`) that freely roams your displays without interrupting active applications.
- **🧠 Autonomous Cat Behaviours:** An intelligent tick-based state machine orchestrates natural feline behaviour—sitting upright, idling, wandering across the desktop, taking restorative naps, and bursting into sudden zoomies.
- **✨ Dynamic Moods & Personalities:** Mathematical meters track internal **Energy**, **Boredom**, and **Affection**, dynamically adjusting Kiko's mood between *Happy*, *Curious*, *Sleepy*, *Playful*, and *Chaotic*.
- **🖱️ Cursor Interaction & Following:** Kiko notices mouse movements, tracks your cursor across the screen, and creeps forward playfully when curious.
- **✋ Petting & Dragging by the Scruff:** Click and hold to pick Kiko up by the scruff, reposition him anywhere on screen with boundary clamping, and pet him to raise affection and happiness.
- **⚡ Native macOS Implementation:** 100% pure Swift, AppKit, and CoreAnimation. Zero heavy runtimes, no Electron bloat, maintaining under 0.5% idle CPU usage.

### In Development & Planned
- **📦 Cardboard Box Hiding & Sleeping:** Boxes spawning or dropped on the desktop that Kiko can climb into, hide within, and take long naps.
- **🪟 Window-Edge Sitting:** Detection of active application window titlebars so Kiko can sit or tightrope-walk along open app borders.
- **🎲 Random Cat Events:** Midnight knocks, keyboard stalking, and curiosity pounces.
- **🎮 Mini-Games:** Interactive laser pointer tracking mode and bouncing toy ball.
- **🎨 Multiple Cat Avatars:** In-app selection between Calico/Orange, Tabby Grey, Shadow Black, and Snow White coat variants.
- **🎀 Customization & Accessories:** Tiny pixel collars, bells, and holiday hats.

---

## 📸 Preview

<div align="center">

<img src="assets/branding/kiko-logo.png" alt="Kiko Character Logo" width="280" />

<p><em>Authentic pixel-art Kiko sitting frame extracted directly from the character sprite atlas.</em></p>

</div>

> [!NOTE]
> High-resolution gameplay GIFs and desktop screen recordings will be published in `assets/screenshots/` as interactive releases are packaged.

---

## 🚀 Installation & Building

### Requirements
- macOS 13.0 (Ventura) or newer (Sonoma & Sequoia fully supported)
- Apple Silicon (M1/M2/M3/M4) or Intel Mac
- Swift 5.9+ / Xcode 15+ (or Apple Command Line Tools)
- Python 3 (for local sprite slicing)

### 1. Clone the Repository
```bash
git clone https://github.com/rtomswastaken/kiko-desktop-pet.git
cd kiko-desktop-pet
```

### 2. Set Up Sprite Assets
Due to creator licensing restrictions, the raw sprite sheet is not redistributed in Git. Download the free asset pack and slice it locally:
1. Download `RetroCatsFree.png` from [ToffeeCraft on itch.io](https://toffeecraft.itch.io/cat-pack-pochi).
2. Place the image at:
   ```bash
   cp /path/to/download/RetroCatsFree.png assets/sprites/original/RetroCatsFree.png
   ```
3. Slice the individual frames:
   ```bash
   python3 scripts/slice_sprites.py
   ```

### 3. Build & Run
```bash
# Build with Swift Package Manager
swift build

# Launch Kiko
swift run Kiko
```

Alternatively, double-click `Package.swift` or run `open Package.swift` to launch directly in Xcode.

---

## 🛠️ Tech Stack

- **Language:** [Swift 5.9 / Swift 6](https://swift.org)
- **Windowing & Display:** [AppKit](https://developer.apple.com/documentation/appkit) (`NSPanel`, `NSStatusBar`, `CALayer`)
- **Animation & Graphics:** CoreAnimation with nearest-neighbor interpolation (`kCAFilterNearest`) for crisp Retina pixel art
- **State Machine:** Custom actor-isolated reactive state machine (`PetState`, `BehaviourEngine`)
- **Audio:** `AppKit.NSSound` and `AVFoundation`
- **Build System:** Swift Package Manager (SPM)

---

## 📁 Project Structure

```
kiko-desktop-pet/
│
├── README.md                      # Project overview & documentation
├── LICENSE                        # MIT License & Third-Party notice
├── .gitignore                     # Swift, Xcode, and asset exclusions
├── CONTRIBUTING.md                # Contribution guidelines
├── CHANGELOG.md                   # Release version history
├── Package.swift                  # Swift Package Manager manifest
│
├── assets/
│   ├── branding/                  # Repository branding & social assets
│   │   ├── kiko-avatar.png        # Crisp pixel-art avatar (512x512)
│   │   ├── kiko-logo.png          # High-resolution cat logo (800x800)
│   │   └── kiko-banner.png        # Social preview banner (1280x640)
│   │
│   ├── sprites/                   # Sprite management
│   │   ├── original/              # Raw sprite drop zone (excluded from Git)
│   │   ├── processed/             # Sliced 64x64 animation frames
│   │   └── sprite-mapping.md      # Coordinate atlas & bounding box map
│   │
│   └── screenshots/               # Application captures & demo GIFs
│
├── Sources/
│   ├── App/                       # Lifecycle & NSApplication entry
│   │   ├── KikoApp.swift          # @main entry struct
│   │   └── AppDelegate.swift      # Menu bar status item & action hooks
│   │
│   ├── Core/                      # Domain logic & models
│   │   ├── PetState.swift         # Reactive state & need meters
│   │   ├── Mood.swift             # Mood definitions & emoji states
│   │   ├── Personality.swift      # Configurable behavioral traits
│   │   └── Constants.swift        # Physics constants & timings
│   │
│   ├── Animation/                 # Sprite sequencing
│   │   ├── SpriteAnimation.swift  # Frame timer & ping-pong loop engine
│   │   ├── AnimationState.swift   # Animation state enums
│   │   └── SpriteManager.swift    # Asset loader & caching
│   │
│   ├── Behaviour/                 # Autonomous AI engine
│   │   ├── BehaviourEngine.swift  # Main update tick loop
│   │   ├── BehaviourType.swift    # Action goals (sitting, roaming, zoomies)
│   │   └── ActionPlanner.swift    # Probabilistic action selector
│   │
│   ├── Interaction/               # Mouse & gesture handling
│   │   ├── InteractionManager.swift # Drag & drop and petting detection
│   │   └── CursorFollower.swift   # Cursor tracking math
│   │
│   ├── Desktop/                   # macOS screen coordination
│   │   ├── PetWindow.swift        # Borderless transparent NSPanel
│   │   ├── ScreenManager.swift    # Multi-screen & Dock/MenuBar awareness
│   │   └── WindowLevelManager.swift # Always-on-top toggle
│   │
│   ├── Audio/                     # Sound subsystem
│   │   ├── SoundManager.swift     # Audio player
│   │   └── SoundEffect.swift      # Meow and purr sound cues
│   │
│   └── Settings/                  # User preferences
│       └── Preferences.swift      # Persistent UserDefaults storage
│
├── Tests/
│   └── KikoTests.swift            # Unit test suite
│
├── Documentation/
│   ├── ARCHITECTURE.md            # Subsystem architecture & data flow
│   ├── ANIMATIONS.md              # Frame details & Retina pixel art guide
│   ├── BEHAVIOUR.md               # AI state transitions & mood equations
│   └── DEVELOPMENT.md             # Developer environment setup & debugging
│
└── scripts/
    └── slice_sprites.py           # Automated sprite extraction script
```

---

## 🗺️ Roadmap

- [x] Repository identity, branding assets, and project architecture setup.
- [x] Swift Package Manager project configuration with modular subsystem structure.
- [x] Transparent borderless `PetWindow` implementation with Retina nearest-neighbor filtering.
- [x] Autonomous behaviour state machine (`sitting`, `wandering`, `sleeping`, `zoomies`).
- [x] Internal continuous meters for energy, boredom, and affection.
- [x] Mouse drag-and-drop and petting interaction handlers.
- [x] Frame animation sequencer with ping-pong sleep breathing loops.
- [ ] Cardboard box item spawning and sleeping integration.
- [ ] Active window edge and titlebar collision tracking.
- [ ] Multi-coat avatar selector UI in macOS settings menu.
- [ ] Sound synthesis for procedural purrs and meows.
- [ ] Homebrew Cask release packaging.

---

## 🤝 Contributing

We love contributions! Please review [CONTRIBUTING.md](CONTRIBUTING.md) for branch naming conventions, PR guidelines, and local testing instructions.

---

## 📄 License & Attribution

- **Code & Documentation:** Distributed under the **MIT License**. See [LICENSE](LICENSE) for details.
- **Third-Party Art Assets:** The original cat character artwork is from the **"Cat Pack - Pochi"** collection created by **ToffeeCraft** on [itch.io](https://toffeecraft.itch.io/cat-pack-pochi).
  - Free for personal game development and productions.
  - Raw asset redistribution or resale is strictly prohibited.
  - Raw sprite sheets are excluded from this repository and must be downloaded directly by users.

---

<div align="center">

*Made with curiosity, code and a little bit of cat chaos.*

</div>

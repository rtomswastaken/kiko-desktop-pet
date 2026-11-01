# Architecture of Kiko 🐈

Kiko is designed as a native, lightweight, and battery-friendly macOS desktop pet. It runs as a low-overhead menu-bar and floating-window application using Apple's modern Swift frameworks (AppKit, SwiftUI, and SpriteKit/CoreAnimation).

---

## High-Level Subsystems

```
┌─────────────────────────────────────────────────────────────┐
│                         KikoApp                             │
│       (NSApplication / MenuBarExtra / Lifecycle)            │
└──────────────────────────────┬──────────────────────────────┘
                               │
       ┌───────────────────────┼──────────────────────┐
       ▼                       ▼                      ▼
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│  PetWindow   │       │  Behaviour   │       │ Interaction  │
│  (Desktop)   │◄──────┤    Engine    │◄──────┤   Manager    │
│  NSWindow /  │       │ (State & AI) │       │ (Drag/Click) │
│ Transparent  │       └───────┬──────┘       └──────────────┘
└──────┬───────┘               │
       │                       ▼
       │               ┌──────────────┐       ┌──────────────┐
       │               │ Sprite Engine│       │ SoundManager │
       └──────────────►│ (Animation)  │       │   (Audio)    │
                       └──────────────┘       └──────────────┘
```

---

## Subsystem Breakdown

### 1. `Sources/App/`
- **Role:** Handles the macOS application lifecycle.
- **Components:**
  - `AppDelegate.swift`: Manages application startup, status bar item (menu bar cat icon), quit handlers, and global shortcuts.
  - `KikoApp.swift`: Main entry point binding the desktop window to the runtime state.

### 2. `Sources/Core/`
- **Role:** Pure domain models, pet health/happiness state, and math.
- **Components:**
  - `PetState.swift`: The central single source of truth (`position`, `velocity`, `currentMood`, `energy`, `hunger`).
  - `Mood.swift`: Enum and calculations for `happy`, `curious`, `sleepy`, `playful`, `chaotic` (zoomies).
  - `Personality.swift`: Configurable traits (e.g. lazy vs hyperactive, brave vs skittish).
  - `Constants.swift`: Physics constants, gravity, friction, desktop boundary offsets.

### 3. `Sources/Animation/`
- **Role:** Frame-accurate sprite rendering and playback.
- **Components:**
  - `SpriteAnimation.swift`: Controls frame sequences, FPS intervals, and forward/ping-pong looping.
  - `AnimationState.swift`: Identifies active animation (`idle`, `walk`, `sleep`, `dragged`, `petted`).
  - `SpriteManager.swift`: Loads processed 64×64 PNG textures, scales via nearest-neighbor to retain pixel-art sharpness, and manages horizontal orientation flipping.

### 4. `Sources/Behaviour/`
- **Role:** Autonomous AI state machine determining Kiko's next actions.
- **Components:**
  - `BehaviourEngine.swift`: Tick loop (runs at 10-20 Hz) deciding state transitions based on energy, time-of-day, and user inactivity.
  - `BehaviourType.swift`: Action goals (`sitting`, `wanderingTo(point)`, `chasingCursor`, `sleeping`, `zoomies`).
  - `ActionPlanner.swift`: Evaluates probability weights to select the next natural behaviour.

### 5. `Sources/Interaction/`
- **Role:** Input detection and mouse responsiveness.
- **Components:**
  - `InteractionManager.swift`: Coordinates mouse entered/exited, clicks, double clicks, and drag events.
  - `DraggablePet.swift`: Enables the user to pick up Kiko by the scruff and drop him anywhere on the desktop with realistic spring/gravity physics.
  - `CursorFollower.swift`: When in curious mode, Kiko gently follows the cursor or swats at it playfully.

### 6. `Sources/Desktop/`
- **Role:** Native macOS screen and window coordination.
- **Components:**
  - `PetWindow.swift`: Borderless, transparent, non-activating `NSPanel` with `.floating` or `.statusBar` level.
  - `ScreenManager.swift`: Multi-monitor detection, menu bar height calculation, and Dock avoidance.
  - `WindowLevelManager.swift`: Allows toggling whether Kiko stays on top of all windows or stays behind active applications.

### 7. `Sources/Audio/`
- **Role:** Gentle sound design.
- **Components:**
  - `SoundManager.swift`: Plays spatialized low-latency sound cues (meows, purrs when petted, tiny footsteps during zoomies).
  - `SoundEffect.swift`: Enum definitions with configurable volume and silence hours.

### 8. `Sources/Settings/`
- **Role:** User configurations and customization.
- **Components:**
  - `Preferences.swift`: Backed by `UserDefaults`, controlling pet skin, sound volume, scale factor (1x, 2x, 3x), and zoomie frequency.
  - `SettingsView.swift`: Clean SwiftUI settings window.

---

## Performance Targets

- **Idle CPU Usage:** < 0.5% when sleeping or sitting.
- **Active CPU Usage:** < 2.0% during walking or zoomies.
- **Memory Footprint:** < 35 MB total resident memory.
- **Display Overhead:** Zero GPU power draw when stationary via `CVDisplayLink` throttles.

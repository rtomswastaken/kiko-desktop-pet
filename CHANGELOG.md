# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- Cardboard box hiding and interactive toys.
- Window-edge balance walking and window docking.
- Multiple selectable cat skins (Orange, Grey, Black, White).
- Cat mini-games (laser pointer chase, mouse catching).

---

## [0.1.0] - 2026-11-01

### Added
- **Project Foundation:** Initial repository initialization and Swift Package Manager architecture for macOS 13.0+.
- **Branding Assets:** Pixel-art Kiko avatar (`kiko-avatar.png`), high-resolution repository logo (`kiko-logo.png`), and social preview banner (`kiko-banner.png`) extracted directly from authentic character sprite sheets.
- **Sprite Atlas:** Sliced processed sprite frames for sitting, walking, sleeping, and avatar color variants.
- **Architecture & Subsystems:**
  - `Core`: State models, mood metrics (`Happiness`, `Energy`, `Curiosity`), and personality profiles.
  - `Animation`: Frame-based sprite sequencer and animation state manager with directional flipping.
  - `Behaviour`: Autonomous state machine with idle, wandering, zoomies, and resting cycles.
  - `Desktop`: Transparent, click-through capable, borderless floating window engine.
  - `Interaction`: Click-to-drag, petting recognition, and cursor follower physics.
  - `Audio`: Audio subsystem interfaces for purrs, meows, and footstep sound effects.
  - `Settings`: User preference storage and toggle structures.
- **Documentation:**
  - Comprehensive `README.md` with visual branding, feature checklist, build steps, and tech stack.
  - `Documentation/ARCHITECTURE.md`: Subsystem overview and event flows.
  - `Documentation/ANIMATIONS.md`: Complete animation atlas and timing guide.
  - `Documentation/BEHAVIOUR.md`: AI state machine rules and probability matrices.
  - `Documentation/DEVELOPMENT.md`: Contributor setup and debugging guide.
  - `assets/sprites/sprite-mapping.md`: Coordinate atlas and bounding box documentation.
  - `assets/sprites/original/README.md`: Third-party asset licensing terms and download guide.

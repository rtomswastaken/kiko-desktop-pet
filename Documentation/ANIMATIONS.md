# Animation System & Sprite Specifications 🐈

Kiko relies on crisp, authentic pixel art derived from ToffeeCraft's retro cat collection. The animation system is engineered to honor retro pixel constraints while delivering smooth, characterful motion on modern Retina displays.

---

## 1. Pixel Art Rendering Principles

1. **Nearest-Neighbor Interpolation (`.nearest` / `kCAFilterNearest`):**
   - High-DPI Retina screens blur pixel art if linear interpolation is used.
   - All CALayers and SpriteKit nodes enforce nearest-neighbor filtering to keep pixel edges sharp.
2. **Integer Scaling:**
   - Default desktop scale is **2×** (128×128 pt window) or **3×** (192×192 pt window).
   - Non-integer scaling factors (e.g. 1.7×) are prohibited to avoid pixel distortion and uneven edges.
3. **Bottom-Center Anchoring:**
   - Anchor point is fixed at `(0.5, 0.0)` (bottom-center) so horizontal flips do not cause the cat to slide or jump.

---

## 2. Animation Sequences

### 1. Sitting / Idle (`kiko_sit`)
- **Row:** 0
- **Frame Count:** 4 frames (`kiko_sit_0.png` through `kiko_sit_3.png`)
- **Base Dimensions:** 64 × 64 px (Sprite content: 41 × 45 px)
- **Frame Rate:** 4.0 fps (250 ms per frame)
- **Playback Mode:** Continuous forward loop
- **Visual Description:**
  - Frame 0: Standard sitting posture, head upright, tail resting.
  - Frame 1: Gentle inhale, chest expansion.
  - Frame 2: Exhale with slight tail twitch.
  - Frame 3: Soft blink and tail curl.

### 2. Walking / Wandering (`kiko_walk`)
- **Row:** 1
- **Frame Count:** 2 frames (`kiko_walk_0.png`, `kiko_walk_1.png`)
- **Base Dimensions:** 64 × 64 px (Sprite content: 47 × 46 px)
- **Frame Rate:** 7.0 fps (~142 ms per frame)
- **Playback Mode:** Continuous forward loop
- **Movement Speed:** 60 points / second across the screen
- **Visual Description:**
  - Alternating paw stride with bouncing tail.

### 3. Sleeping / Loaf (`kiko_sleep`)
- **Row:** 2
- **Frame Count:** 4 frames (`kiko_sleep_0.png` through `kiko_sleep_3.png`)
- **Base Dimensions:** 64 × 64 px (Sprite content: 60 × 44 px)
- **Frame Rate:** 2.5 fps (400 ms per frame)
- **Playback Mode:** Ping-pong loop (0 → 1 → 2 → 3 → 2 → 1 → 0)
- **Visual Description:**
  - Cat curled into a loaf, rhythmic deep breathing with chest rise and fall.

### 4. Dragged / Picked Up (`kiko_dragged`)
- **Visual Description:**
  - Cat suspended by the scruff, paws hanging down, slight sway reacting to mouse acceleration.

### 5. Zoomies (`kiko_zoomies`)
- **Frame Sequence:** Rapid alternation of `kiko_walk` with double speed (14 fps), interspersed with sudden stops and 180° directional changes.
- **Movement Speed:** 280 points / second.

---

## 3. Directional Flipping

Because sprites naturally face **left**, horizontal movement uses a transform matrix:
```swift
// Facing left (original direction)
imageView.layer?.transform = CATransform3DIdentity

// Facing right (mirrored)
imageView.layer?.transform = CATransform3DMakeScale(-1.0, 1.0, 1.0)
```

---

## 4. Asset Pipeline

Original sprite sheets are processed into individual frames via `scripts/slice_sprites.py`:
```
Assets/RetroCatsFree.png
       │
       ▼ (scripts/slice_sprites.py)
assets/sprites/processed/
       ├── kiko_sit_0.png .. kiko_sit_3.png
       ├── kiko_walk_0.png .. kiko_walk_1.png
       ├── kiko_sleep_0.png .. kiko_sleep_3.png
       └── kiko_variant_*.png
```

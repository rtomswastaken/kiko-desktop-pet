# Animation System & Sprite Specifications 🐈

Kiko relies on authentic pixel art derived from ToffeeCraft's retro cat collection (`RetroCatsFree.png`). The animation system is engineered to honor retro pixel constraints while delivering smooth, characterful motion on modern Retina displays.

---

## 1. Pixel Art Rendering Principles

1. **Nearest-Neighbor Interpolation (`.nearest` / `kCAFilterNearest`):**
   - High-DPI Retina screens blur pixel art if linear interpolation is used.
   - All CALayers enforce nearest-neighbor filtering to keep pixel edges crisp and sharp.
2. **Integer Scaling:**
   - Supported desktop scales: **1×** (64×64 pt), **1.5×** (96×96 pt), **2×** (128×128 pt default), and **3×** (192×192 pt).
3. **Elastic Squash & Stretch:**
   - Real-time `CATransform3DScale` and `CATransform3DRotate` during mouse drag.
   - Gentle vertical stretch when picked up (`scaleX: 0.90, scaleY: 1.15`).
   - Wiggle flail (`sin(wigglePhase) * 0.18`) during fast dragging.
   - Soft landing bounce recovery on release.

---

## 2. Animation Sequences

### 1. Sitting / Idle (`sit`)
- **Frames:** 4 frames (`sit_0` through `sit_3`)
- **Frame Rate:** 4.0 fps (280 ms per frame)
- **Playback Mode:** Continuous forward loop
- **Visual Description:** Standard sitting posture, gentle inhale, tail twitch, and blinking eyes.

### 2. Walking (`walk`)
- **Frames:** 2 frames (`walk_0`, `walk_1`)
- **Frame Rate:** ~7.0 fps (150 ms per frame)
- **Playback Mode:** Continuous forward loop
- **Movement Speed:** ~70 points / second across the screen. Alternating paw stride.

### 3. Running / Zoomies (`run`)
- **Frames:** 2 frames (`walk_0`, `walk_1`) at double speed (0.08s per frame)
- **Movement Speed:** 140 to 320 points / second across the screen.

### 4. Sleeping / Loaf (`sleep`)
- **Frames:** 4 frames (`sleep_0` through `sleep_3`)
- **Frame Rate:** 2.5 fps (420 ms per frame)
- **Playback Mode:** Ping-pong loop (0 → 1 → 2 → 3 → 2 → 1 → 0)
- **Visual Description:** Cat curled into a loaf, rhythmic deep breathing with chest rise and fall. Accompanied by floating `fx_zzz.png` particles.

### 5. Stretching (`stretch`)
- **Frames:** 3 frames (`stretch_0` through `stretch_2`)
- **Frame Rate:** ~3.0 fps (350 ms per frame)
- **Visual Description:** Full body stretch extending front paws and arching back after naps.

### 6. Climbing / High Reach (`climb`)
- **Frames:** 1 frame (`kiko_climb.png`)
- **Visual Description:** Standing on hind legs reaching up toward window title bar or scratch tree.

### 7. Cardboard Box Peeking & Head-Out
- **Frames:** 
  - `cardboard_box_peeking.png`: Two glowing curious eyes peeking from dark box opening.
  - `*_box_head_out.png`: Cat head and front paws resting over the cardboard rim.

---

## 3. Multiple Cat Avatars

The application includes 4 distinct cat breeds/avatars, each with their own matching animation set:

| Avatar | Key | Description | Default Personality |
|---|---|---|---|
| **Kiko** | `kiko` | Ginger Tabby | Energetic, curious, cuddly |
| **Smokey** | `smokey` | Grey / Silver Tabby | Lazy, sleepy, relaxed |
| **Kuro** | `kuro` | Midnight Black Void | Mischievous, quick, independent |
| **Mochi** | `mochi` | Snow White | Playful, affectionate, sweet |

---

## 4. Desktop Toys & Particle Sprites

- **Yarn Balls:** 8 retro colors (`yarn_ball_0.png` through `yarn_ball_7.png`) with physics bounces.
- **Butterfly:** 2-frame wing-flapping animation (`butterfly_0.png`, `butterfly_1.png`).
- **Fish Treat:** Savory fish snack (`fish_treat.png`).
- **Laser Dot:** Red glowing dot (`laser_dot.png`).
- **Particles:** Floating heart (`fx_heart.png`), sleepy Zzz (`fx_zzz.png`), and sparkles (`fx_sparkle.png`).

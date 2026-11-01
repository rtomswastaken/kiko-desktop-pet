# Animation System and Sprite Specifications

Kiko relies on authentic 32x32 pixel art with the midnight Black Cat as the primary companion. The animation system is engineered to honor retro pixel constraints while delivering smooth, characterful motion on modern Retina displays.

---

## 1. Pixel Art Rendering Principles

1. **Nearest-Neighbor Interpolation (`.nearest` / `kCAFilterNearest`):**
   - High-DPI Retina screens blur pixel art if linear interpolation is used.
   - All CALayers enforce nearest-neighbor filtering to keep pixel edges crisp and sharp.
2. **Integer Scaling:**
   - Supported desktop scales: **1x** (32x32 pt), **2x** (64x64 pt), **3x** (96x96 pt), and **4x** (128x128 pt).
3. **Elastic Squash & Stretch:**
   - Real-time `CATransform3DScale` and `CATransform3DRotate` during mouse drag.
   - Gentle vertical stretch when picked up (`scaleX: 0.90, scaleY: 1.15`).
   - Wiggle flail during fast dragging.
   - Soft landing bounce recovery on release.

---

## 2. Animation Sequences

All cat animations are 32x32 pixel art strips:

| Action | Frame Count | Timing | Playback Mode | Description |
|---|---|---|---|---|
| **Sitting** | 3 frames | 0.28s / frame | Forward Loop | Cat sitting upright, gentle tail twitch, watchful eyes. |
| **Idle** | 7 frames | 0.20s / frame | Forward Loop | Standing idle, blinking, tail swaying, looking around. |
| **Idle2** | 14 frames | 0.18s / frame | Forward Loop | Detailed grooming, licking paws, sniffing the air. |
| **Run** | 7 frames | 0.10s / frame | Forward Loop | Four-paw gallop across the desktop during roaming and zoomies. |
| **Jump** | 13 frames | 0.08s / frame | Triggered | Full leaping arc onto window titlebars, cat beds, and desk borders. |
| **Attack** | 9 frames | 0.10s / frame | Triggered | Pouncing and batting at laser dots, yarn balls, and treats. |
| **Hurt / Drag** | 7 frames | 0.14s / frame | Continuous | Picked up by the scruff, suspended paws reacting to cursor motion. |
| **Sleep** | 3 frames | 0.45s / frame | Ping-Pong Loop | Curled into a loaf, rhythmic deep breathing with chest rise. |
| **Die / Flop** | 15 frames | 0.12s / frame | Triggered | Dramatic playful flop onto back with belly exposed. |
| **Die2** | 14 frames | 0.12s / frame | Triggered | Dramatic flop variation, sprawling out flat on the desktop. |

---

## 3. Multiple Cat Avatars

The application includes 13 distinct cat breeds and costumes, with the midnight Black Cat as default:

| Avatar | Key | Description |
|---|---|---|
| **Black Cat (Kiko)** | `blackcat` | Sleek midnight black cat with golden glowing eyes and swift reflexes (Default). |
| **Ginger** | `ginger` | Cheerful orange tabby who loves jumping on windows and chasing toys. |
| **Calico** | `calico` | Lucky three-color calico with a sweet, curious disposition. |
| **White Cat (Mochi)** | `whitecat` | Snowy white cat who loves head pats and warm naps. |
| **Brown Cat** | `browncat` | Relaxed, cuddly brown cat who loves loafing. |
| **Siamese** | `siamese` | Elegant Siamese cat with inquisitive bright eyes. |
| **Tiger** | `tiger` | Striped tiger cat always ready for pounces and zoomies. |
| **Astronaut** | `astronaut` | Space-faring cat equipped with an authentic astronaut suit. |
| **Batcat** | `batman` | Masked desktop hero watching from window ledges. |
| **Little Demon** | `demon` | Horned troublemaker packed with chaotic zoomie energy. |
| **Santa Cat** | `santa` | Festive holiday cat spreading cozy winter cheer. |
| **Vampire** | `vampire` | Spooky creature of the night who loves sleeping in shadows. |
| **Witch** | `witch` | Magical feline companion complete with witchy robes. |

---

## 4. Desktop Toys and Fixtures

- **Cat Beds:** 6 pastel color variations (`CatBedBlue`, `CatBedPink`, `CatBedGreen`, `CatBedPurple`, `CatBedBrown`, `CatBedRed`).
- **Interactive Props:** Food bowl, bath tub, fish treat snack, and yarn ball.

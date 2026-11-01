# Sprite Mapping & Animation Atlas

This document outlines the frame mappings, bounding boxes, animation frame rates, and state triggers for **Kiko** and desktop interactive objects.

---

## 1. Source Sheet Specifications

- **Asset Pack:** Cat Pack - Pochi
- **Artist / Creator:** ToffeeCraft ([itch.io profile](https://toffeecraft.itch.io/cat-pack-pochi))
- **File:** `RetroCatsFree.png`
- **Total Dimensions:** 256 × 435 pixels
- **Grid Layout:** 4 columns × 64 pixels wide
- **Color Depth:** 32-bit RGBA pixel art
- **Default Frame Dimensions:** 64 × 64 pixels

---

## 2. Animation Matrix

| State | Row | Frames | Cell Dimensions | Frame Duration | Loop Mode | Description |
|---|---|---|---|---|---|---|
| **Idle / Sit** | Row 0 (`y: 0..64`) | 4 (`col: 0..3`) | 64 × 64 px | 250ms (4 fps) | Forward Loop | Cat sitting upright, subtle breathing, tail curl and blinking. |
| **Walk / Roam** | Row 1 (`y: 64..128`) | 2 (`col: 0..1`) | 64 × 64 px | 140ms (~7 fps) | Forward Loop | Forward walking cycle, alternates front and back paws. |
| **Sleep** | Row 2 (`y: 128..192`) | 4 (`col: 0..3`) | 64 × 64 px | 400ms (2.5 fps) | Ping-Pong Loop | Cat curled into a loaf, slow breathing cycle. |
| **Variants** | Row 3 (`y: 192..256`) | 4 (`col: 0..3`) | 64 × 64 px | Static / Base | N/A | Color variations: Grey (0), Orange/Calico (1), Black (2), White (3). |

---

## 3. Frame Bounding Boxes

To ensure crisp collision detection and window positioning, the active cat bounding box inside each 64×64 cell is measured below:

| Frame Name | Cell Rect (`x, y, w, h`) | Opaque Bounding Box | Width × Height | Anchor Point (`x, y`) |
|---|---|---|---|---|
| `kiko_sit_0` | `(0, 0, 64, 64)` | `(12, 18, 53, 63)` | 41 × 45 px | `(32, 63)` (bottom center) |
| `kiko_sit_1` | `(64, 0, 64, 64)` | `(12, 19, 53, 63)` | 41 × 44 px | `(32, 63)` |
| `kiko_sit_2` | `(128, 0, 64, 64)` | `(12, 19, 53, 63)` | 41 × 44 px | `(32, 63)` |
| `kiko_sit_3` | `(192, 0, 64, 64)` | `(12, 18, 53, 63)` | 41 × 45 px | `(32, 63)` |
| `kiko_walk_0` | `(0, 64, 64, 64)` | `(1, 18, 48, 64)` | 47 × 46 px | `(24, 64)` |
| `kiko_walk_1` | `(64, 64, 64, 64)` | `(2, 19, 48, 64)` | 46 × 45 px | `(24, 64)` |
| `kiko_sleep_0` | `(0, 128, 64, 64)` | `(2, 20, 62, 64)` | 60 × 44 px | `(32, 64)` |
| `kiko_sleep_1` | `(64, 128, 64, 64)` | `(2, 13, 62, 64)` | 60 × 51 px | `(32, 64)` |
| `kiko_sleep_2` | `(128, 128, 64, 64)` | `(2, 7, 62, 64)` | 60 × 57 px | `(32, 64)` |
| `kiko_sleep_3` | `(192, 128, 64, 64)` | `(2, 13, 62, 64)` | 60 × 51 px | `(32, 64)` |

---

## 4. Direction & Flipping

Kiko's default sprite frames face **left / forward 3/4**.
- **Facing Left:** Normal horizontal orientation (`CGAffineTransform.identity`).
- **Facing Right:** Horizontal reflection (`CGAffineTransform(scaleX: -1, y: 1)`).
- Anchor point stays pinned to bottom-center of the sprite frame so flipping does not shift the cat's ground contact position.

---

## 5. Licensing Note

The raw spritesheet `RetroCatsFree.png` is provided by ToffeeCraft under a personal, non-redistribution license. It is excluded from the Git repository. For details, refer to [`assets/sprites/original/README.md`](file:///Users/rtoms/Documents/antigravity/valiant-hubble/assets/sprites/original/README.md).

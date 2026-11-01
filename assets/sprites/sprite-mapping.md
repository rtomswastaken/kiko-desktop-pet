# Sprite Mapping and Animation Atlas

This document outlines the frame mappings, bounding boxes, animation frame rates, and state triggers for **Kiko** using the complete **`kiko_cat_sprites`** collection and desktop interactive objects.

---

## 1. Asset Specifications

- **Asset Source:** `kiko_cat_sprites`
- **Native Frame Dimensions:** 32 × 32 pixels per frame
- **Layout:** Horizontal animation strips of uniform 32×32 pixel cells
- **Color Depth:** 32-bit RGBA pixel art
- **Scaling:** Nearest-Neighbor (`kCAFilterNearest`) at 2× (64pt), 3× (96pt), or 4× (128pt)

---

## 2. Animation Matrix & Functional Mapping

| Action | Frame Count | Strip Size | Frame Duration | Loop Mode | In-App Behaviour & Function |
|---|---|---|---|---|---|
| **`Sitting`** | 3 frames | 96 × 32 px | 220ms | Ping-Pong Loop | Stationary calm sitting posture on desktop or window ledge |
| **`Idle`** | 7 frames | 224 × 32 px | 140ms | Forward Loop | Subtle breathing, ear twitch, and blinking eyes |
| **`Idle2`** | 14 frames | 448 × 32 px | 110ms | Forward Loop | Curious head turn, paw lick, and body stretch |
| **`Run`** | 7 frames | 224 × 32 px | 85ms | Forward Loop | Walking, running across desktop, stalking cursor, and zoomies |
| **`Jump`** | 13 frames | 416 × 32 px | 75ms | Single Trigger | Leaping onto window title bars, pouncing at laser dots |
| **`Attack`** | 9 frames | 288 × 32 px | 80ms | Single Trigger | Playful swatting / batting at yarn balls, laser pointer, and butterflies |
| **`Hurt`** | 7 frames | 224 × 32 px | 100ms | Single Trigger | Surprised / startled recoil when clicked, dragged, or startled |
| **`Sleep`** | 3 frames | 96 × 32 px | 350ms | Ping-Pong Loop | Curled loaf snoozing on desktop or in cat bed with Zzz bubbles |
| **`Die` / `Die2`**| 14-15 frames| 448 × 32 px | 90ms | Single Trigger | Dramatic flop! Cat suddenly falls over and plays dead |

---

## 3. Supported Cat Avatars & Costumes

Every avatar includes its complete suite of matching 32×32 action strips:

### Natural Cat Breeds:
1. **`Ginger`** (`ginger_`): Default Kiko orange tabby.
2. **`BlackCat`** (`blackcat_`): Midnight void Kuro.
3. **`Calico`** (`calico_`): Tri-color calico.
4. **`WhiteCat`** (`whitecat_`): Snowy white Mochi.
5. **`BrownCat`** (`browncat_`): Chocolate brown tabby.
6. **`Siamese`** (`siamese_`): Point-colored Siamese.
7. **`Tiger`** (`tiger_`): Striped golden tiger cat.

### Costumes & Themes:
8. **`Astronaut`** (`astronaut_`): Space explorer in pressurized suit.
9. **`Batman`** (`batman_`): Dark Knight masked defender.
10. **`Demon`** (`demon_`): Tiny horned mischief-maker.
11. **`Santa`** (`santa_`): Festive holiday red coat and hat.
12. **`Vampire`** (`vampire_`): Cloaked nocturnal count.
13. **`Witch`** (`witch_`): Robed spellcaster.

---

## 4. Resting Fixtures & Desktop Items

- **Cozy Cat Beds:**
  - `cat_bed_blue.png` (64 × 64 px)
  - `cat_bed_brown.png` (64 × 64 px)
  - `cat_bed_green.png` (64 × 64 px)
  - `cat_bed_pink.png` (64 × 64 px)
  - `cat_bed_purple.png` (64 × 64 px)
  - `cat_bed_red.png` (64 × 64 px)
- **Classic Cardboard Box:**
  - `cardboard_box_empty.png`, `cardboard_box_peeking.png`, `cardboard_box_head_out.png`
- **Interactive Items:**
  - `bowl.png` & `cat_food.png`
  - `heart.png` & `fx_heart.png`
  - `laser_dot.png`, `yarn_ball_0..7.png`, `butterfly_0..1.png`, `fish_treat.png`

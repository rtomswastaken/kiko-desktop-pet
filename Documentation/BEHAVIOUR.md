# Autonomous Behaviour & Mood System 🐈

Kiko is driven by an autonomous finite-state machine (FSM) that models realistic feline psychology, mood transitions, energy cycles, and environment awareness.

---

## 1. Finite-State Machine (FSM)

The cat transitions naturally between these 17 states:

```
┌──────────────────────────────────────────────────────────────┐
│                            IDLE                              │
│                (Sitting, blinking, breathing)                │
└──────┬──────────────┬──────────────┬──────────────┬──────────┘
       │              │              │              │
       ▼              ▼              ▼              ▼
┌──────────────┐┌──────────────┐┌──────────────┐┌──────────────┐
│   WALKING    ││   CURIOUS    ││   PLAYFUL    ││   SLEEPING   │
│  (Exploring) ││(Watching Win)││(Chasing Mouse││(Warm Loaf)   │
└──────┬───────┘└──────────────┘└──────┬───────┘└──────┬───────┘
       │                               │               │
       ▼                               ▼               ▼
┌──────────────┐                ┌──────────────┐┌──────────────┐
│WINDOW_WATCHING                │   PLAYING    ││  STRETCHING  │
│(Perched top) │                │ (Yarn/Laser) ││(Wakeup pose) │
└──────────────┘                └──────────────┘└──────────────┘
```

### Full State Catalog:
- **`IDLE`**: Upright sitting posture, soft breathing, tail twitches, periodic blinks.
- **`WALKING`**: Navigates across screen or window ledge towards random or target coordinates.
- **`RUNNING`**: Brisk walk cycle at 2x speed.
- **`PLAYFUL`**: Investigates and stalks moving mouse cursor or desktop toys.
- **`CURIOUS`**: Pauses and observes active application windows or cursor.
- **`SLEEPING`**: Curled into a loaf with gentle snoozing sound and `Zzz` bubbles.
- **`HIDING`**: Inside cardboard box with two glowing eyes peeking out.
- **`BOX_IDLE`**: Resting in cardboard box with head and paws over the front edge.
- **`STRETCHING`**: Extends front paws and arches back after waking up.
- **`PLAYING`**: Chasing the yarn ball, laser pointer, or butterfly.
- **`WATCHING_CURSOR`**: Sits in place tracking the cursor angle.
- **`SURPRISED`**: Brief recoil and startle reaction.
- **`EXCITED (ZOOMIES)`**: Chaotic high-speed sprint across the desktop bouncing off edges.
- **`GRUMPY`**: Aloof mood where the cat ignores clicks or walks away.
- **`INTERACTING`**: Being petted by the user, emitting hearts.
- **`WINDOW_WATCHING`**: Resting on top edge / title bar of an application window.
- **`DRAGGED`**: Being carried by the mouse with elastic squash-and-stretch.

---

## 2. Dynamic Moods

Mood alters movement speed, transition probabilities, and animation cadence:

| Mood | Behavior Influence | Speed Multiplier |
|---|---|---|
| **Happy** | Frequent purrs, playful interactions, hearts | 1.1x |
| **Sleepy** | Slower movement, yawns, curls up to sleep | 0.65x |
| **Curious** | Investigates window borders and cursor motion | 0.95x |
| **Playful** | Stalks cursor, initiates toy chases | 1.35x |
| **Grumpy** | Occasionally ignores the user, turns away | 0.5x |
| **Excited** | Sudden zoomies sprint across desktop | 2.2x |
| **Bored** | Searches for something interesting or heads to box | 0.75x |
| **Scared** | Startled retreat into cardboard box | 2.5x |
| **Relaxed** | Peacefully loafs and watches the screen | 0.8x |

---

## 3. Cardboard Box System

The cardboard box is a dedicated desktop fixture:
1. **Discovery:** When bored or low on energy, the cat navigates toward the cardboard box.
2. **Entering:** Cat climbs inside; the window updates to `cardboard_box_peeking.png`.
3. **Inactivity Sleep:** If the user does not interact with the Mac for over 2 minutes, the cat automatically curls up in the box to sleep.
4. **Waking:** Moving the cursor near the box or clicking it prompts the cat to peek out (`*_box_head_out.png`) and emerge to play!

---

## 4. Window & Title-Bar Interaction

Using macOS Quartz Window Server APIs (`CGWindowListCopyWindowInfo`), the pet continuously detects visible application windows:
- **Title Bar Perching:** When walking near an open window (e.g. Safari, Terminal, Notes), the cat can jump up and sit directly on the title bar.
- **Window Ledge Walking:** Walks along the upper boundary of active windows.
- **Non-Interference:** Does not block window traffic lights or title bar drag controls.

---

## 5. Random Events

Cooldown-governed spontaneous events:
- **Zoomies:** Uncontrollable sprint across the display.
- **Butterfly Chase:** Butterfly flutters across screen; cat pursues.
- **Dreaming:** Sleep state with floating `Zzz` particles.
- **Tail Chasing:** Rapid 360° spin in place.
- **Dramatic Flop:** Abruptly drops into a warm loaf.
- **Random Meow:** Subtle audio chirp or meow.

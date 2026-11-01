# Behaviour Engine & AI State Machine 🐈

Kiko is not merely a looped GIF; Kiko acts autonomously based on internal needs, environmental stimuli, and random cat chaos.

---

## 1. Internal Need Meters

Kiko tracks three continuous scalar meters (`0.0` to `1.0`):

1. **Energy (`0.0` - Exhausted to `1.0` - Hyperactive):**
   - Depletes during walking (-0.02 / min) and zoomies (-0.15 / min).
   - Recovers during sleeping (+0.10 / min) and sitting (+0.03 / min).
   - When energy drops below `0.20`, sleep probability rises to 90%.
2. **Boredom (`0.0` - Content to `1.0` - Restless):**
   - Increases when Kiko remains in one location without user interaction (+0.05 / min).
   - Decreases when user pets, drags, or feeds Kiko.
   - High boredom triggers cursor tracking, wandering, or sudden zoomies.
3. **Affection (`0.0` - Aloof to `1.0` - Cuddly):**
   - Increases when user clicks or pets Kiko.
   - Unlocks affectionate purring, loafing close to the active mouse cursor, and greeting chirps.

---

## 2. State Transition Graph

```
           ┌──────────────┐
           │   Sleeping   │
           └──────▲───────┘
                  │  (Energy < 0.20)
                  │
┌─────────────────┼─────────────────┐
│                 ▼                 │
│          ┌──────────────┐         │
│          │ Sitting/Idle │         │
│          └──────▲───────┘         │
│                 │                 │
│ (Wander Timer)  │  (Boredom > 0.8)│
▼                 ▼                 ▼
┌──────────────┐  │         ┌──────────────┐
│  Wandering   │  │         │   Zoomies    │
└──────────────┘  │         └──────────────┘
                  │
                  │ (User Drag)
                  ▼
           ┌──────────────┐
           │   Dragged    │
           └──────────────┘
```

---

## 3. Behaviour Descriptions

### Sitting / Idle
- Default resting state.
- Kiko sits upright, blinks, and watches the cursor if it moves near.
- If stationary for more than 45 seconds, Kiko may curl up and sleep.

### Wandering
- Kiko picks a random destination on the current display work area (respecting Menu Bar and Dock boundaries).
- Calculates heading, flips sprite towards the destination, and walks at a leisurely pace.
- Upon arrival, pauses, sniffs the desktop air, and transitions back to idle.

### Cursor Stalking & Following
- Triggered when curiosity is high and the mouse cursor is moving smoothly.
- Kiko creeps toward the cursor, stops a polite 60 pixels away, and watches it move.

### The Zoomies
- Sudden, uncontrollable burst of feline energy.
- Kiko sprints back and forth across the screen at 4x normal speed, rebounding off screen borders.
- Lasts between 6 to 15 seconds, followed by immediate collapse into sitting or sleeping.

### Dragged by Scruff
- User clicks and holds Kiko.
- Physics disables autonomous movement; Kiko tracks mouse position with a gentle dangling tilt.
- Releasing drops Kiko with gravity until colliding with the Dock, bottom edge, or open application window top.

---

## 4. Time-of-Day Influences

- **Morning (07:00 - 10:00):** Moderate energy, curious, greets user.
- **Afternoon (13:00 - 16:00):** High sleepiness, frequent sunbeam naps.
- **Evening / Night (20:00 - 02:00):** Prime zoomie hours, highly playful and active.

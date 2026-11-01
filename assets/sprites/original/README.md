# Original Sprite Assets

> [!IMPORTANT]
> **Third-Party Asset Notice & Redistribution Restriction**
>
> The raw sprite artwork for Kiko is derived from the **Cat Pack - Pochi** collection created by **ToffeeCraft** on [itch.io](https://toffeecraft.itch.io/cat-pack-pochi).
>
> Under the author's license terms:
> - Free for personal use in game development and productions.
> - **Redistribution and resale of the raw assets are strictly prohibited.**
>
> Consequently, the original raw sprite sheets (including `RetroCatsFree.png`) are **excluded from the Git repository** to respect the creator's copyright.

## How to Set Up Original Sprites Locally

1. Visit the official pack page: [ToffeeCraft - Cat Pack - Pochi](https://toffeecraft.itch.io/cat-pack-pochi).
2. Download the free package `RetroCatsFree.png.zip`.
3. Extract `RetroCatsFree.png` and place it in this directory:
   ```bash
   cp /path/to/downloaded/RetroCatsFree.png assets/sprites/original/RetroCatsFree.png
   ```
4. Run the slice script to regenerate processed animation frames:
   ```bash
   python3 scripts/slice_sprites.py
   ```

#!/usr/bin/env python3
"""
slice_sprites.py
Utility script to extract individual 64x64 animation frames and sprites
from the original ToffeeCraft 'Cat Pack - Pochi' sprite sheet.
"""

import os
import sys
from PIL import Image

def slice_sprites():
    possible_paths = [
        "assets/sprites/original/RetroCatsFree.png",
        "Assets/RetroCatsFree.png"
    ]
    
    src_path = None
    for p in possible_paths:
        if os.path.exists(p):
            src_path = p
            break
            
    if not src_path:
        print("Error: RetroCatsFree.png not found.")
        print("Please download it from https://toffeecraft.itch.io/cat-pack-pochi")
        print("and place it at assets/sprites/original/RetroCatsFree.png")
        sys.exit(1)
        
    print(f"Loading sprite sheet from: {src_path}")
    sheet = Image.open(src_path)
    
    out_dir = "assets/sprites/processed"
    os.makedirs(out_dir, exist_ok=True)
    
    # Sitting / Idle: Row 0 (4 frames, 64x64)
    for i in range(4):
        frame = sheet.crop((i * 64, 0, (i + 1) * 64, 64))
        frame.save(f"{out_dir}/kiko_sit_{i}.png")
    print("✓ Extracted 4 sitting/idle frames")
    
    # Walking / Running: Row 1 (2 frames, 64x64)
    for i in range(2):
        frame = sheet.crop((i * 64, 64, (i + 1) * 64, 128))
        frame.save(f"{out_dir}/kiko_walk_{i}.png")
    print("✓ Extracted 2 walking frames")
    
    # Sleeping: Row 2 (4 frames, 64x64)
    for i in range(4):
        frame = sheet.crop((i * 64, 128, (i + 1) * 64, 192))
        frame.save(f"{out_dir}/kiko_sleep_{i}.png")
    print("✓ Extracted 4 sleeping frames")
    
    # Avatar variants: Row 3 (4 variants, 64x64)
    variants = ["grey", "orange", "black", "white"]
    for i, name in enumerate(variants):
        frame = sheet.crop((i * 64, 192, (i + 1) * 64, 256))
        frame.save(f"{out_dir}/kiko_variant_{name}.png")
    print("✓ Extracted 4 cat avatar variants")
    
    print("\nAll sprite frames extracted successfully to assets/sprites/processed/")

if __name__ == "__main__":
    slice_sprites()

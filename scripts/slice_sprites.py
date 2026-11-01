#!/usr/bin/env python3
"""
slice_sprites.py
Utility script to slice 32x32 animation frame strips into individual frames
for Kiko desktop pet avatars and fixtures.
"""

import os
import glob
from PIL import Image

def slice_sprites():
    src_dir = None
    candidates = [
        "assets/sprites/original",
        "/Users/rtoms/Downloads/kiko_cat_sprites"
    ]
    for c in candidates:
        if os.path.exists(c) and len(glob.glob(os.path.join(c, "*Sitting_Normal.png"))) > 0:
            src_dir = c
            break
            
    if not src_dir:
        print("Error: sprite source directory not found.")
        return

    out_dir = "assets/sprites/processed"
    os.makedirs(out_dir, exist_ok=True)
    
    print(f"Loading sprite strips from: {src_dir}")
    
    avatar_mapping = {
        "BlackCat": "blackcat",
        "Ginger": "ginger",
        "Calico": "calico",
        "WhiteCat": "whitecat",
        "BrownCat": "browncat",
        "Siamese": "siamese",
        "Tiger": "tiger",
        "Astronaut": "astronaut",
        "Batman": "batman",
        "Demon": "demon",
        "Santa": "santa",
        "Vampire": "vampire",
        "Witch": "witch"
    }
    
    action_mapping = {
        "Sitting": "sitting",
        "Idle": "idle",
        "Idle2": "idle2",
        "Run": "run",
        "Jump": "jump",
        "Attack": "attack",
        "Hurt": "hurt",
        "Sleep": "sleep",
        "Die": "die",
        "Die2": "die2"
    }
    
    total_frames = 0
    
    for prefix, slug in avatar_mapping.items():
        for action, action_slug in action_mapping.items():
            pattern = os.path.join(src_dir, f"{prefix}_{action}_Normal.png")
            matches = glob.glob(pattern)
            if not matches:
                continue
            strip_path = matches[0]
            try:
                im = Image.open(strip_path)
                frame_width = 32
                frame_height = 32
                num_frames = im.width // frame_width
                for i in range(num_frames):
                    frame = im.crop((i * frame_width, 0, (i + 1) * frame_width, frame_height))
                    out_name = f"{slug}_{action_slug}_{i}.png"
                    frame.save(os.path.join(out_dir, out_name))
                    total_frames += 1
            except Exception as e:
                print(f"Failed to slice {strip_path}: {e}")
                
    # Copy accessory fixtures
    fixtures = [
        ("CatBedBlue_Normal.png", "cat_bed_blue.png"),
        ("CatBedBrown_Normal.png", "cat_bed_brown.png"),
        ("CatBedGreen_Normal.png", "cat_bed_green.png"),
        ("CatBedPink_Normal.png", "cat_bed_pink.png"),
        ("CatBedPurple_Normal.png", "cat_bed_purple.png"),
        ("CatBedRed_Normal.png", "cat_bed_red.png"),
        ("bowl_Normal.png", "food_bowl.png"),
        ("bath_Normal.png", "bath_tub.png"),
        ("cat-food_Normal.png", "fish_treat.png"),
        ("heart_Normal.png", "heart_icon.png")
    ]
    
    for src_file, dest_file in fixtures:
        src_path = os.path.join(src_dir, src_file)
        if os.path.exists(src_path):
            try:
                im = Image.open(src_path)
                im.save(os.path.join(out_dir, dest_file))
            except Exception as e:
                print(f"Failed to copy fixture {src_file}: {e}")

    print(f"Done. Extracted {total_frames} frames into {out_dir}")

if __name__ == "__main__":
    slice_sprites()

#!/usr/bin/env python3

import os
import subprocess
import argparse
import shutil

def perform_ocr(image_path):
    """Runs Tesseract on the image and returns extracted text."""
    try:
        cmd = ["/opt/homebrew/bin/tesseract", image_path, "stdout"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout
    except FileNotFoundError:
        try:
            cmd = ["tesseract", image_path, "stdout"]
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            return result.stdout
        except Exception:
            return ""
    except Exception:
        return ""

def main():
    parser = argparse.ArgumentParser(description="Search screenshots and optionally move matches.")
    parser.add_argument("search_text", help="The text/keyword to search for")
    parser.add_argument("-p", "--path", default=".", help="Directory to search (default: current directory)")
    parser.add_argument("-m", "--move", default=None, help="Optional: Path to move matching files to")
    
    # --- NEW: Recursive flag (store_true means it acts as a boolean switch) ---
    parser.add_argument("-r", "--recursive", action="store_true", help="Search subfolders recursively")

    args = parser.parse_args()

    search_dir = os.path.abspath(args.path)
    target_text = args.search_text
    move_dir = os.path.abspath(args.move) if args.move else None

    print(f"🔍 Searching for '{target_text}' in: {search_dir}")
    if args.recursive:
        print("📁 Recursive mode enabled (searching subfolders)")
    if move_dir:
        print(f"📦 Matches will be moved to: {move_dir}")
        os.makedirs(move_dir, exist_ok=True)
    print("-" * 50)

    if not os.path.exists(search_dir):
        print(f"❌ Directory not found: {search_dir}")
        return

    match_count = 0

    # --- UPDATED: Folder Traversal ---
    if args.recursive:
        # os.walk loops through the current folder AND all subfolders
        for root, dirs, files in os.walk(search_dir):
            # Safety: Don't search inside the destination folder if it lives inside the search path
            if move_dir and os.path.commonpath([root, move_dir]) == move_dir:
                continue
                
            for filename in files:
                if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
                    file_path = os.path.join(root, filename)
                    match_count += process_file(file_path, filename, target_text, move_dir)
    else:
        # Standard flat search (original behavior)
        for filename in os.listdir(search_dir):
            if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
                file_path = os.path.join(search_dir, filename)
                match_count += process_file(file_path, filename, target_text, move_dir)

    print(f"\n✨ Done! Processed {match_count} matching files.")

def process_file(file_path, filename, target_text, move_dir):
    """Helper function to run OCR and handle matching/moving logic."""
    extracted_text = perform_ocr(file_path)
    
    if target_text.lower() in extracted_text.lower():
        if move_dir:
            dest_path = os.path.join(move_dir, filename)
            if os.path.exists(dest_path):
                print(f"⚠️ SKIPPED MOVE: {filename} already exists in destination.")
            else:
                shutil.move(file_path, dest_path)
                print(f"✅ MOVED: {filename}")
        else:
            print(f"✅ MATCH (No move): {filename}")
        return 1
    else:
        print(f"   No match: {filename}")
        return 0

if __name__ == "__main__":
    main()

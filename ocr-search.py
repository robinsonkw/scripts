import os
import subprocess
import argparse

def perform_ocr(image_path):
    """Runs Tesseract on the image and returns extracted text."""
    try:
        # Using the full path to homebrew tesseract is safer in scripts
        cmd = ["/opt/homebrew/bin/tesseract", image_path, "stdout", "--quiet"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout
    except FileNotFoundError:
        # Fallback if tesseract isn't in /opt/homebrew/bin
        try:
            cmd = ["tesseract", image_path, "stdout", "--quiet"]
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            return result.stdout
        except Exception as e:
            print(f"⚠️ OCR Failed. Is Tesseract installed? Error: {e}")
            return ""
    except Exception as e:
        print(f"⚠️ Error processing {os.path.basename(image_path)}: {e}")
        return ""

def main():
    # --- BASH ARGUMENT PARSING ---
    parser = argparse.ArgumentParser(description="Search screenshots for specific text.")
    
    # Position argument (Required): The text you want to find
    parser.add_argument("search_text", help="The text/keyword to search for")
    
    # Optional argument: The directory to search (defaults to current directory '.')
    parser.add_argument("-p", "--path", default=".", help="Directory to search (default: current directory)")

    args = parser.parse_args()
    # -----------------------------

    search_dir = os.path.abspath(args.path)
    target_text = args.search_text

    print(f"🔍 Searching for '{target_text}' in: {search_dir}\n")
    
    if not os.path.exists(search_dir):
        print(f"❌ Directory not found: {search_dir}")
        return

    match_count = 0
    for filename in os.listdir(search_dir):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
            file_path = os.path.join(search_dir, filename)
            extracted_text = perform_ocr(file_path)
            
            if target_text.lower() in extracted_text.lower():
                print(f"✅ MATCH: {filename}")
                match_count += 1
            else:
                print(f"   No match: {filename}")

    print(f"\n✨ Done! Found {match_count} matching files.")

if __name__ == "__main__":
    main()

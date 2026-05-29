import os
import sys
import subprocess
from pathlib import Path
import configparser
from shutil import copy2

# Check if 'cv2' is installed, and install if missing
try:
    import cv2
    import numpy as np
except ImportError:
    print("OpenCV (cv2) not found. Installing...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "opencv-python"])
    import cv2
    import numpy as np

# Load configuration settings
def load_config():
    config_path = Path(__file__).parent / 'pcconfig.ini'
    if not config_path.exists():
        print(f"ERROR: Configuration file '{config_path}' not found.")
        sys.exit(1)
    
    config = configparser.ConfigParser()
    config.read(config_path)
    settings = config["Settings"]
    
    return {
        "location1": tuple(map(int, settings["location1"].split(","))),
        "location2": tuple(map(int, settings["location2"].split(","))),
        "prefix1": settings["prefix1"],
        "prefix2": settings["prefix2"],
        "font_scale": float(settings.get("font_scale", 1)),
        "font_color": tuple(map(int, settings["font_color"].split(","))),
        "font_thickness": int(settings.get("font_thickness", 2))
    }

# Load environment variables
def load_env_vars():
    udir = Path(os.getenv("udir"))
    pdir = Path(os.getenv("pdir"))
    conda = Path(os.getenv("_conda"))
    
    if not all([udir, pdir, conda]):
        print("Error: One or more environment variables (udir, pdir, _conda) are not set.")
        sys.exit(1)
    
    return udir, pdir, conda

# Find image with specified prefix in the directory
def find_image(udir, prefix, fallback_dir):
    # Search for the image in udir
    for file in udir.iterdir():
        if file.name.startswith(prefix) and file.suffix.lower() in [".png", ".jpg", ".jpeg"]:
            return file

    # If not found, search in the fallback directory
    fallback_path = Path(fallback_dir)
    if fallback_path.exists():
        for file in fallback_path.iterdir():
            if file.name.startswith(prefix) and file.suffix.lower() in [".png", ".jpg", ".jpeg"]:
                # Copy the found image to udir
                target_path = udir / file.name
                copy2(file, target_path)
                print(f"Copied '{file}' from '{fallback_dir}' to '{udir}' for future access.")
                return target_path

    print(f"Error: No image found with prefix '{prefix}' in either '{udir}' or '{fallback_dir}'")
    sys.exit(1)

# Overlay text onto image
def plot_text_on_image(image_path, text, location, font_scale, font_color, font_thickness):
    image = cv2.imdecode(np.fromfile(image_path, dtype=np.uint8), -1)
    if image is None:
        print(f"Error: Failed to load image '{image_path}'")
        sys.exit(1)
    
    _, img_width = image.shape[:2]
    x, y = location
    
    # Adjust text size if too long
    (text_width, _), _ = cv2.getTextSize(text, cv2.FONT_HERSHEY_COMPLEX, font_scale, font_thickness)
    if x + text_width + 30 > img_width:
        print('WARNING: using smaller put text')
        font_scale, font_color, font_thickness = 1.3, (255, 0, 0), 2
        (text_width, _), _ = cv2.getTextSize(text, cv2.FONT_HERSHEY_COMPLEX, font_scale, font_thickness)
        x = img_width - text_width - 30

    # Put text on the image
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    cv2.putText(image, text, (x, y), cv2.FONT_HERSHEY_COMPLEX, font_scale, font_color, font_thickness, cv2.LINE_AA)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    
    return image

# Main workflow
def main():
    settings = load_config()
    udir, pdir, conda = load_env_vars()
    output_dir = Path('pycharm2024配置教程')
    output_dir.mkdir(exist_ok=True)

    # Process and save images with text overlay
    for prefix, text, location in [(settings["prefix1"], str(pdir), settings["location1"]),
                                   (settings["prefix2"], str(conda), settings["location2"])]:
        image_path = find_image(udir, prefix, output_dir)
        result_image = plot_text_on_image(
            image_path, text, location,
            settings["font_scale"], settings["font_color"], settings["font_thickness"]
        )
        cv2.imencode('.png', result_image)[1].tofile(output_dir / image_path.name)

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        sys.exit(1)

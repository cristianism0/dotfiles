#!/usr/bin/env python3
import os
import sys
import subprocess
import argparse

# Named resolution presets
PRESETS = {
    "8k": (7680, 4320),
    "4k": (3840, 2160),
    "2k": (2560, 1440),
    "1080p": (1920, 1080),
    "720p": (1280, 720),
}

SUPPORTED_EXTS = (".jpg", ".jpeg")


def parse_size(value):
    """Accept a named preset like '1080p' or an explicit dimension like '1920x1080'."""
    v = value.lower()
    if v in PRESETS:
        return PRESETS[v]
    if "x" in v:
        try:
            w, h = v.split("x")
            return int(w), int(h)
        except ValueError:
            pass
    raise argparse.ArgumentTypeError(
        f"Invalid size '{value}'. Use a preset ({', '.join(PRESETS)}) or WxH (e.g. 1920x1080)."
    )


def map_output_path(value):
    if value == "..":
        return os.path.abspath(os.path.join(os.getcwd(), ".."))
    elif not value.startswith("/") and not value.startswith("."):
        return os.path.expanduser(f"~/Imagens/{value}")
    return os.path.abspath(value)


def build_scale_filter(width, height, scale_factor):
    if scale_factor:
        # -2 keeps dimensions even, required by some codecs
        return f"scale=iw/{scale_factor}:-2"
    return f"scale={width}:{height}:force_original_aspect_ratio=decrease"


def main():
    parser = argparse.ArgumentParser(
        description="Resize images to a target resolution using FFmpeg.",
        formatter_class=argparse.RawTextHelpFormatter,
    )

    parser.add_argument(
        "input_dir",
        nargs="?",
        default=".",
        help="Directory containing the original images (default: current directory)",
    )
    parser.add_argument(
        "-o",
        dest="output_dir",
        default=os.path.expanduser("~/Imagens"),
        help="Output directory (default: ~/Imagens)",
    )

    # Target size — preset or explicit WxH, mutually exclusive with -s
    size_group = parser.add_mutually_exclusive_group()
    size_group.add_argument(
        "--size",
        type=parse_size,
        default=PRESETS["4k"],
        metavar="PRESET|WxH",
        help=(
            "Target resolution. Presets: 8k, 4k, 2k, 1080p, 720p\n"
            "Or a custom dimension: 1920x1080\n"
            "(default: 4k)"
        ),
    )
    size_group.add_argument(
        "-s",
        "--scale",
        type=float,
        metavar="FACTOR",
        help=(
            "Scale down by a factor instead of a fixed size.\n"
            "e.g. -s 2 → half size, -s 4 → quarter size"
        ),
    )

    parser.add_argument(
        "-q",
        "--quality",
        type=int,
        default=3,
        metavar="1-31",
        help="JPEG quality via ffmpeg -q:v (1=best, 31=worst; default: 3)",
    )
    parser.add_argument(
        "--suffix",
        default="-resize",
        metavar="TEXT",
        help="Suffix appended to output filenames (default: -resize)",
    )

    args = parser.parse_args()

    input_path = os.path.abspath(args.input_dir)
    output_path = (
        map_output_path(args.output_dir) if "-o" in sys.argv else args.output_dir
    )

    if not os.path.isdir(input_path):
        print(f"Error: input directory '{args.input_dir}' does not exist.")
        sys.exit(1)

    os.makedirs(output_path, exist_ok=True)

    width, height = args.size if not args.scale else (0, 0)
    scale_filter = build_scale_filter(width, height, args.scale)

    print(f"Source:      {input_path}")
    print(f"Destination: {output_path}")
    if args.scale:
        print(f"Scale:       1/{args.scale}x")
    else:
        print(f"Size:        {width}x{height}")
    print(f"Filter:      {scale_filter}")
    print("-" * 50)

    try:
        files = os.listdir(input_path)
    except PermissionError:
        print(f"Error: permission denied reading {input_path}")
        sys.exit(1)

    images = [
        f
        for f in files
        if f.lower().endswith(SUPPORTED_EXTS) and args.suffix.lower() not in f.lower()
    ]

    if not images:
        print("No .jpg or .jpeg images found in the specified directory.")
        sys.exit(0)

    for img in images:
        img_input = os.path.join(input_path, img)
        name, ext = os.path.splitext(img)
        img_output = os.path.join(output_path, f"{name}{args.suffix}{ext}")

        print(f"  {img} -> {img_output}")

        cmd = [
            "ffmpeg",
            "-y",
            "-i",
            img_input,
            "-vf",
            scale_filter,
            "-q:v",
            str(args.quality),
            img_output,
        ]
        result = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
        if result.returncode != 0:
            print(
                f"  !! Error processing {img}: {result.stderr.decode().splitlines()[-1]}"
            )


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Generate the ComfyUI-Pixaroma desktop icon (256x256 PNG).
Based on the Pixaroma logo pattern from the installer.
"""

import struct
import zlib
import os


def create_png(width, height, pixels):
    """Create a minimal PNG file from RGBA pixel data."""

    def chunk(chunk_type, data):
        c = chunk_type + data
        crc = struct.pack(">I", zlib.crc32(c) & 0xFFFFFFFF)
        return struct.pack(">I", len(data)) + c + crc

    header = b"\x89PNG\r\n\x1a\n"
    ihdr = chunk(
        b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)
    )

    raw = b""
    for y in range(height):
        raw += b"\x00"  # filter byte
        for x in range(width):
            raw += bytes(pixels[y * width + x])

    idat = chunk(b"IDAT", zlib.compress(raw, 9))
    iend = chunk(b"IEND", b"")

    return header + ihdr + idat + iend


def generate_pixaroma_icon(size=256):
    """Generate a Pixaroma-style icon."""
    pixels = []

    # Colors
    bg = (30, 30, 40, 255)        # dark background
    yellow = (255, 200, 50, 255)  # yellow accent (from installer)
    green = (80, 200, 120, 255)   # green accent (from installer)
    white = (240, 240, 245, 255)  # highlights

    center = size // 2
    radius = size // 2 - 12

    for y in range(size):
        for x in range(size):
            # Distance from center
            dx = x - center
            dy = y - center
            dist = (dx * dx + dy * dy) ** 0.5

            if dist > radius + 2:
                # Outside circle — transparent
                pixels.append((0, 0, 0, 0))
            elif dist > radius:
                # Anti-aliased edge
                alpha = max(0, min(255, int(255 * (radius + 2 - dist) / 2)))
                pixels.append((bg[0], bg[1], bg[2], alpha))
            else:
                # Inside the circle — draw the Pixaroma "P" pattern
                # Normalize to 0-1 within the circle
                nx = (x - (center - radius)) / (2 * radius)
                ny = (y - (center - radius)) / (2 * radius)

                # Background circle with subtle gradient
                grad = int(30 + 15 * ny)
                pixel = (grad, grad, grad + 10, 255)

                # Draw a stylized "P" shape (Pixaroma)
                # Vertical bar of P
                if 0.28 <= nx <= 0.38 and 0.2 <= ny <= 0.8:
                    pixel = green

                # Top horizontal bar of P
                if 0.28 <= nx <= 0.65 and 0.2 <= ny <= 0.30:
                    pixel = green

                # Right curve of P (approximated as rectangle + round)
                if 0.55 <= nx <= 0.68 and 0.2 <= ny <= 0.52:
                    pixel = green

                # Bottom bar of P bowl
                if 0.28 <= nx <= 0.65 and 0.42 <= ny <= 0.52:
                    pixel = green

                # Inner cutout of P (make it dark again)
                if 0.38 <= nx <= 0.55 and 0.30 <= ny <= 0.42:
                    pixel = (grad, grad, grad + 10, 255)

                # Small pixel-art dots (Pixaroma style)
                grid = 16
                gx = int(nx * grid) % grid
                gy = int(ny * grid) % grid

                # Corner accent dots
                if (gx, gy) in [(1, 13), (2, 13), (1, 14), (14, 13), (13, 13), (14, 14)]:
                    pixel = yellow

                # Bottom accent line
                if 0.3 <= nx <= 0.7 and 0.85 <= ny <= 0.88:
                    pixel = yellow

                pixels.append(pixel)

    return pixels


def main():
    size = 256
    print(f"Generating {size}x{size} Pixaroma icon...")
    pixels = generate_pixaroma_icon(size)
    png_data = create_png(size, size, pixels)

    out_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "comfyui_icon.png")
    with open(out_path, "wb") as f:
        f.write(png_data)

    print(f"Icon saved to: {out_path} ({len(png_data)} bytes)")


if __name__ == "__main__":
    main()

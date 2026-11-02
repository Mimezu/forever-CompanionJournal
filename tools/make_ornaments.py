"""Draw the journal's book ornaments (white on transparency, tinted in game).

rule     256x16  a hairline that swells toward a center diamond, with two dots
Also two glyphs for Media/Glyphs: skull (deaths) and kin (someone another of
your characters knows: two linked rings).
fleuron  128x64  a small symmetric flourish between days
blank    8x8     fully transparent: the first-line indent (|T...:1:16|t)
ink1-3   256x16  quill underlines for the diary (style D)
Drawn 4x larger and downsampled. Writes Media/Ornaments/*.tga for the game and
*.png next to them for the style mockups.
"""
import math
import os
from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..', 'Media', 'Ornaments')
W = (255, 255, 255, 255)
K = 4  # supersampling


def taper_stroke(d, points, r0, r1):
    """A stroke that thins from radius r0 to r1 along the points."""
    n = len(points)
    for i, (x, y) in enumerate(points):
        r = r0 + (r1 - r0) * (i / max(1, n - 1))
        d.ellipse((x - r, y - r, x + r, y + r), fill=W)


def rule():
    w, h = 256 * K, 16 * K
    img = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    cy = h / 2
    # Hairline swelling toward the middle (thickest just outside the dots):
    # one tapered shape per side, so the stroke has no steps.
    for side in (-1, 1):
        inner, outer = w / 2 + side * 70, w / 2 + side * (w / 2 - 12)
        d.polygon([(inner, cy - 3.4), (outer, cy - 0.5), (outer, cy + 0.5), (inner, cy + 3.4)], fill=W)
    # Center diamond and two dots.
    s = 22
    d.polygon([(w / 2, cy - s), (w / 2 + s * 0.8, cy), (w / 2, cy + s), (w / 2 - s * 0.8, cy)], fill=W)
    for side in (-1, 1):
        x = w / 2 + side * 44
        r = 5.5
        d.ellipse((x - r, cy - r, x + r, cy + r), fill=W)
    return img.resize((256, 16), Image.LANCZOS)


def spiral(cx, cy, r_start, r_end, turns, start_angle, direction):
    pts = []
    steps = 220
    for i in range(steps + 1):
        f = i / steps
        a = start_angle + direction * f * turns * 2 * math.pi
        r = r_start + (r_end - r_start) * f
        pts.append((cx + r * math.cos(a), cy + r * math.sin(a)))
    return pts


def fleuron():
    w, h = 128 * K, 64 * K
    img = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    cx, cy = w / 2, h / 2
    # Central lozenge, slightly taller than wide.
    d.polygon([(cx, cy - 58), (cx + 20, cy), (cx, cy + 58), (cx - 20, cy)], fill=W)
    for side in (-1, 1):
        # A tendril leaving the lozenge, curling up and in.
        start = (cx + side * 22, cy)
        sx = cx + side * 132
        pts = []
        # Gentle S from the lozenge to the spiral's outer edge.
        for i in range(60):
            f = i / 59
            x = start[0] + side * f * 70
            y = cy + math.sin(f * math.pi) * -10
            pts.append((x, y))
        taper_stroke(d, pts, 9, 7)
        coil = spiral(sx, cy - 6, 44, 6, 1.15, math.pi if side > 0 else 0, -side)
        taper_stroke(d, coil, 7, 3)
        # A small leaf below the tendril.
        lx = cx + side * 64
        leaf = [(lx, cy + 10), (lx + side * 26, cy + 26), (lx + side * 42, cy + 20), (lx + side * 20, cy + 14)]
        d.polygon(leaf, fill=W)
        # End dot.
        ex = cx + side * 216
        d.ellipse((ex - 7, cy - 7, ex + 7, cy + 7), fill=W)
    return img.resize((128, 64), Image.LANCZOS)


def blank():
    return Image.new('RGBA', (8, 8), (0, 0, 0, 0))


def skull():
    """64x64 glyph (same set as Media/Glyphs): a plain skull, for deaths in the journal."""
    w = 64 * K
    img = Image.new('RGBA', (w, w), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    c = w / 2
    # Cranium and jaw.
    d.ellipse((c - 24 * K, 8 * K, c + 24 * K, 46 * K), fill=W)
    d.rounded_rectangle((c - 14 * K, 36 * K, c + 14 * K, 56 * K), radius=5 * K, fill=W)
    clear = (0, 0, 0, 0)
    # Eyes, nose, teeth gaps.
    d.ellipse((c - 17 * K, 24 * K, c - 5 * K, 36 * K), fill=clear)
    d.ellipse((c + 5 * K, 24 * K, c + 17 * K, 36 * K), fill=clear)
    d.polygon([(c, 37 * K), (c - 4 * K, 44 * K), (c + 4 * K, 44 * K)], fill=clear)
    for x in (-7, 0, 7):
        d.rectangle((c + x * K - 1.2 * K, 49 * K, c + x * K + 1.2 * K, 56 * K), fill=clear)
    return img.resize((64, 64), Image.LANCZOS)


def kin():
    """64x64 glyph: two linked rings, for someone another character of yours knows."""
    w = 64 * K
    c = w / 2
    r, s, g = 17 * K, 7 * K, 3 * K  # ring radius, stroke, gap where one passes over the other
    left = (c - 9 * K - r, c - r, c - 9 * K + r, c + r)
    right = (c + 9 * K - r, c - r, c + 9 * K + r, c + r)

    def ring(box):
        img = Image.new('RGBA', (w, w), (0, 0, 0, 0))
        ImageDraw.Draw(img).ellipse(box, outline=W, width=s)
        return img

    def cut(img, box, top):
        # Clear img where the other ring (widened by the gap) passes over it.
        mask = Image.new('L', (w, w), 0)
        md = ImageDraw.Draw(mask)
        md.ellipse((box[0] - g, box[1] - g, box[2] + g, box[3] + g), outline=255, width=s + 2 * g)
        if top:
            md.rectangle((0, c, w, w), fill=0)
        else:
            md.rectangle((0, 0, w, c), fill=0)
        clear = Image.new('RGBA', (w, w), (0, 0, 0, 0))
        return Image.composite(clear, img, mask)

    a = cut(ring(left), right, True)    # the right ring passes over the left one at the top
    b = cut(ring(right), left, False)   # and under it at the bottom
    img = Image.alpha_composite(a, b)
    return img.resize((64, 64), Image.LANCZOS)


def ink(seed):
    """A quill underline, 256x16: lands thin, swells, lifts off with a small
    flick; a slight wave and uneven ink. Stretched to each name in game."""
    import random
    rnd = random.Random(seed)
    w, h = 256 * K, 16 * K
    img = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    x0, x1 = 6 * K, w - 6 * K
    cy = h / 2 + rnd.uniform(-0.6, 0.6) * K
    slope = rnd.uniform(-1.2, 1.2) * K / (x1 - x0)
    waves = [(rnd.uniform(0.35, 0.8) * K, rnd.uniform(1.2, 2.6), rnd.uniform(0, 6.28)),
             (rnd.uniform(0.1, 0.3) * K, rnd.uniform(4, 7), rnd.uniform(0, 6.28))]
    peak = rnd.uniform(0.3, 0.55)
    steps = 900
    for i in range(steps + 1):
        t = i / steps
        x = x0 + (x1 - x0) * t
        y = cy + slope * (x - x0) + sum(a * math.sin(f * 6.28 * t + ph) for a, f, ph in waves)
        # the last 6%: the pen lifts up and away
        if t > 0.94:
            y -= ((t - 0.94) / 0.06) ** 2 * 2.2 * K
        # thickness: thin landing, full body around the peak, thin tail
        if t < peak:
            r = 0.45 + 0.75 * (t / peak) ** 0.6
        else:
            r = 1.2 - 0.85 * ((t - peak) / (1 - peak)) ** 1.4
        r *= K * (1 + 0.08 * math.sin(t * 37 + seed))
        d.ellipse((x - r, y - r, x + r, y + r), fill=W)
    # uneven ink: the alpha breathes a little along the stroke
    alpha = img.getchannel('A')
    shade = Image.new('L', (w, h), 0)
    sd = ImageDraw.Draw(shade)
    for xi in range(0, w, K):
        t = xi / w
        v = int(255 * (0.78 + 0.22 * (0.5 + 0.5 * math.sin(t * 9 + seed * 1.7))))
        sd.rectangle((xi, 0, xi + K, h), fill=v)
    from PIL import ImageChops
    img.putalpha(ImageChops.multiply(alpha, shade))
    return img.resize((256, 16), Image.LANCZOS)


def main():
    os.makedirs(OUT, exist_ok=True)
    glyphs = os.path.join(HERE, '..', 'Media', 'Glyphs')
    skull().save(os.path.join(glyphs, 'skull.tga'))
    kin().save(os.path.join(glyphs, 'kin.tga'))
    print('wrote skull and kin glyphs')
    for name, fn in (('rule', rule), ('fleuron', fleuron), ('blank', blank),
                     ('ink1', lambda: ink(1)), ('ink2', lambda: ink(2)), ('ink3', lambda: ink(3))):
        img = fn()
        img.save(os.path.join(OUT, name + '.tga'))
        img.save(os.path.join(OUT, name + '.png'))
        print('wrote', name, img.size)


if __name__ == '__main__':
    main()

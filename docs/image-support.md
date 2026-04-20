# Image I/O Support

Adding image reading and writing to the numerics package, enabling real image manipulation in Maxima notebooks.

## Architecture

Image I/O is added as a separate ASDF subsystem to keep the core numerics package lightweight:

```
numerics/core       (existing — magicl, trivial-garbage, alexandria)
numerics            (existing — core + arrow, adds cffi, static-vectors)
numerics/image      (NEW — core + opticl)
```

Users who don't need image I/O don't pull in opticl and its transitive dependencies.

### Loading

```maxima
load("numerics")$            /* core + arrow, no image I/O */
load("numerics-image")$      /* adds np_imread, np_imwrite */
```

Or via a single combined load if preferred — TBD based on user feedback.

## Dependency: opticl

[opticl](https://github.com/slyrus/opticl) is a Common Lisp image processing library available on Quicklisp. It reads and writes PNG, JPEG, TIFF, GIF, and PBM/PNM formats.

Key properties:
- Returns standard CL arrays (not custom objects)
- Designed for SBCL with type-optimized operations
- Built-in grayscale conversion
- No native library install required (pure CL for PNG, bundled cl-jpeg for JPEG)
- Works on macOS ARM64

### ASDF system definition

```lisp
;; In numerics.asd
(defsystem "numerics/image"
  :description "Image I/O for numerics: read/write PNG, JPEG via opticl"
  :depends-on ("numerics/core" "opticl")
  :components ((:file "image")))
```

## Functions

### np_imread — Read image file

**File:** `lisp/core/image.lisp` (new)

Read an image file into an ndarray. Grayscale by default, with optional color mode.

```maxima
img : np_imread("/path/to/photo.png")$           /* 2D [H, W], values 0.0-1.0 */
img : np_imread("/path/to/photo.jpg", color)$     /* 3D [H, W, 3], RGB 0.0-1.0 */
np_shape(img);
```

**Implementation:**

```lisp
(defun $np_imread (path &optional mode)
  ;; 1. Read with opticl
  (let* ((raw (opticl:read-image-file path))
         ;; 2. Convert to grayscale unless color mode
         (img (if (eq mode '$color)
                  raw
                  (opticl:convert-image-to-grayscale raw))))
    ;; 3. Get dimensions
    ;; 4. Create magicl tensor of matching shape
    ;; 5. Copy pixels, normalizing uint8 [0,255] → double [0.0, 1.0]
    ;; 6. Wrap in ndarray handle
    ))
```

**Grayscale output:** 2D ndarray `[height, width]`, element type `double-float`, values in `[0.0, 1.0]`.

**Color output:** 3D ndarray `[height, width, 3]`, channels are R, G, B in order.

**Supported formats:** PNG, JPEG, TIFF, GIF, PBM/PNM (auto-detected by opticl from file extension/magic bytes).

### np_imwrite — Write image file

**File:** `lisp/core/image.lisp`

Write an ndarray to an image file. Format is inferred from file extension.

```maxima
np_imwrite("/tmp/output.png", img)$      /* grayscale from 2D, RGB from 3D */
np_imwrite("/tmp/output.jpg", img)$      /* JPEG output */
```

**Implementation:**

```lisp
(defun $np_imwrite (path ndarray)
  ;; 1. Unwrap ndarray, get shape
  ;; 2. Determine grayscale (2D) vs color (3D)
  ;; 3. Create opticl image array:
  ;;    - Denormalize: double [0.0, 1.0] → uint8 [0, 255]
  ;;    - Clip values outside range
  ;; 4. Dispatch on extension:
  ;;    ".png" → opticl:write-png-file
  ;;    ".jpg"/".jpeg" → opticl:write-jpeg-file
  ;;    ".tiff" → opticl:write-tiff-file
  )
```

**Normalization:** Input values are expected in `[0.0, 1.0]`. Values outside this range are clamped. Internally multiplied by 255 and rounded to nearest integer for uint8 output.

## Display in notebooks

### Current state

Aximar and maxima-extension do not currently support inline image display (see [ide-requirements.md](ide-requirements.md)). Images written with `np_imwrite` are saved to disk but cannot be shown inline.

### Workaround: ax_heatmap

For grayscale images, `ax_heatmap` with the `"Greys"` colorscale provides a good visual representation:

```maxima
img : np_imread("/path/to/photo.png")$
ax_draw2d(
  colorscale = "Greys",
  ax_heatmap(np_to_matrix(img)))$
```

This produces an interactive Plotly heatmap that works in both Aximar and the VSCode extension. For color images, display each channel separately or convert to grayscale.

### Future: inline image display

Once the IDE supports `image/png` output (see [ide-requirements.md](ide-requirements.md)), a display function can be added:

```maxima
np_imshow(img)$    /* would emit a PNG to the notebook output */
```

This would write a temp PNG file and emit it via the same file-path mechanism that ax-plots uses for Plotly JSON.

## Sample images

The demos repo should include a few small test images in `data/`:

- `cameraman.png` — classic 256x256 grayscale test image
- `test-pattern.png` — synthetic pattern (checkerboard + gradients) for filter demos

Alternatively, notebooks can construct synthetic test images programmatically:

```maxima
/* Checkerboard */
img : np_map(lambda([x], if mod(floor(x), 2) = 0 then 1.0 else 0.0),
             np_arange(0, 256*256))$
img : np_reshape(img, [256, 256])$
```

## Testing

Add tests to `rtest_numerics.mac`:

```maxima
/* Round-trip: write then read */
a : np_rand([64, 64])$
np_imwrite("/tmp/test_roundtrip.png", a)$
b : np_imread("/tmp/test_roundtrip.png")$
np_shape(b);
[64, 64];

/* Color read */
/* ... */
```

Note: pixel values may differ slightly due to uint8 quantization (loss of precision from double → uint8 → double). Tests should use approximate comparison.

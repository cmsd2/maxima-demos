# IDE Requirements

Changes needed in [Aximar](https://github.com/cmsd2/aximar) (desktop notebook IDE) and the [maxima-extension](https://github.com/cmsd2/maxima-extension) (VSCode) to fully support the demo notebooks.

## Current output capabilities

| Output type | Aximar | VSCode extension |
|-------------|--------|------------------|
| Plain text (stdout) | Yes | Yes |
| LaTeX math (KaTeX) | Yes | Yes |
| SVG plots (gnuplot) | Yes | Yes |
| Plotly charts (ax-plots) | Yes | Yes |
| PNG/JPEG images | **No** | **No** |
| Multiple plots per cell | **No** | **No** |

## Issue 1: Inline image display

### Problem

Neither Aximar nor the VSCode extension can display raster images (PNG, JPEG) inline in notebook cells. This blocks the image-processing demo from showing results visually.

### Current rendering pipeline

ax-plots writes a `.plotly.json` temp file, prints its path to stdout, and the IDE detects it:

```
Maxima → print path → parser regex → read JSON → Plotly.js render
```

The same mechanism could work for images.

### Proposed solution: Aximar

**1. Add image field to CellOutput** (`crates/aximar-core/src/notebook.rs`):

```rust
pub struct CellOutput {
    pub text_output: String,
    pub latex: Option<String>,
    pub plot_svg: Option<String>,
    pub plot_data: Option<String>,
    pub image_path: Option<String>,    // NEW
    pub error: Option<String>,
}
```

**2. Detect image paths in parser** (`crates/aximar-core/src/maxima/parser.rs`):

Add regex detection for image file paths, similar to Plotly JSON detection:

```rust
// Detect: /tmp/maxima_img_12345.png
lazy_static! {
    static ref IMAGE_PATH_RE: Regex = Regex::new(
        r#""?([^"\s]+\.(png|jpg|jpeg))"?"#
    ).unwrap();
}
```

**3. Render in frontend** (`src/components/CellOutput.tsx`):

```tsx
{hasImage && (
  <div className="image-output">
    <img src={imageBlobUrl} alt="Image output" style={{maxWidth: '100%'}} />
  </div>
)}
```

**4. Maxima-side display function:**

```lisp
;; np_imshow writes a temp PNG and prints the path
(defun $np_imshow (ndarray)
  (let ((path (format nil "/tmp/maxima_img_~A.png" (get-universal-time))))
    ($np_imwrite path ndarray)
    ;; Print path so the IDE picks it up
    (format t "~A~%" path)
    '$done))
```

### Proposed solution: VSCode extension

**1. Add image MIME handler** (`src/renderers/maxima/index.ts`):

```typescript
// Handle image/png MIME type
if (mimeType === 'image/png') {
  const img = document.createElement('img');
  img.src = `data:image/png;base64,${data}`;
  element.appendChild(img);
}
```

**2. Convert image outputs** (`src/notebook/controller/outputs.ts`):

When the Maxima output contains an image file path, read the file and convert to base64 for the `image/png` MIME type in the notebook output.

### Workaround without IDE changes

Use `ax_heatmap` with `"Greys"` colorscale for grayscale images:

```maxima
img : np_imread("photo.png")$
ax_draw2d(colorscale = "Greys", ax_heatmap(np_to_matrix(img)))$
```

This works today in both IDEs. It's interactive (hover shows pixel values) but doesn't look like a photograph — more like a scientific heatmap.

## Issue 2: Multiple outputs per cell

### Problem

Aximar's `CellOutput` struct holds at most one plot (either SVG or Plotly, not both). If a cell produces two plots, only the last one is shown.

```maxima
/* Only plot2 will display */
ax_draw2d(explicit(sin(x), x, 0, 6))$
ax_draw2d(explicit(cos(x), x, 0, 6))$
```

### Impact

Forces a one-plot-per-cell discipline. Before/after comparisons require separate cells with markdown headers between them.

### Proposed solution

Change `CellOutput` to hold a list of outputs:

```rust
pub struct CellOutput {
    pub items: Vec<OutputItem>,
}

pub enum OutputItem {
    Text(String),
    Latex(String),
    PlotSvg(String),
    PlotData(String),      // Plotly JSON
    Image(String),          // path or base64
    Error(String),
}
```

The parser would accumulate items as it encounters them in the Maxima output stream, and the frontend would render them in sequence.

### Complexity

This is a significant refactor touching the core data model, parser, frontend renderer, and notebook serialization. It could be deferred — the one-plot-per-cell convention is workable.

### Workaround

Structure notebooks with one plot per code cell:

```
[markdown] ## Original Image
[code]     ax_draw2d(ax_heatmap(original))$
[markdown] ## After Gaussian Blur
[code]     ax_draw2d(ax_heatmap(blurred))$
```

This is actually good notebook style — each cell has a clear purpose.

## Issue 3: Plot persistence in saved notebooks

### Problem

When saving `.macnb` files, Aximar converts to Jupyter-compatible format but **does not include plot data** in the saved outputs. The conversion code in `aximar-mcp/src/convert.rs` only saves text and LaTeX outputs — `plot_svg` and `plot_data` are omitted.

This means:
- Opening a previously-run notebook shows blank plot cells
- Sharing notebooks requires re-execution
- GitHub rendering of `.macnb` files won't show plots

### Impact

All demo notebooks lose their visual output when saved and reopened. Users must re-run every cell to see plots again.

### Proposed solution

Include plot data in the Jupyter-format outputs when saving:

```rust
// In convert.rs, when building outputs:
if let Some(ref plot_data) = o.plot_data {
    entries.push(Output {
        output_type: "display_data".to_string(),
        data: {
            "application/x-maxima-plotly": plot_data.clone(),
        },
        metadata: {},
    });
}
```

The frontend already reads these MIME types when loading notebooks — it just needs the save side to write them.

### Priority

**High.** This affects every demo notebook. Without it, the demos are only useful to people who can run them locally.

## Summary of priorities

| Change | Priority | Effort | Impact |
|--------|----------|--------|--------|
| Plot persistence in saved notebooks | **High** | Small | All notebooks |
| Inline image display | **Medium** | Medium | image-processing notebook |
| Multiple outputs per cell | **Low** | Large | Nice-to-have for comparisons |

The plot persistence fix is the most important — it's a small change with the highest impact. Inline image display enables the image-processing demo but has a workaround via `ax_heatmap`. Multiple outputs per cell would be nice but the one-plot-per-cell convention is standard notebook practice.

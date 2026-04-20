# Plotting Enhancements

Changes needed in [ax-plots](https://github.com/cmsd2/ax-plots) to better support the demo notebooks. These are improvements rather than blockers — all demos can work without them, but the experience would be significantly better with them.

## Priority 1: Subplots / multi-panel layouts

### Problem

Currently each `ax_draw2d` / `ax_draw3d` call produces a single plot. There's no way to arrange multiple plots in a grid (2x2, 1x3, etc.) within a single output.

Many demos naturally want side-by-side comparison:
- Image processing: original vs filtered vs edge-detected
- SVD: reconstruction at rank 1, 5, 10, 20
- Signal processing: time domain vs frequency domain
- Taylor convergence: successive approximations overlaid

### Current workaround

Put each plot in a separate notebook cell with a markdown header between them. This works but is verbose and loses the visual comparison.

### Proposed API

```maxima
ax_subplot(2, 2,
  ax_draw2d(explicit(sin(x), x, 0, 2*%pi), title = "sin(x)"),
  ax_draw2d(explicit(cos(x), x, 0, 2*%pi), title = "cos(x)"),
  ax_draw2d(explicit(sin(x)*cos(x), x, 0, 2*%pi), title = "product"),
  ax_draw2d(explicit(sin(x)+cos(x), x, 0, 2*%pi), title = "sum"))$
```

### Implementation

Plotly supports subplots natively via the `make_subplots` layout. The Maxima side would:

1. Accept `ax_subplot(rows, cols, plot1, plot2, ...)` where each plot is a deferred `ax_draw2d`/`ax_draw3d` call
2. Generate traces for each subplot with appropriate `xaxis`/`yaxis` assignments (`x1`/`y1`, `x2`/`y2`, etc.)
3. Build a single Plotly JSON with `layout.grid = {rows: 2, cols: 2}` and per-subplot axis domains

This is a medium-sized change to ax-plots — the trace generation logic already exists, it just needs the subplot wiring.

### Impact on demos

| Notebook | How subplots help |
|----------|-------------------|
| image-processing | Before/after comparison grids |
| svd-low-rank | Reconstruction at different ranks |
| signal-processing | Time vs frequency domain |
| matrix-decompositions | QR vs LU vs SVD side-by-side |
| taylor-convergence | Successive approximation panels |
| heat-equation | Temperature profiles at different times |

## Priority 2: Multiple traces in bar/histogram

### Problem

`ax_bar` and `ax_histogram` currently support single series. Grouped or stacked bars require workarounds.

### Current state

`ax_draw2d` can overlay multiple `explicit()` traces via `name=` labels. But `ax_bar` is a standalone function — you can't overlay two bar series.

### Proposed enhancement

```maxima
/* Grouped bars */
ax_bar([["Q1","Q2","Q3","Q4"], [10,20,30,40], [15,25,35,45]],
       name = ["Revenue", "Target"],
       bar_mode = "group")$

/* Or via ax_draw2d with bar objects */
ax_draw2d(
  name = "Revenue", bars([10, 20, 30, 40]),
  name = "Target",  bars([15, 25, 35, 45]),
  bar_mode = "group")$
```

### Impact on demos

| Notebook | How it helps |
|----------|-------------|
| eda-pipeline | Revenue vs target by region |
| monte-carlo | Histogram overlay of sample vs theoretical distribution |

## Priority 3: Colorbar control for heatmaps

### Problem

`ax_heatmap` uses Plotly's default colorbar. For image processing demos, you want:
- Reversed colorscale (white=0, black=1 for "Greys")
- Fixed color range (always 0 to 1 for normalized images)
- Ability to hide the colorbar

### Proposed enhancement

```maxima
ax_draw2d(
  colorscale = "Greys",
  reversescale = true,        /* NEW: flip colorscale direction */
  zmin = 0.0, zmax = 1.0,    /* NEW: fix color range */
  showscale = false,          /* already exists but may need testing */
  ax_heatmap(img_matrix))$
```

### Impact on demos

Critical for image-processing notebook — without `reversescale`, grayscale images appear inverted (white=high, black=low is the opposite of photographic convention).

## Not needed (for now)

### Animations

Multi-frame animations would enhance heat-equation and ODE trajectory demos, but the implementation complexity is high (Plotly animation frames, play/pause controls, slider). The demos can use sequential heatmap snapshots instead.

### Secondary axes

Dual y-axes (e.g., voltage on left, current on right) would be nice for rc-circuit, but the demo can normalize or use separate plots.

### Custom colormaps

Plotly's built-in colorscales (Viridis, Hot, Blues, Greys, RdBu, etc.) cover all demo needs. No custom colormap support is required.

# Supporting Work Overview

This directory documents the upstream package additions and IDE changes needed to support the demo notebooks.

## Documents

| Document | Scope | Summary |
|----------|-------|---------|
| [numerics-additions.md](numerics-additions.md) | maxima-numerics | 10 new functions: statistics (trapz, cov, corrcoef, diff), constructors (logspace, outer), signal processing (fft, ifft, convolve, clip) |
| [image-support.md](image-support.md) | maxima-numerics | New `numerics/image` ASDF subsystem with `np_imread`/`np_imwrite` via opticl |
| [plotting-enhancements.md](plotting-enhancements.md) | ax-plots | Subplots, grouped bars, colorbar control — improvements not blockers |
| [ide-requirements.md](ide-requirements.md) | Aximar, maxima-extension | Plot persistence (high priority), inline image display, multi-output cells |

## Phased dependency map

```
Phase 1-2: No package work
  └─ 12 notebooks using existing features only

Phase 3: numerics additions (6 functions)
  ├─ np_trapz, np_cov, np_corrcoef   → aggregation.lisp
  ├─ np_diff                          → aggregation.lisp
  ├─ np_logspace                      → constructors.lisp
  ├─ np_outer                         → linalg.lisp
  └─ 7 notebooks (data science, engineering)

Phase 4: signal + image (7 functions, 1 new subsystem)
  ├─ np_fft, np_ifft, np_convolve    → signal.lisp (new)
  ├─ np_clip                          → elementwise.lisp
  ├─ np_imread, np_imwrite            → image.lisp (new, numerics/image subsystem)
  └─ 3 notebooks (signal processing, image manipulation)

Phase 5: Engineering applications
  └─ 2 notebooks (rc-circuit, heat-equation)
      Uses Phase 3-4 additions
```

## What can ship today

Phases 1 and 2 (12 notebooks) need zero upstream changes. They use:
- Existing numerics functions (np_solve, np_eig, np_svd, np_expm, etc.)
- Existing ax-plots functions (ax_draw2d, ax_draw3d, ax_vector_field, ax_streamline, etc.)
- Maxima's built-in symbolic functions (diff, integrate, taylor, solve, ode2)

## IDE fix that helps everything

The **plot persistence** fix in Aximar (saving Plotly JSON to .macnb files) is a small change that benefits all 24 notebooks. It should be prioritized regardless of which phase is active — without it, saved notebooks lose their visual output.

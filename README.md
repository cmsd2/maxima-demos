# Maxima Scientific Computing Demos

[![Docs](https://img.shields.io/badge/docs-online-blue)](https://cmsd2.github.io/maxima-demos/)

Notebook demos showcasing Maxima as a scientific computing platform, powered by the [numerics](https://github.com/cmsd2/maxima-numerics), [dataframes](https://github.com/cmsd2/maxima-dataframes), and [ax-plots](https://github.com/cmsd2/ax-plots) packages.

Each notebook runs in [Aximar](https://github.com/cmsd2/aximar) (the Maxima notebook IDE).

Many notebooks highlight the **symbolic-numeric bridge** — Maxima's unique ability to derive formulas symbolically and evaluate them numerically in the same session. These are marked with [S+N].

## Prerequisites

```
mxpm install numerics
mxpm install dataframes
mxpm install ax-plots
brew install duckdb          # for DuckDB notebooks only
```

## Notebooks

### Visualization Showcases

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [surface-gallery.macnb](notebooks/visualization/surface-gallery.macnb) | Mathematics | Interactive 3D surfaces — saddles, torus, trig surfaces with rotation and zoom. [S+N] Compute gradient/curvature symbolically | numerics, ax-plots |
| [vector-fields.macnb](notebooks/visualization/vector-fields.macnb) | Physics | Electromagnetic fields, fluid flow, gradient fields. [S+N] Derive fields from symbolic potentials | numerics, ax-plots |
| [animations.macnb](notebooks/visualization/animations.macnb) | Mathematics / Physics | Animated visualizations: wave propagation, diffusion, ODE trajectories, pendulum. Uses Plotly animation frames | numerics, ax-plots |

### Symbolic-Numeric Bridge

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [taylor-convergence.macnb](notebooks/symbolic-numeric/taylor-convergence.macnb) | Mathematics | [S+N] Symbolic Taylor series → numeric evaluation → convergence plots | numerics, ax-plots |
| [symbolic-jacobian.macnb](notebooks/symbolic-numeric/symbolic-jacobian.macnb) | Mathematics | [S+N] Derive Jacobian with `diff()`, evaluate numerically, visualize stability regions | numerics, ax-plots |
| [symbolic-integration.macnb](notebooks/symbolic-numeric/symbolic-integration.macnb) | Mathematics | [S+N] Compare symbolic `integrate()` against numerical `np_trapz`, plot error convergence | numerics, ax-plots |

### Dynamical Systems & ODEs

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [phase-portraits.macnb](notebooks/dynamical-systems/phase-portraits.macnb) | Mathematics | [S+N] Classify fixed points via symbolic Jacobian + numeric eigenvalues, visualize with streamlines | numerics, ax-plots |
| [matrix-exponential-odes.macnb](notebooks/dynamical-systems/matrix-exponential-odes.macnb) | Physics | [S+N] Solve dx/dt = Ax via `np_expm`, derive general solution symbolically, plot 2D/3D trajectories | numerics, ax-plots |
| [control-systems.macnb](notebooks/dynamical-systems/control-systems.macnb) | Electrical Engineering | [S+N] Symbolic transfer function H(s), `solve()` for poles, numeric step response and Bode plot | numerics, ax-plots |

### Linear Algebra

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [linear-systems.macnb](notebooks/linear-algebra/linear-systems.macnb) | Engineering | [S+N] Set up circuit equations symbolically (KVL/KCL), solve numerically with `np_solve`, visualize residuals and condition numbers | numerics, ax-plots |
| [eigenvalue-analysis.macnb](notebooks/linear-algebra/eigenvalue-analysis.macnb) | Mechanical Engineering | [S+N] Derive mass/stiffness matrices from symbolic equations of motion, compute vibration modes numerically | numerics, ax-plots |
| [svd-low-rank.macnb](notebooks/linear-algebra/svd-low-rank.macnb) | Data Science | SVD-based matrix approximation, reconstruction error vs rank, application to data compression | numerics, ax-plots |
| [matrix-decompositions.macnb](notebooks/linear-algebra/matrix-decompositions.macnb) | Mathematics | [S+N] QR, LU, SVD side-by-side — symbolic determinant via cofactors vs numeric `np_det` | numerics, ax-plots |
| [least-squares.macnb](notebooks/linear-algebra/least-squares.macnb) | Engineering | [S+N] Build Vandermonde matrix symbolically, fit polynomials to noisy data with `np_lstsq` | numerics, ax-plots |

### Data Analysis & Statistics

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [monte-carlo.macnb](notebooks/statistics/monte-carlo.macnb) | Statistics | Pi estimation, CLT demo, bootstrap confidence intervals with `np_rand`/`np_randn` | numerics, ax-plots |
| [eda-pipeline.macnb](notebooks/statistics/eda-pipeline.macnb) | Data Science | Full pandas-style workflow: read CSV, describe, group, summarize, bar charts, histograms | dataframes, dataframes-duckdb, ax-plots |
| [sql-analytics.macnb](notebooks/statistics/sql-analytics.macnb) | Data Science | SQL queries on tabular data — CTEs, window functions, joins — from inside a CAS | dataframes, dataframes-duckdb |
| [correlation-heatmap.macnb](notebooks/statistics/correlation-heatmap.macnb) | Statistics | Compute pairwise correlation matrix with `np_corrcoef`, display with `ax_heatmap` | numerics, dataframes, ax-plots |
| [pca.macnb](notebooks/statistics/pca.macnb) | Data Science | PCA from scratch — `np_cov` → `np_eig` → project → scatter plots before/after | numerics, dataframes, ax-plots |

### Signal Processing & Image Manipulation

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [signal-processing.macnb](notebooks/signal-image/signal-processing.macnb) | Electrical Engineering | [S+N] Generate signals, FFT, frequency-domain filtering, IFFT. Symbolic Fourier coefficients vs numeric FFT | numerics, ax-plots |
| [image-processing.macnb](notebooks/signal-image/image-processing.macnb) | Computer Vision | [S+N] Load real images with `np_imread`, point ops, convolution (blur, sharpen, edge detection). Derive Gaussian kernel symbolically | numerics, ax-plots |
| [spectral-analysis.macnb](notebooks/signal-image/spectral-analysis.macnb) | Physics | [S+N] Chirp, AM, square wave — PSD, windowing, spectrogram. Symbolic Fourier series and Gibbs phenomenon | numerics, ax-plots |

### Optimisation & Control

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [pid-tuning.macnb](notebooks/optimisation/pid-tuning.macnb) | Control Engineering | [S+N] Derive PID controller C(s) symbolically, closed-loop transfer function, numeric parameter sweep over Kp/Ki/Kd, cost surface visualisation, step response comparison | numerics, ax-plots |
| [gradient-descent.macnb](notebooks/optimisation/gradient-descent.macnb) | Mathematics / ML | [S+N] Symbolic gradient via `diff()`, numeric descent on Rosenbrock and quadratic surfaces, trajectory overlay on contour plots | numerics, ax-plots |

### Engineering Applications

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [beam-deflection.macnb](notebooks/engineering/beam-deflection.macnb) | Civil/Mechanical Engineering | [S+N] Derive beam ODE symbolically, solve with `ode2()`, compare against FEM with `np_solve` | numerics, ax-plots |
| [rc-circuit.macnb](notebooks/engineering/rc-circuit.macnb) | Electrical Engineering | [S+N] Symbolic KVL → state-space → `np_expm` transient, symbolic H(s), numeric Bode plot | numerics, ax-plots |
| [heat-equation.macnb](notebooks/engineering/heat-equation.macnb) | Mechanical Engineering | [S+N] Symbolic PDE → FD stencil → stability analysis → numeric time-stepping → animated heatmap | numerics, ax-plots |

## Feature Coverage Matrix

| Feature | Notebooks using it |
|---------|--------------------|
| `np_solve` | linear-systems, beam-deflection |
| `np_eig` | eigenvalue-analysis, pca, phase-portraits, control-systems |
| `np_svd` | svd-low-rank, pca |
| `np_lstsq` | least-squares |
| `np_expm` | matrix-exponential-odes, control-systems, rc-circuit, pid-tuning |
| `np_matmul` | heat-equation, pca, monte-carlo |
| `np_fft` / `np_ifft` | signal-processing, spectral-analysis |
| `np_convolve` | signal-processing, image-processing |
| `np_imread` / `np_imwrite` | image-processing |
| `np_rand` / `np_randn` | monte-carlo, least-squares |
| `np_corrcoef` / `np_cov` | correlation-heatmap, pca |
| `np_trapz` | symbolic-integration |
| `df_read_csv` | eda-pipeline |
| `df_group_by` / `df_summarize` | eda-pipeline, sql-analytics |
| `df_sql` | sql-analytics, eda-pipeline |
| `df_describe` | eda-pipeline, correlation-heatmap |
| `ax_draw2d` / `ax_draw3d` | most notebooks |
| `ax_heatmap` | correlation-heatmap, heat-equation, image-processing, spectral-analysis |
| `ax_vector_field` / `ax_streamline` | phase-portraits, vector-fields |
| `ax_bar` / `ax_histogram` | eda-pipeline, monte-carlo |
| `ax_contour` | surface-gallery, gradient-descent, pid-tuning |
| `ax_animate` | animations, heat-equation |
| Symbolic `diff()` | symbolic-jacobian, phase-portraits, surface-gallery, vector-fields, eigenvalue-analysis, gradient-descent |
| Symbolic `integrate()` | symbolic-integration, signal-processing |
| Symbolic `taylor()` | taylor-convergence |
| Symbolic `solve()` | control-systems, rc-circuit, pid-tuning |
| Symbolic `ode2()` | beam-deflection |

## License

[CC0 1.0](LICENSE)

# Maxima Scientific Computing Demos

[![Docs](https://img.shields.io/badge/docs-online-blue)](https://cmsd2.github.io/maxima-demos/)

Notebook demos showcasing Maxima as a scientific computing platform, powered by the [numerics](https://github.com/cmsd2/maxima-numerics), [dataframes](https://github.com/cmsd2/maxima-dataframes), and [ax-plots](https://github.com/cmsd2/ax-plots) packages.

Each notebook runs in [Aximar](https://github.com/cmsd2/aximar) (the Maxima notebook IDE).

Many notebooks highlight the **symbolic-numeric bridge** — Maxima's unique ability to derive formulas symbolically and evaluate them numerically in the same session. These are marked with [S+N].

## Prerequisites

```
mxpm install numerics
mxpm install numerics-optimize  # for ML and optimization notebooks (L-BFGS)
mxpm install numerics-image     # for image processing notebook
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
| [correlation-heatmap.macnb](notebooks/statistics/correlation-heatmap.macnb) | Statistics | Compute pairwise correlation matrix with `np_corrcoef`, display with `ax_heatmap` | numerics, dataframes, ax-plots |
| [pca.macnb](notebooks/statistics/pca.macnb) | Data Science | PCA from scratch — `np_cov` → `np_eig` → project → scatter plots before/after | numerics, dataframes, ax-plots |
| [eda-pipeline.macnb](notebooks/data-science/eda-pipeline.macnb) | Data Science | Full pandas-style workflow: read CSV, describe, group, summarize, bar charts, histograms | dataframes, dataframes-duckdb, ax-plots |
| [sql-analytics.macnb](notebooks/data-science/sql-analytics.macnb) | Data Science | SQL queries on tabular data — CTEs, window functions, joins — from inside a CAS | dataframes, dataframes-duckdb |

### Signal & Image Processing

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [signal-processing.macnb](notebooks/signal-image/signal-processing.macnb) | Electrical Engineering | [S+N] Generate signals, FFT, frequency-domain filtering, IFFT, convolution. Symbolic Fourier coefficients vs numeric FFT | numerics, ax-plots |
| [spectral-analysis.macnb](notebooks/signal-image/spectral-analysis.macnb) | Physics | [S+N] Chirp, AM, square wave — PSD, windowing, spectrogram. Symbolic Fourier series and Gibbs phenomenon | numerics, ax-plots |
| [image-processing.macnb](notebooks/signal-image/image-processing.macnb) | Computer Vision | Load images, greyscale conversion, 2D convolution — box blur, Sobel edge detection, sharpening, emboss. 2D FFT frequency-domain filtering | numerics, numerics-image |

### Machine Learning

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [ml-fundamentals.macnb](notebooks/machine-learning/ml-fundamentals.macnb) | Machine Learning | [S+N] Linear regression, logistic regression, K-means — symbolic gradient derivation with `diff()` then numeric gradient descent | numerics, ax-plots |

### Optimization & Inverse Problems

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [curve-fitting.macnb](notebooks/optimisation/curve-fitting.macnb) | Statistics | [S+N] Nonlinear curve fitting — symbolic gradient derivation with `diff()`, optimize with `np_minimize`. Exponential decay, Gaussian peak, confidence intervals | numerics, numerics-optimize, ax-plots |
| [mle.macnb](notebooks/optimisation/mle.macnb) | Statistics | [S+N] Maximum likelihood estimation — Normal, Gamma, logistic regression. Symbolic log-likelihood → score function → `np_minimize` | numerics, numerics-optimize, ax-plots |
| [inverse-problems.macnb](notebooks/optimisation/inverse-problems.macnb) | Physics/Engineering | [S+N] Recover physical parameters from noisy data — `ode2()` solutions as forward model, `np_minimize` for parameter recovery, Tikhonov regularization | numerics, numerics-optimize, ax-plots |
| [control-tuning.macnb](notebooks/optimisation/control-tuning.macnb) | Control Engineering | [S+N] PID gain tuning — symbolic state-space, numeric step response simulation, ISE/ITAE minimization with `np_minimize` | numerics, numerics-optimize, ax-plots |

### Engineering Applications

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [beam-deflection.macnb](notebooks/engineering/beam-deflection.macnb) | Civil/Mechanical Engineering | [S+N] Derive beam ODE symbolically, solve with `ode2()`, compare against FEM with `np_solve` | numerics, ax-plots |
| [control-systems.macnb](notebooks/engineering/control-systems.macnb) | Electrical Engineering | [S+N] Symbolic transfer function H(s), `solve()` for poles, numeric step response and Bode plot | numerics, ax-plots |

## Feature Coverage Matrix

| Feature | Notebooks using it |
|---------|--------------------|
| `np_solve` | linear-systems, beam-deflection |
| `np_eig` | eigenvalue-analysis, pca, phase-portraits, control-systems |
| `np_svd` | svd-low-rank, pca |
| `np_lstsq` | least-squares, ml-fundamentals |
| `np_expm` | matrix-exponential-odes, control-systems, control-tuning, inverse-problems |
| `np_matmul` | pca, monte-carlo, ml-fundamentals |
| `np_fft` / `np_ifft` | signal-processing, spectral-analysis |
| `np_fft2d` / `np_ifft2d` | image-processing |
| `np_convolve` | signal-processing |
| `np_convolve2d` | image-processing |
| `np_imshow` | image-processing |
| `np_mandrill` | image-processing |
| `np_rand` / `np_randn` | monte-carlo, least-squares, ml-fundamentals |
| `np_corrcoef` / `np_cov` | correlation-heatmap, pca |
| `np_trapz` | symbolic-integration |
| `df_read_csv` | eda-pipeline |
| `df_group_by` / `df_summarize` | eda-pipeline, sql-analytics |
| `df_sql` | sql-analytics, eda-pipeline |
| `df_describe` | eda-pipeline, correlation-heatmap |
| `ax_draw2d` / `ax_draw3d` | most notebooks |
| `ax_heatmap` | correlation-heatmap, spectral-analysis |
| `ax_vector_field` / `ax_streamline` | phase-portraits, vector-fields |
| `ax_bar` / `ax_histogram` | eda-pipeline, monte-carlo |
| `ax_contour` | surface-gallery |
| `np_argmin` / `np_argmax` | ml-fundamentals |
| `np_where` | ml-fundamentals |
| `np_clip` | ml-fundamentals, image-processing |
| `np_minimize` | ml-fundamentals, curve-fitting, mle, inverse-problems, control-tuning |
| `np_inv` | curve-fitting, mle |
| `np_eval` | inverse-problems |
| Symbolic `diff()` | symbolic-jacobian, phase-portraits, surface-gallery, vector-fields, eigenvalue-analysis, ml-fundamentals, curve-fitting, mle |
| Symbolic `integrate()` | symbolic-integration, signal-processing |
| Symbolic `taylor()` | taylor-convergence |
| Symbolic `solve()` | control-systems |
| Symbolic `ode2()` | beam-deflection, inverse-problems |

## License

[CC0 1.0](LICENSE)

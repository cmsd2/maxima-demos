# Maxima Scientific Computing Demos

Notebook demos showcasing Maxima as a scientific computing platform, powered by the [numerics](https://github.com/cmsd2/maxima-numerics), [dataframes](https://github.com/cmsd2/maxima-dataframes), and [ax-plots](https://github.com/cmsd2/ax-plots) packages.

Each notebook runs in [Aximar](https://github.com/cmsd2/aximar) (the Maxima notebook IDE).

## Prerequisites

```
mxpm install numerics
mxpm install dataframes
mxpm install ax-plots
brew install duckdb          # for DuckDB notebooks only
```

## Notebooks

### Linear Algebra

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [linear-systems.macnb](notebooks/linear-systems.macnb) | Engineering | Solve Ax=b for truss/circuit problems, visualize residuals, demonstrate condition numbers and ill-conditioning | numerics, ax-plots |
| [eigenvalue-analysis.macnb](notebooks/eigenvalue-analysis.macnb) | Mechanical Engineering | Eigenvalues of mass-spring systems, vibration modes, visualize mode shapes | numerics, ax-plots |
| [svd-low-rank.macnb](notebooks/svd-low-rank.macnb) | Data Science | SVD-based matrix approximation, reconstruction error vs rank, application to data compression | numerics, ax-plots |
| [matrix-decompositions.macnb](notebooks/matrix-decompositions.macnb) | Mathematics | QR, LU, SVD side-by-side — factor, verify, compare numerical stability | numerics |

### Curve Fitting & Regression

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [least-squares.macnb](notebooks/least-squares.macnb) | Engineering | Fit polynomials and models to noisy sensor data with `np_lstsq`, plot fits with confidence | numerics, ax-plots |
| [pca.macnb](notebooks/pca.macnb) | Data Science | PCA from scratch — covariance, eigendecomposition, projection, explained variance, scatter plots before/after | numerics, dataframes, ax-plots |

### Dynamical Systems & ODEs

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [matrix-exponential-odes.macnb](notebooks/matrix-exponential-odes.macnb) | Physics | Solve linear ODE systems dx/dt = Ax via `np_expm`, plot trajectories in 2D and 3D | numerics, ax-plots |
| [phase-portraits.macnb](notebooks/phase-portraits.macnb) | Mathematics | Classify fixed points (node, spiral, saddle) using eigenvalues, visualize with vector fields and streamlines | numerics, ax-plots |
| [control-systems.macnb](notebooks/control-systems.macnb) | Electrical Engineering | State-space models, step response via matrix exponential, stability from eigenvalues, pole-zero plots | numerics, ax-plots |

### Symbolic-Numeric Bridge

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [symbolic-jacobian.macnb](notebooks/symbolic-jacobian.macnb) | Mathematics | Derive Jacobian symbolically with `diff()`, evaluate numerically, analyze stability — Maxima's unique strength | numerics, ax-plots |
| [taylor-convergence.macnb](notebooks/taylor-convergence.macnb) | Mathematics | Symbolic Taylor series, evaluate successive approximations with ndarrays, plot convergence | numerics, ax-plots |
| [symbolic-integration.macnb](notebooks/symbolic-integration.macnb) | Mathematics | Compare Maxima's symbolic `integrate()` against numerical trapezoidal/Simpson's rule on ndarrays | numerics, ax-plots |

### Data Analysis & Statistics

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [eda-pipeline.macnb](notebooks/eda-pipeline.macnb) | Data Science | Full pandas-style workflow: read CSV, describe, group, summarize, bar charts, histograms | dataframes, dataframes-duckdb, ax-plots |
| [sql-analytics.macnb](notebooks/sql-analytics.macnb) | Data Science | SQL queries on tabular data — CTEs, window functions, joins — from inside a CAS | dataframes, dataframes-duckdb |
| [correlation-heatmap.macnb](notebooks/correlation-heatmap.macnb) | Statistics | Compute pairwise correlations from table columns, display with `ax_heatmap` | numerics, dataframes, ax-plots |
| [monte-carlo.macnb](notebooks/monte-carlo.macnb) | Statistics | Pi estimation, bootstrap confidence intervals, option pricing with `np_rand`/`np_randn` | numerics, ax-plots |

### Engineering Applications

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [beam-deflection.macnb](notebooks/beam-deflection.macnb) | Civil/Mechanical Engineering | Symbolic beam equations, numeric FEM-style discretization, solve with `np_solve`, plot deflection curves | numerics, ax-plots |
| [rc-circuit.macnb](notebooks/rc-circuit.macnb) | Electrical Engineering | RC/RLC circuit transient analysis via matrix exponential, symbolic transfer functions, Bode-style frequency plots | numerics, ax-plots |
| [heat-equation.macnb](notebooks/heat-equation.macnb) | Mechanical Engineering | 1D heat equation via finite differences, time-stepping with matrix multiply, heatmap visualization | numerics, ax-plots |

### Visualization Showcases

| Notebook | Domain | Description | Packages |
|----------|--------|-------------|----------|
| [surface-gallery.macnb](notebooks/surface-gallery.macnb) | Mathematics | Interactive 3D surfaces — saddles, paraboloids, trig surfaces with rotation and zoom | ax-plots |
| [vector-fields.macnb](notebooks/vector-fields.macnb) | Physics | Electromagnetic fields, fluid flow, gradient fields with `ax_vector_field` and `ax_streamline` | ax-plots |

## Feature Coverage Matrix

| Feature | Notebooks using it |
|---------|--------------------|
| `np_solve` | linear-systems, beam-deflection |
| `np_eig` | eigenvalue-analysis, pca, phase-portraits, control-systems |
| `np_svd` | svd-low-rank, pca |
| `np_lstsq` | least-squares |
| `np_expm` | matrix-exponential-odes, control-systems, rc-circuit, heat-equation |
| `np_matmul` | heat-equation, pca, monte-carlo |
| `np_rand` / `np_randn` | monte-carlo, least-squares |
| `df_read_csv` | eda-pipeline |
| `df_group_by` / `df_summarize` | eda-pipeline, sql-analytics |
| `df_sql` | sql-analytics, eda-pipeline |
| `df_describe` | eda-pipeline, correlation-heatmap |
| `ax_draw2d` / `ax_draw3d` | most notebooks |
| `ax_heatmap` | correlation-heatmap, heat-equation |
| `ax_vector_field` / `ax_streamline` | phase-portraits, vector-fields |
| `ax_bar` / `ax_histogram` | eda-pipeline, monte-carlo |
| `ax_contour` | surface-gallery, heat-equation |
| Symbolic `diff()` / `integrate()` | symbolic-jacobian, symbolic-integration, beam-deflection, taylor-convergence |

## License

MIT

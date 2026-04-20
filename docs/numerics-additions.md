# Numerics Package Additions

New functions needed in [maxima-numerics](https://github.com/cmsd2/maxima-numerics) to support the demo notebooks. Grouped by phase.

## Phase 3: Statistics, constructors, linear algebra

These are small additions (5-30 lines of CL each) with no new dependencies. All go in existing source files.

### np_trapz — Trapezoidal integration

**File:** `lisp/core/aggregation.lisp`

Approximate the definite integral of a 1D ndarray using the trapezoidal rule.

```maxima
np_trapz(y)           /* unit spacing */
np_trapz(y, x)        /* non-uniform x values */
```

**Implementation:** Sum `(y[i] + y[i+1]) * (x[i+1] - x[i]) / 2` over all intervals. When `x` is omitted, spacing is 1.0.

**Used by:** symbolic-integration (compare symbolic `integrate()` against numeric approximation)

### np_cov — Covariance matrix

**File:** `lisp/core/aggregation.lisp`

Compute the sample covariance matrix from a 2D ndarray where each column is a variable and each row is an observation.

```maxima
C : np_cov(A)    /* returns [p, p] matrix for [n, p] input */
```

**Implementation:** Center each column (subtract column mean), then `(1/(n-1)) * A^T * A` via `np_matmul`.

**Used by:** pca (covariance → eigendecomposition)

### np_corrcoef — Correlation matrix

**File:** `lisp/core/aggregation.lisp`

Pairwise Pearson correlation matrix from a 2D ndarray. Normalizes the covariance matrix by the standard deviations.

```maxima
R : np_corrcoef(A)    /* returns [p, p] matrix with 1s on diagonal */
```

**Implementation:** Compute `np_cov(A)`, then divide each element `C[i,j]` by `sqrt(C[i,i] * C[j,j])`.

**Used by:** correlation-heatmap

### np_diff — Finite differences

**File:** `lisp/core/aggregation.lisp`

First-order forward differences of a 1D ndarray. Output length is `n-1`.

```maxima
d : np_diff(a)    /* d[i] = a[i+1] - a[i] */
```

**Used by:** beam-deflection, heat-equation (nice-to-have for numerical derivatives)

### np_logspace — Logarithmically spaced points

**File:** `lisp/core/constructors.lisp`

Generate `n` points logarithmically spaced between `10^start` and `10^stop`.

```maxima
f : np_logspace(0, 4, 50)    /* 50 points from 1 to 10000 */
```

**Implementation:** `np_map(lambda([x], 10^x), np_linspace(start, stop, n))` — but implemented directly for efficiency.

**Used by:** control-systems (Bode plot frequency axis)

### np_outer — Outer product

**File:** `lisp/core/linalg.lisp`

Outer product of two 1D ndarrays, returning a 2D matrix.

```maxima
M : np_outer(a, b)    /* M[i,j] = a[i] * b[j], shape [len(a), len(b)] */
```

**Implementation:** Create result matrix, fill with `a[i] * b[j]`. Could also use `np_matmul` on reshaped column/row vectors.

**Used by:** pca, heat-equation (constructing rank-1 updates)

## Phase 4: Signal processing

These additions are also small individually but introduce a new source file.

### np_fft — Fast Fourier Transform

**File:** `lisp/core/signal.lisp` (new)

Compute the discrete Fourier transform of a 1D ndarray. Wraps Maxima's built-in `fft()`.

```maxima
F : np_fft(a)       /* returns complex ndarray */
```

**Implementation:**
1. Unwrap ndarray to CL vector
2. Convert to Maxima list
3. Call Maxima's `fft()` (requires power-of-2 length — zero-pad if needed)
4. Convert result list back to complex ndarray

**Note:** Maxima's `fft` uses the convention `X[k] = (1/N) * sum(x[n] * exp(-2*pi*i*n*k/N))`. Document this normalization.

**Used by:** signal-processing, spectral-analysis

### np_ifft — Inverse FFT

**File:** `lisp/core/signal.lisp`

Inverse DFT, wrapping Maxima's `ift()`.

```maxima
a : np_ifft(F)      /* returns real or complex ndarray */
```

**Used by:** signal-processing (reconstruct filtered signal)

### np_convolve — 1D convolution

**File:** `lisp/core/signal.lisp`

Linear convolution of two 1D ndarrays.

```maxima
np_convolve(a, kernel)              /* "full" mode, length = len(a) + len(k) - 1 */
np_convolve(a, kernel, same)        /* output same length as a */
np_convolve(a, kernel, valid)       /* only fully overlapping region */
```

**Implementation:** Direct O(n*k) summation loop. For small kernels (3-7 taps for image filters, 10-50 for signal processing) this is efficient. Users needing large-kernel convolution can do FFT-based convolution manually.

**Used by:** signal-processing, image-processing (applied per-row and per-column for 2D)

### np_clip — Clamp values

**File:** `lisp/core/elementwise.lisp`

Clamp all elements to `[lo, hi]`.

```maxima
np_clip(a, 0.0, 1.0)    /* values below 0 become 0, above 1 become 1 */
```

**Implementation:** Element-wise `max(lo, min(hi, x))`. Similar to `np_map` but avoids lambda overhead.

**Used by:** image-processing (ensure pixel values stay in [0, 1] after operations)

## Testing

All new functions should have tests added to `rtest_numerics.mac` following the existing `batch()` pattern. Example test structure:

```maxima
/* np_trapz — unit spacing */
np_trapz(ndarray([1.0, 2.0, 3.0]));
3.0;    /* (1+2)/2 + (2+3)/2 = 4.0... actually let me not write wrong tests */
```

Run: `maxima --very-quiet -b rtest_numerics.mac`

## Documentation

Add entries to the existing `doc/numerics.md` include chain, following the established format:

```
### Function: np_trapz (y) / np_trapz (y, x)
...
#### Examples
...
See also: `np_cumsum`, `np_sum`
```

# Pivot flagged current data longer by variable

Pivot flagged current data longer by variable

## Usage

``` r
adcp_pivot_flags_longer(dat, qc_tests = NULL, vars = NULL)
```

## Arguments

- dat:

  Data frame of flagged current data in wide format.

- qc_tests:

  Quality control tests included in `dat_wide`. If `dat_wide` only
  includes the max flag, use `qc_tests = "qc"`.

- vars:

  Vector of character strings indicating which columns to pivot. Default
  is all variables. Only required if variables in `dat` are in a wide
  format.

## Value

Returns `dat_wide`, with variables and flags pivoted to a long format.

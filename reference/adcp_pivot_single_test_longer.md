# Complete pivot_longer of flagged current data

Complete pivot_longer of flagged current data

## Usage

``` r
adcp_pivot_single_test_longer(dat_wide, qc_test)
```

## Arguments

- dat_wide:

  Data frame of flagged current data with the variables in a long format
  and flags in wide format.

- qc_test:

  Flag columns to pivot.

## Value

Returns `dat_wide` with the qc_test flag columns pivoted to a long
format.

# Assign each observation the maximum flag from applied QC tests.

Assign each observation the maximum flag from applied QC tests.

## Usage

``` r
adcp_assign_max_flag(dat, qc_tests = NULL, return_all = TRUE)
```

## Arguments

- dat:

  Data frame in long or wide format with flag columns from multiple
  quality control tests.

- qc_tests:

  Quality control tests included in `dat`. Default is
  `qc_tests = c("tidal_bin_height" ,"grossrange")`. Will also work for
  "rolling_sd" and "spike".

- return_all:

  Logical value indicating whether to return all quality control flag
  columns or only the summary columns. If `TRUE`, all flag columns will
  be returned. If `FALSE`, only the summary columns will be returned.
  Default is `TRUE`.

## Value

Returns `dat` in a wide format, with a single flag column for each
variable column.

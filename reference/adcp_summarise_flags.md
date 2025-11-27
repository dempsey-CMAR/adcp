# Generate summary table of flags

Generate summary table of flags

## Usage

``` r
adcp_summarise_flags(dat, ...)
```

## Arguments

- dat:

  Data frame of wave data with variables and grossrange ranges in a long
  format. Depth flag (`depth_trim_flag`) should be in a separate column.

- ...:

  Optional argument. Column names (not quoted) from `dat` to use as
  grouping variables.

## Value

Returns a data frame with the number and percent of observations
assigned each flag value for each variable, qc_test, and groups in
`...`.

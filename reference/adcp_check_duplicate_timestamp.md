# Check for duplicate timestamp values

Check for duplicate timestamp values

## Usage

``` r
adcp_check_duplicate_timestamp(dat_wide)
```

## Arguments

- dat_wide:

  Data frame of ADCP data, as returned from
  [`adcp_read_txt()`](https://dempsey-cmar.github.io/adcp/reference/adcp_read_txt.md).

## Value

If duplicate timestamps are detected, returns a warning and `TRUE`.
Otherwise returns `FALSE`.

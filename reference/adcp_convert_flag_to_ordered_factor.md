# Convert depth_flag column to ordered factor

Convert depth_flag column to ordered factor

## Usage

``` r
adcp_convert_flag_to_ordered_factor(dat)
```

## Arguments

- dat:

  Data frame of ACDP data in long format, as returned by
  [`adcp_flag_data()`](https://dempsey-cmar.github.io/adcp/reference/adcp_flag_data.md).

## Value

Returns `dat`, with the `depth_flag` column as an ordered factor, with
levels
`"good" < "SENSOR_DEPTH_BELOW_SURFACE changed by > x m" < "manual flag"`.

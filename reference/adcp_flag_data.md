# Flag ensembles with suspect sensor_depth_below_surface_m recordings

Flag ensembles with suspect sensor_depth_below_surface_m recordings

## Usage

``` r
adcp_flag_data(dat, depth_flag_threshold = 1)
```

## Arguments

- dat:

  Dataframe of ACDP data in long format, as returned by
  `adcp_pivot_longer()`.

- depth_flag_threshold:

  The change in `sensor_depth_below_surface_m` that will trigger a flag
  (in metres).

## Value

Returns `dat` with two extra columns for inspection: `depth_diff` =
lead(sensor_depth_below_surface_m) - sensor_depth_below_surface_m and
`depth_flag`.

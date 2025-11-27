# Flag observations that should be trimmed from beginning and end of deployment

A change in `sensor_depth_below_surface_m` greater than
`depth_threshold` at the beginning or end of the deployment will trigger
a flag of 4. This assumes that the sensor was recording before or after
the ADCP was deployed. Observations of all variables at this timestamp
should be filtered out of the data set.

## Usage

``` r
adcp_start_end_obs_to_trim(dat, depth_threshold = 1, return_depth_diff = FALSE)
```

## Arguments

- dat:

  Data frame of current data for a single deployment in wide format.

- depth_threshold:

  The change in `sensor_depth_below_surface_m` that will trigger a flag
  of 4 (in metres). Default is 1.0 m.

- return_depth_diff:

  Logical argument indicating whether to return the column of
  `depth_diff` = abs(lead(sensor_depth_below_surface_m) -
  sensor_depth_below_surface_m).

## Value

Returns `dat` with the flag column
`trim_flag_sensor_depth_below_surface_m` (and optionally `depth_diff`.

## Details

Only looks at the first three and last three observations.

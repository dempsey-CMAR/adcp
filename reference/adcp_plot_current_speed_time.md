# Plot histogram of speed observations

Plot histogram of speed observations

## Usage

``` r
adcp_plot_current_speed_time(dat)
```

## Arguments

- dat:

  Data frame that includes columns `station`,
  `bin_height_above_sea_floor_m`, `sea_water_speed_cm_s` and
  `timestamp_utc`.

## Value

Returns a ggplot object.

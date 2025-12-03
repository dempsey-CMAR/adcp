# Convert bin_height_above_sea_floor_m column to ordered factor

Depths are assigned levels in descending order so that figures will have
shallowest bins at the top and deepest bins at the bottom of the figure.

## Usage

``` r
adcp_convert_bin_height_to_ordered_factor(dat)
```

## Arguments

- dat:

  Data frame that includes the column `bin_height_above_sea_floor_m`.

## Value

Returns data with `bin_height_above_sea_floor_m` as an ordered factor.

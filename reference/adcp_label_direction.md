# Cut wind direction into 8 bins

Adapted from `cutVecWinddir()` from `OpenAir`.

## Usage

``` r
adcp_label_direction(dat)
```

## Arguments

- dat:

  Data frame with column sea_water_to_direction_degree.

## Value

Returns `dat` with an additional column
`sea_water_to_direction_degree_labels`, the direction labels as an
ordered factor.

## Details

Likely more efficient in the original vectorized form. Modified to match
[`adcp_label_speed()`](https://dempsey-cmar.github.io/adcp/reference/adcp_label_speed.md).
Could re-visit both.

Assigns direction data in bins of 45 degree C. -22.5 to 22.5 degree is
North, 22.5 to 67.5 is NNE, etc.

# Plot histogram of speed observations

Plot histogram of speed observations

## Usage

``` r
adcp_plot_speed_hist(
  dat,
  pal = NULL,
  speed_col = sea_water_speed_cm_s_labels,
  text_size = 3,
  speed_label = "Current Speed (cm/s)"
)
```

## Arguments

- dat:

  Data frame with at least 3 columns: a factor of speed groups, `n`, the
  number of observations in each group, and `n_percent`, the percent of
  observations in each group. The proportion is automatically converted
  to percent for the figure.

- pal:

  Vector of colours. Must be the same length as the number of speed
  factor levels.

- speed_col:

  The column in `dat` that holds the speed groups (NOT QUOTED).

- text_size:

  Size of the text annotating the number of observations in each bin.

- speed_label:

  Title of the current speed legend. Default is "Current Speed (cm/s)".

## Value

Returns a ggplot object.

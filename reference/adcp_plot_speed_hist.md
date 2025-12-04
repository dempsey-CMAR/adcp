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

  Data frame with at least 1 columns: a factor of speed groups. The
  proportion and percent of observations in each group is counted in the
  function.

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

# Plot histogram of speed observations

Plot histogram of speed observations

## Usage

``` r
adcp_plot_speed_hist(
  dat_hist,
  bar_cols,
  text_size = 3,
  speed_label = "Current Speed (cm/s)"
)
```

## Arguments

- dat_hist:

  Data frame that includes columns `bins_plot` (text), `prop`, and
  `freq`.

- bar_cols:

  Vector of colours. Must be the same length as the number of bins to
  plot.

- text_size:

  Size of the text annotating the number of observations in each bin.

- speed_label:

  Title of the current speed legend. Default is "Current Speed (cm/s)".

## Value

Returns a ggplot object.

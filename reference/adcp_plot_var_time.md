# Plot histogram of speed observations

Plot histogram of speed observations

## Usage

``` r
adcp_plot_var_time(
  dat,
  plot_col,
  y_axis_label = NULL,
  geom = "line",
  date_format = "%Y-%b-%d",
  pal = "#000000"
)
```

## Arguments

- dat:

  Data frame that includes columns `timestamp_utc` (POSIXct), and
  `plot_col` (numeric).

- plot_col:

  Column to plot (UNQUOTED).

- y_axis_label:

  Character string for the y-axis title. Could hard code some options.

- geom:

  Character value indicating which geom to use. Options are "point" or
  "line."

- date_format:

  Character string indicating the format for the date labels.

- pal:

  Single colour value (hex code or number).

## Value

Returns a ggplot object.

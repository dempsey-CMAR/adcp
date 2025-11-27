# Create ggplot for one current qc_test and variable

Create ggplot for one current qc_test and variable

## Usage

``` r
adcp_ggplot_flags(
  dat,
  qc_test,
  n_col = NULL,
  flag_title = TRUE,
  plotly_friendly = FALSE,
  legend_position = "right"
)
```

## Arguments

- dat:

  Data frame of flagged current data in long format. Must include a
  column named with the string "\_flag_value".

- qc_test:

  qc test to plot.

- n_col:

  Number of columns for faceted plots.

- flag_title:

  Logical argument indicating whether to include a ggtitle of the qc
  test and variable plotted.

- plotly_friendly:

  Logical argument. If `TRUE`, the legend will be plotted when
  [`plotly::ggplotly`](https://rdrr.io/pkg/plotly/man/ggplotly.html) is
  called on `p`. Default is `FALSE`, which makes the legend look better
  in a static figure.

- legend_position:

  Legend position. Default is "right".

## Value

Returns a ggplot object; a figure for `qc_test`. Points are coloured by
the flag value and panels are faceted by depth and sensor.

# Plot current data coloured by flag value

Plot current data coloured by flag value

## Usage

``` r
adcp_plot_flags(
  dat,
  qc_tests = c("tidal_bin_height", "grossrange", "qc"),
  vars = "all",
  labels = TRUE,
  n_col = NULL,
  flag_title = TRUE,
  plotly_friendly = FALSE,
  legend_position = "right"
)
```

## Arguments

- dat:

  Data frame of flagged current data in long or wide format. Must
  include at least one column name with the string "\_flag_variable".

- qc_tests:

  Character string of QC tests to plot. Default is
  `qc_tests = c("tidal_bin_height", "grossrange", "qc")`. Will also work
  for "rolling_sd" and "spike".

- vars:

  Character vector of variables to plot. Default is `vars = "all"`,
  which will make a plot for each recognized variable in `dat`.

- labels:

  Logical argument indicating whether to convert numeric flag values to
  text labels for the legend.

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

Returns a list of ggplot objects; one figure for each test in `qc_tests`
and variable in `vars`. Points are coloured by the flag value and panels
are faceted by depth and sensor. faceted by depth and sensor.

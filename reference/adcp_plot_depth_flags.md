# Plot sensor_depth_below_surface_m coloured by depth_flag

Plot sensor_depth_below_surface_m coloured by depth_flag

## Usage

``` r
adcp_plot_depth_flags(dat, plotly_friendly = FALSE)
```

## Arguments

- dat:

  Data frame of ACDP data in long format, including `depth_flag` column,
  as exported from `adcp_flag_data()`.

- plotly_friendly:

  Logical argument. If `TRUE`, the legend will be plotted when
  [`plotly::ggplotly`](https://rdrr.io/pkg/plotly/man/ggplotly.html) is
  called on `p`. Default is `FALSE`, which makes the legend look better
  in a static figure.

## Value

ggplot object. Figure shows sensor_depth_below_surface_m over time,
coloured by the `depth_flag` column.

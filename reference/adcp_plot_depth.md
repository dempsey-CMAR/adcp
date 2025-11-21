# Plot sensor_depth_below_surface_m

Plot sensor_depth_below_surface_m

## Usage

``` r
adcp_plot_depth(dat, title = NULL, date_format = "%Y-%b-%d", geom = "point")
```

## Arguments

- dat:

  Data frame of ACDP data in long format, as returned by
  `adcp_format_opendata()`.

- title:

  Optional title for the figure.

- date_format:

  Format for the date labels. Default is `"%Y-%b-%d"`.

- geom:

  Geom to plot. Options are `"point"` or `"line"`.

## Value

ggplot object. Figure shows sensor_depth_below_surface_m over time.

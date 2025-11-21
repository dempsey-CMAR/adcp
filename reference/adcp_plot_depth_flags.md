# Plot sensor_depth_below_surface_m coloured by depth_flag

Plot sensor_depth_below_surface_m coloured by depth_flag

## Usage

``` r
adcp_plot_depth_flags(dat, title = NULL, date_format = "%Y-%b-%d")
```

## Arguments

- dat:

  Data frame of ACDP data in long format, including `depth_flag` column,
  as exported from
  [`adcp_flag_data()`](https://dempsey-cmar.github.io/adcp/reference/adcp_flag_data.md).

- title:

  Optional title for the figure.

- date_format:

  Format for the date labels. Default is `"%Y-%b-%d"`.

## Value

ggplot object. Figure shows sensor_depth_below_surface_m over time,
coloured by the `depth_flag` column.

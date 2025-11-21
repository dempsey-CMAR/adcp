# Pivot ADCP data from bin height as column names to bin height as observations

Pivot ADCP data from bin height as column names to bin height as
observations

## Usage

``` r
adcp_pivot_bin_height(dat_wide, rm_NA = TRUE)
```

## Arguments

- dat_wide:

  Data frame of ADCP data, as returned from
  [`adcp_read_txt()`](https://dempsey-cmar.github.io/adcp/reference/adcp_read_txt.md)
  or `adcp_assign_alt()`.

- rm_NA:

  Logical argument. If `rm_NA = TRUE`, rows where `sea_water_speed_m_s`
  is `NA` OR `sea_water_to_direction_degree` is `NA` will be removed.

## Value

Returns data in a long format.

If `dat_wide` is from
[`adcp_read_txt()`](https://dempsey-cmar.github.io/adcp/reference/adcp_read_txt.md)
(i.e., bin altitude has not been assigned), then the following columns
are returned: timestamp_utc, sensor_depth_below_surface_m (SensorDepth),
bin_id (the default column names when imported using read_adcp_txt;
starts at V8), sea_water_speed_m_s (WaterSpeed), and
sea_water_to_direction_degree (WaterDirection).

If `dat_wide` is from
[`adcp_assign_altitude()`](https://dempsey-cmar.github.io/adcp/reference/adcp_assign_altitude.md),
then the following columns are returned: timestamp_utc,
sensor_depth_below_surface_m (SensorDepth), bin_depth_below_surface_m,
bin_height_above_sea_floor_m, sea_water_speed_m_s (WaterSpeed), and
sea_water_to_direction_degree (WaterDirection).

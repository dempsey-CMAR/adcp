# Add column of ADCP frequency

Add column of ADCP frequency

## Usage

``` r
adcp_add_sensor_frequency(dat)
```

## Arguments

- dat:

  Data frame including column `sensor_model` with entries
  "Sentinel_V20", "Sentinel_V50", "Sentinel_V100", and "Workhorse
  Sentinel 600kHz".

## Value

Returns dat with additional column adcp_frequency_khz.

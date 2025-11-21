# Calculate the bin depth below the surface

Calculate the bin depth below the surface

## Usage

``` r
adcp_calculate_bin_depth_old(dat, metadata = NULL, inst_alt = NULL)
```

## Arguments

- dat:

  Data frame of ACDP data in long format, as returned by
  `adcp_pivot_longer()`.

- metadata:

  Data frame with metadata information for the deployment in `dat`
  (e.g., a row from the NSDFA tracking sheet). Must include column
  `Inst_Altitude`. Option to use default value `metadata = NULL` and
  provide the required value in the `inst_alt` argument.

- inst_alt:

  Height of the instrument above the sea floor (in metres). Not used if
  `metadata` argument is specified.

## Details

Bin depth below the surface is calculated as:

bin_depth_below_surface_m = sensor_depth_below_surface_m + inst_alt -
bin_height_above_sea_floor_m

A warning is printed if any bin_depth_below_surface_m are negative.

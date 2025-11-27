# Apply tidal bin height test to adcp data

TODO need to account for the sensor height above the sea floor

## Usage

``` r
adcp_test_tidal_bin_height(
  dat,
  sensor_model = NULL,
  sensor_height_above_sea_floor_m = NULL,
  bin_height_m = NULL,
  beam_angle = NULL,
  min_prop_obs = 0.25
)
```

## Arguments

- dat:

  Data frame of current variables in wide format.

- sensor_model:

  ADCP model used to collect data. Used to determine the beam angle.
  Must be one of "Sentinel_V20", "Sentinel_V50", "Sentinel_V100", or
  "Workhorse Sentinel 600 kHz". Not required if `beam_angle` argument is
  supplied.

- sensor_height_above_sea_floor_m:

  Height of the ADCP transducer above the sea floor, in metres.

- bin_height_m:

  Height of each measurement bin in metres.

- beam_angle:

  ADCP beam angle. Only required if `sensor_model` is not provided.

- min_prop_obs:

  The proportion of observations in the bin relative to the maximum
  number of observations in a bin. Bins with prop_obs \> min_prop_obs
  and h \< hmax will be flagged 3. Bins with prop_obs \< min_prop_obs
  and h \< hmax will be flagged 4. Default is 0.25.

## Value

Returns `dat` with additional column `bin_heigh_flag_value`.

## Details

ADCP data from bins near the surface can be contaminated by "side-lobe
interference." These observations were automatically removed from the
data output by the ADCP software.

The tide can substantially impact the depth of the ADCP. At high tide,
there may be more "good" bins further from the sensor than at low tide.
The sea water speed and direction recorded in these high-altitude bins
will be accurate, but not representative of the long-term average
because they are only recorded at high-water times.

The maximum range from the ADCP for acceptable data depends on the
sensor depth and the beam angle of the ADCP:

\\h = D\*cos(theta)\\.

Accounting for the sensor height above the sea floor and averaging
across bins, the maximum acceptable range is:

\\h_max = D\*cos(theta) + sensor height above sea floor - bin height\\.

This test assigns the same flag to all data in a given bin based on this
equation and the number of observations in the bin. D is the minimum
depth recorded over the deployment, and theta is the beam angle based on
the sensor model specifications. Any bin heights greater than h +
sensor_height_above_sea_floor_m are flagged as "Suspect/Of Interest".
Any bins that also have fewer than 25 with the most observations will be
flagged "Fail."

Assumes negligible wave height.

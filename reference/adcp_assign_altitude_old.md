# Assign altitude (height above sea floor) to each bin

Assign altitude (height above sea floor) to each bin

## Usage

``` r
adcp_assign_altitude_old(
  dat_wide,
  metadata = NULL,
  inst_alt = NULL,
  bin_size = NULL,
  first_bin_range = NULL
)
```

## Arguments

- dat_wide:

  Data frame of ADCP data, as exported from
  [`adcp_read_txt()`](https://dempsey-cmar.github.io/adcp/reference/adcp_read_txt.md).

- metadata:

  Data frame with metadata information for the deployment in `dat_wide`
  (e.g., a row from the NSDFA tracking sheet). Must include columns
  `Inst_Altitude`, `Bin_Size`, and `First_Bin_Range`. Option to use
  default value `metadata = NULL` and provide the required values in the
  remaining arguments.

- inst_alt:

  Height of the sensor above the sea floor (in metres). Not used if
  `metadata` argument is specified.

- bin_size:

  Size of each bin (in metres). Not used if `metadata` argument is
  specified.

- first_bin_range:

  Distance from the transducer face to the centre of the first bin (in
  metres). Not used if `metadata` argument is specified.

## Value

Returns `dat_wide`, with bin columns re-named with corresponding
altitude (in metres).

## Details

The height to the centre of the bins is calculated as:

first bin altitude = inst altitude + first bin range

second bin altitude = first bin altitude + bin size

third bin altitude = second bin altitude + bin size

And so on.

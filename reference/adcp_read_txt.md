# Read ADCP txt file

Read raw ADCP txt file into R and format. Label each row with the
appropriate variable name (i.e., "SensorDepth", "WaterSpeed", or
"WaterDirection").

## Usage

``` r
adcp_read_txt(path, file_name = NULL, rm_dups = TRUE)
```

## Arguments

- path:

  Path to the txt file (including ".txt" extension) or to the folder
  where the txt file is saved.

- file_name:

  Required if `path` does not include the file name. Include the ".txt"
  file extension. Default is `file_name = NULL`.

- rm_dups:

  Logical argument indicating whether to remove duplicate rows. Default
  is `TRUE`. (Note: the `Num` column is removed before checking for
  duplicate rows.)

## Value

Returns a data frame of the data with a single header row and each row
labelled as "SensorDepth", "WaterSpeed", or "WaterDirection".

## Details

The `timestamp_ns` column is in the timezone of the deployment date
(e.g., "AST" if deployed in November to March and "DST" if deployed in
March to November). The `timestamp_ns` does NOT account for changes in
daylight savings time. Here, the `timestamp_ns` is assigned a timezone
of "UTC" to avoid `NA` values during the beginning of daylight savings
time (e.g., 2019-03-10 02:30:00 is NOT a valid time for the
"America/Halifax" timezone). This `timestamp_ns` can be converted to
true UTC using
[`adcp_correct_timestamp()`](https://dempsey-cmar.github.io/adcp/reference/adcp_correct_timestamp.md).

A warning will be printed if duplicate `timestamp_ns` are detected.

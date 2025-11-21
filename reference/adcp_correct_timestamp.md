# Convert timestamp to UTC from AST or DST

Convert timestamp to UTC from AST or DST

## Usage

``` r
adcp_correct_timestamp(dat, rm = TRUE)
```

## Arguments

- dat:

  Data frame with at least one column `timestamp_ns` (long or wide
  format).

- rm:

  Logical argument. If `TRUE` the original `timestamp_ns` column will be
  removed.

## Value

Returns `dat` with `timestamp_utc` in true UTC.

## Details

For the raw ADCP data, the timestamp column is in the timezone of the
deployment date (e.g., "AST" if deployed in November to March and "DST"
if deployed in March to November). The timestamp does NOT account for
changes in daylight savings time.

`adcp_read_text()` assigns the timestamp a timezone of "UTC" to avoid
`NA` values during the beginning of daylight savings time (e.g.,
2019-03-10 02:30:00 is NOT a valid time for the "America/Halifax"
timezone).

`adcp_correct_timestamp()` converts each timestamp to true UTC by adding
3 hours if the deployment date was during daylight savings, or 4 hours
if the deployment date was during Atlantic Standard Time.

The earliest timestamp is used to define the original timezone
(AST/DST).

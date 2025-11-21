# Add deployment_id, waterbody, and station columns

Add deployment_id, waterbody, and station columns

## Usage

``` r
adcp_add_opendata_cols(
  dat,
  metadata = NULL,
  deployment_id = NULL,
  waterbody = NULL,
  station = NULL
)
```

## Arguments

- dat:

  Data frame of ACDP data in long format, as returned by
  `adcp_pivot_longer()`.

- metadata:

  Data frame with metadata information for the deployment in `dat`
  (e.g., a row from the NSDFA tracking sheet). Must include columns
  `Depl_ID`, `Waterbody`, and `Station`. Option to use default value
  `metadata = NULL` and provide the required values in the remaining
  arguments.

- deployment_id:

  Unique ID assigned to each deployment. Not used if `metadata` argument
  is specified.

- waterbody:

  Waterbody in which ADCP was deployed. Not used if `metadata` argument
  is specified.

- station:

  Specific area in which ADCP was deployed. Not used if `metadata`
  argument is specified.

## Value

Returns `dat` with columns deployment_id, waterbody, and station.

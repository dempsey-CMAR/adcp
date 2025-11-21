# Import NSDFA tracking sheet and extra deployment metadata

Import NSDFA tracking sheet and extra deployment metadata

## Usage

``` r
adcp_read_nsdfa_metadata(
  path,
  sheet = NULL,
  station = NULL,
  deployment_date = NULL
)
```

## Arguments

- path:

  Path to the NSDFA tracking sheet (include file name and extension).

- sheet:

  Sheet to read in. Defaults to the first sheet.

- station:

  Station for which to return metadata.

- deployment_date:

  Date of deployment for which to return metadata.

## Value

Returns data frame of NSDFA tracking sheet ADCP metadata. Option to
filter for a single deployment.

## Details

Reads in the NSDFA tracking sheet and corrects known errors (e.g.,
standardizes station and waterbody spellings, fixes deployment dates,
etc.).

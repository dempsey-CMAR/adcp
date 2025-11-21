# Export ADCP Data Deployment Information Dataset

Imports NSDFA Tracking sheet and ADCP TRACKING and exports the metadata
for the Nova Scotia Open Data Portal.

## Usage

``` r
adcp_compile_deployment_info(path_nsdfa = NULL, sheet = NULL)
```

## Arguments

- path_nsdfa:

  Full file path for the nsdfa tracking sheet, including file name and
  extension. If `NULL`, will default to the 2023-11-27 version on the
  CMAR R drive.

- sheet:

  Name of the sheet to read in as metadata. Defaults is "CurrMetaData".

## Value

Exports data frame of wave deployment information.

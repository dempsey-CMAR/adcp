# Import current data from rds files.

Import current data from rds files.

## Usage

``` r
adcp_import_data(path_input = NULL, county = "all", add_county_col = TRUE)
```

## Arguments

- path_input:

  Path to the rds files to be imported. Default is the
  currents/processed_data/assembled_data folder on the CMAR Operations
  shared drive (user must be connected to the Perennia VPN).

- county:

  Vector of character string(s) indicating the county or counties for
  which to import data. The filter is applied to the file path, so the
  county name MUST be part of the file path (e.g., the name of the
  folder). Defaults to all counties.

- add_county_col:

  Logical argument indicating whether to include a "county" column in
  the output. If `TRUE`, the imported data must have "waterbody" and
  "station" columns.

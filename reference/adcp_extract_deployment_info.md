# Extract deployment date and station name from file path

Extract deployment date and station name from file path

## Usage

``` r
adcp_extract_deployment_info(file_path)
```

## Arguments

- file_path:

  Path to the file, include file name and extension (.csv or .txt). File
  name must include the deployment date and the station name, in the
  format YYYY-MM-DD_Station Name.ext (e.g., 2007-12-18_Spectacle
  Island.txt)

## Value

Returns a tibble with three columns: `DEPLOYMENT`, `Depl_Date`, and
`Station_Name`.

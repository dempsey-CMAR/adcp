# Export Current Data Deployment Information Dataset

This function has been deprecated. Please use
\`adcp_compile_deployment_info()\`, which includes the wave columns,
instead.

## Usage

``` r
adcp_export_deployment_info(deployments, path_nsdfa, path_export)
```

## Arguments

- deployments:

  Vector of deployment IDs to include in the dataset.

- path_nsdfa:

  Full file path for the nsdfa tracking sheet, including file name and
  extension.

- path_export:

  File path to the folder where the Deployment Information Dataset
  should be exported.

## Value

Exports csv file named todays-date_Current_Data_Deployment_Info.csv.

## Details

Imports NSDFA Tracking sheet and Deployment ID tracker and exports the
metadata for the Nova Scotia Open Data Portal. User must be connected to
CMAR shared drive.

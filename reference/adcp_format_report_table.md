# Formats tables for typst summary report

Formats tables for typst summary report

## Usage

``` r
adcp_format_report_table(report_table, transpose = TRUE)
```

## Arguments

- report_table:

  Table to include in the summary report.

- transpose:

  Logical argument indicating whether to transpose `report_table` before
  applying the format. Use the default `TRUE` for the deployment table.
  Set to `FALSE` for the document history table.

## Value

Returns a data frame that will render nicely in the typst report. Every
cell is converted to text inside square brackets and separated with ",",
as expected by the typst table function.

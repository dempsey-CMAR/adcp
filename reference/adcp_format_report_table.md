# Formats tables for summary report

Formats tables for summary report

## Usage

``` r
adcp_format_report_table(report_table, transpose = TRUE)
```

## Arguments

- report_table:

  Table to include in the summary report. Either the deployment metadata
  from the NSDFA tracking sheet (as returned from
  [`adcp_write_report_table()`](https://dempsey-cmar.github.io/adcp/reference/adcp_write_report_table.md),
  or the document history) .

- transpose:

  Logical argument indicating whether to transpose `report_table` before
  applying the format. Use the default `TRUE` for the deployment table.
  Set to `FALSE` for the document history table.

## Value

Returns a flextable object that will render nicely in the Word report. A
table with two columns: the first column (bold) is the column names of
`report_table`; the second column is the corresponding entries in
`report_table`.

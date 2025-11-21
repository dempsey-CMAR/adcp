# Add a column of current variables in title case

Add a column of current variables in title case

## Usage

``` r
adcp_convert_vars_to_title(dat, convert_to_ordered_factor = TRUE)
```

## Arguments

- dat:

  Data frame of current data in long format. Flag columns will be
  dropped.

- convert_to_ordered_factor:

  Logical variable indicating whether the new `variable_title` column
  should be converted to an ordered factor. Default is `TRUE`.

## Value

Returns `dat` with an additional `variable_title` column for use in
faceted figures.

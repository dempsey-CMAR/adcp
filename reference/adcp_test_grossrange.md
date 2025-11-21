# Apply grossrange test to current variables

Apply grossrange test to current variables

## Usage

``` r
adcp_test_grossrange(
  dat,
  current_grossrange_table = NULL,
  county = NULL,
  vars = NULL
)
```

## Arguments

- dat:

  Data frame of current variables in wide format.

- current_grossrange_table:

  Data frame with at least 5 columns: `variable`: entries must match the
  names of the variables being tested in `dat`; `gr_min`: minimum
  acceptable value; `gr_max`: maximum accepted value ; `user_min`:
  minimum reasonable value; `user_max`: maximum reasonable value.

- county:

  Character string indicating the county from which `dat` was collected.
  Used to filter the default `current_grossrange_table`.

- vars:

  Vector of character strings indicating which columns to pivot. Default
  is all variables.

## Value

Returns `dat` with an additional grossrange_flag column for each wave
variable.

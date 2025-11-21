# Apply the spike test to current parameters

Apply the spike test to current parameters

## Usage

``` r
adcp_test_spike(
  dat,
  county = NULL,
  current_spike_table = NULL,
  keep_spike_cols = FALSE
)
```

## Arguments

- dat:

  Data frame of current data in wide format.

- county:

  Character string indicating the county from which `dat` was collected.
  Used to filter the default `current_spike_table`.

- current_spike_table:

  Data frame with at least 3 columns: `variable`: should match the names
  of the variables being tested in `dat`. `spike_low`: maximum
  acceptable spike value to "Pass", and `spike_high`: maximum acceptable
  value to be flagged "Suspect/Of Interest".

  Default values are used if `current_spike_table = NULL`. To see the
  default `current_spike_table`, type
  `subset(current_thresholds, qc_test == "spike")` in the console.

- keep_spike_cols:

  Logical value. If `TRUE`, the columns used to produce the spike value
  are returned in `dat`. Default is `FALSE`.

## Value

Returns `dat` in a wide format, with spike flag columns for each
variable in the form "spike_flag_variable".

## See also

Other tests:
[`adcp_test_rolling_sd()`](https://dempsey-cmar.github.io/adcp/reference/adcp_test_rolling_sd.md)

# Apply multiple quality control tests to current data

This function has been deprecated. The rolling_sd and spike tests are
not applied to the current data prior to publication.

## Usage

``` r
adcp_test_all(
  dat,
  qc_tests = NULL,
  county = NULL,
  current_grossrange_table = NULL,
  current_rolling_sd_table = NULL,
  current_spike_table = NULL,
  period_hours = 12,
  max_interval_hours = 2,
  align_window = "center",
  keep_sd_cols = FALSE,
  keep_spike_cols = FALSE
)
```

## Arguments

- dat:

  Data frame of wave data in a wide format.

- qc_tests:

  Character vector of quality control tests to apply to `dat`. Defaults
  to all available tests:
  `qc_tests = c("grossrange", "rolling_sd", "spike")`.

- county:

  Character string indicating the county from which `dat` was collected.
  Used to filter the default `current_grossrange_table`.

- current_grossrange_table:

  Data frame with at least 5 columns: `variable`: entries must match the
  names of the variables being tested in `dat`; `gr_min`: minimum
  acceptable value; `gr_max`: maximum accepted value ; `user_min`:
  minimum reasonable value; `user_max`: maximum reasonable value.

- current_rolling_sd_table:

  Data frame with at least two columns: `variable`: must match the names
  of the variables being tested in `dat`. `rolling_sd_max`: maximum
  accepted value for the rolling standard deviation.

  Default values are used if `rolling_sd_table = NULL`. To see the
  default `rolling_sd_table`, type
  `subset(current_thresholds, qc_test == "rolling_sd")` in the console.

- current_spike_table:

  Data frame with at least 3 columns: `variable`: should match the names
  of the variables being tested in `dat`. `spike_low`: maximum
  acceptable spike value to "Pass", and `spike_high`: maximum acceptable
  value to be flagged "Suspect/Of Interest".

  Default values are used if `current_spike_table = NULL`. To see the
  default `current_spike_table`, type
  `subset(current_thresholds, qc_test == "spike")` in the console.

- period_hours:

  Length of a full cycle in hours. Default assumes a tidal cycle of
  `period_hours = 12`.

- max_interval_hours:

  Maximum accepted interval between two observations. If the interval
  between two observations is greater than this value, the rolling
  standard deviation will be set to `NA`. This is important because for
  large intervals, the number of observations in `period_hours` will be
  small. For example, if samples are collected every 6 hours, only 2
  observations would be used to calculate `roll_sd`.

- align_window:

  Alignment for the window used to calculate the rolling standard
  deviation. Passed to
  [`zoo::rollapply()`](https://rdrr.io/pkg/zoo/man/rollapply.html).
  Default is `align_window = "center"`. Other options are `"right"`
  (backward window) and `"left"` (forward window).

- keep_sd_cols:

  Logical value. If `TRUE`, the columns used to produce the rolling
  standard deviation (`int_sample`, `n_sample`, and `sd_roll`) are
  returned in `dat`. Default is `FALSE`.

- keep_spike_cols:

  Logical value. If `TRUE`, the columns used to produce the spike value
  are returned in `dat`. Default is `FALSE`.

## Value

Returns `dat` with additional quality control flag columns.

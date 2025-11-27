# Apply the rolling standard deviation test to current variables

This function has been deprecated. It is not applied to the current data
prior to publication.

## Usage

``` r
adcp_test_rolling_sd(
  dat,
  current_rolling_sd_table = NULL,
  county = NULL,
  vars = NULL,
  period_hours = 12,
  max_interval_hours = 2,
  align_window = "center",
  keep_sd_cols = FALSE
)
```

## Arguments

- dat:

  Data frame of current data in wide format.

- current_rolling_sd_table:

  Data frame with at least two columns: `variable`: must match the names
  of the variables being tested in `dat`. `rolling_sd_max`: maximum
  accepted value for the rolling standard deviation.

  Default values are used if `rolling_sd_table = NULL`. To see the
  default `rolling_sd_table`, type
  `subset(current_thresholds, qc_test == "rolling_sd")` in the console.

- county:

  Character string indicating the county from which `dat` was collected.
  Used to filter the default `rolling_sd_table`. Not required if there
  is a `county` column in `dat`.

- vars:

  Vector of character strings indicating which columns to pivot. Default
  is all variables.

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

## Value

Returns `dat` in a wide format, with rolling standard deviation flag
columns for each variable in the form "rolling_sd_flag_variable".

## Details

The rolling standard deviation is calculated using the following
algorithm:

1\. Calculate the interval between the current and previous observation
(`int_sample`; in minutes).

2\. Determine the number of samples in the specified time frame
(`n_sample = round((60 / int_sample) * period_hours)`)

3\. If `int_sample` is really large (\> `max_interval_hours`), then set
the effective sample number (`n_sample_effective`) to 0.

4\. Calculate the rolling standard deviation, with the width =
`n_sample_effective` and alignment specified by `align_window`.
`sd_roll` is rounded to 2 decimal places.

When int_sample = period_hours, n_sample = 1, so sd_roll = NA.

## See also

Other tests:
[`adcp_test_spike()`](https://dempsey-cmar.github.io/adcp/reference/adcp_test_spike.md)

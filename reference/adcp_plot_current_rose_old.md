# Generate current old rose

Generate current old rose

## Usage

``` r
adcp_plot_current_rose_old(
  dat,
  breaks,
  speed_column,
  direction_column,
  speed_colors = NULL,
  speed_label = "Current Speed (cm/s)"
)
```

## Arguments

- dat:

  Data frame with column names that include the strings `"speed"` and
  `"direction"`.

- breaks:

  Number of break points for current speed OR a vector of breaks.
  Lower-inclusive.

- speed_column:

  Column name of the current speed (or wave height) column (i.e., the
  length of the petals).

- direction_column:

  Column name of the current (or wave ) direction column (i.e., the
  direction of the petals).

- speed_colors:

  Vector of colours. Must be the same length as `breaks`.

- speed_label:

  Title of the current speed legend. Default is "Current Speed (cm/s)".

## Value

Returns an "openair" object, a rose plot of current speed and direction.

## Details

Generates a current rose using the `windRose()` function from the
`openair` package. See help files for
[`openair::windRose`](https://openair-project.github.io/openair/reference/windRose.html)
for more detail.

For wave roses, replace "current speed" with "wave height".

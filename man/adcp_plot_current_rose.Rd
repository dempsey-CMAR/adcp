% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adcp_plot_current_rose.R
\name{adcp_plot_current_rose}
\alias{adcp_plot_current_rose}
\title{Generate current rose}
\usage{
adcp_plot_current_rose(
  dat,
  breaks,
  speed_column,
  direction_column,
  speed_colors = NULL,
  speed_label = "Current Speed (cm/s)",
  add_dir_labs = TRUE
)
}
\arguments{
\item{dat}{Data frame with column names that include the strings
\code{"speed"} and \code{"direction"}.}

\item{breaks}{Number of break points for current speed OR a vector of breaks.
Lower-inclusive.}

\item{speed_column}{Column name of the current speed (or wave height) column
(i.e., the length of the petals).}

\item{direction_column}{Column name of the current (or wave ) direction
column (i.e., the direction of the petals).}

\item{speed_colors}{Vector of colours. Must be the same length as
\code{breaks}.}

\item{speed_label}{Title of the current speed legend. Default is "Current
Speed (cm/s)".}

\item{add_dir_labs}{placeholder}
}
\value{
Returns an "openair" object, a rose plot of current speed and
  direction.
}
\description{
Generate current rose
}
\details{
Generates a current rose using the \code{windRose()} function from
  the \code{openair} package. See help files for \code{openair::windRose} for
  more detail.

  For wave roses, replace "current speed" with "wave height".
}

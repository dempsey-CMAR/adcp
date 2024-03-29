% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adcp_correct_timestamp.R
\name{adcp_correct_timestamp}
\alias{adcp_correct_timestamp}
\title{Convert timestamp to UTC from AST or DST}
\usage{
adcp_correct_timestamp(dat, rm = TRUE)
}
\arguments{
\item{dat}{Data frame with at least one column \code{timestamp_ns} (long or
wide format).}

\item{rm}{Logical argument. If \code{TRUE} the original \code{timestamp_ns}
column will be removed.}
}
\value{
Returns \code{dat} with \code{timestamp_utc} in true UTC.
}
\description{
Convert timestamp to UTC from AST or DST
}
\details{
For the raw ADCP data, the timestamp column is in the timezone of
  the deployment date (e.g., "AST" if deployed in November to March and "DST"
  if deployed in March to November). The timestamp does NOT account for
  changes in daylight savings time.

  \code{adcp_read_text()} assigns the timestamp a timezone of "UTC" to avoid
  \code{NA} values during the beginning of daylight savings time (e.g.,
  2019-03-10 02:30:00 is NOT a valid time for the "America/Halifax"
  timezone).

  \code{adcp_correct_timestamp()} converts each timestamp to true UTC by
  adding 3 hours if the deployment date was during daylight savings, or 4
  hours if the deployment date was during Atlantic Standard Time.

  The earliest timestamp is used to define the original timezone (AST/DST).
}

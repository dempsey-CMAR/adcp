% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adcp_check_duplicate_timestamp.R
\name{adcp_check_duplicate_timestamp}
\alias{adcp_check_duplicate_timestamp}
\title{Check for duplicate timestamp values}
\usage{
adcp_check_duplicate_timestamp(dat_wide)
}
\arguments{
\item{dat_wide}{Data frame of ADCP data, as returned from
\code{adcp_read_txt()}.}
}
\value{
If duplicate timestamps are detected, returns a warning and
  \code{TRUE}. Otherwise returns \code{FALSE}.
}
\description{
Check for duplicate timestamp values
}

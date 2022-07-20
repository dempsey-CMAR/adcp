
<!-- README.md is generated from README.Rmd. Please edit that file -->

# adcp: DRAFT README

<img src="https://github.com/dempsey-CMAR/adcp/blob/master/man/figures/README-adcp-hex.png" width="25%" style="display: block; margin: auto;" />

<!-- badges: start -->

[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![](https://img.shields.io/badge/devel%20version-1.0.0-blue.svg)](https://github.com/dempsey-CMAR/adcp)
[![CodeFactor](https://www.codefactor.io/repository/github/dempsey-CMAR/adcp/badge)](https://www.codefactor.io/repository/github/dempsey-CMAR/adcp)
[![R build
status](https://github.com/dempsey-CMAR/adcp/workflows/R-CMD-check/badge.svg)](https://github.com/dempsey-CMAR/adcp/actions)

<!-- badges: end -->

Format and visualize Current data collect by Acoustic Current Doppler
Profilers (ADCPs).

## Installation

You can install the development version of adcp from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dempsey-CMAR/adcp")
```

## Background

The Centre for Marine Applied Research ([CMAR](https://cmar.ca/))
coordinates an extensive [Coastal Monitoring
Program](https://cmar.ca/coastal-monitoring-program/) to measure
[Essential Ocean
Variables](https://www.goosocean.org/index.php?option=com_content&view=article&id=14&Itemid=114)
from around the coast of Nova Scotia, Canada. There are three main
branches of the program: *Water Quality*, *Currents*, and *Waves*.
Processed data for each branch can be viewed and downloaded from several
sources, as outlined in the [CMAR Report & Data Access Cheat
Sheet](https://github.com/Centre-for-Marine-Applied-Research/strings/blob/master/man/figures/README-access-cheatsheet.pdf)
(download for clickable links).

The `adcp` package is used to format and visualize data from the
*Current* branch of the Coastal Monitoring Program.

*Current* data is collected with Acoustic Doppler Current Profilers
(ADCPs) deployed on the seafloor. An ADCP is a hydroacoustic current
meter that measures water velocities over a range of depths. These
sensors measure soundwaves scattered back from moving particles in the
water column and use the Doppler effect to estimate speed and direction
(Figure 1).

<img src="https://github.com/dempsey-CMAR/adcp/blob/master/man/figures//README-fig1.png" width="65%" />
Figure 1: ADCP diagram (not to scale).

<br> <br>

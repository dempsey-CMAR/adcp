#' @title Import current data from rds files.

#' @param path_input Path to the *.rds files to be imported. Default is the
#'   ADCP/Open Data/County Datasets folder on the CMAR Operations shared drive
#'   (user must be connected to the Perennia VPN).
#'
#' @param county Vector of character string(s) indicating which county or
#' counties for which to import data. The filter is applied to the file path, so
#' the county name MUST be part of the file path (e.g., the name of the folder).
#' Defaults to all counties.
#'
#' @param add_county_col Logical argument indicating whether to include a
#'   "county" column in the output. If \code{TRUE}, the imported data must have
#'   "waterbody" and "station" columns.
#'
#' @param path_nsdfa Full file path for the nsdfa tracking sheet, including file
#'   name and extension. Must be specified when /code{add_county_col = TRUE}.
#'
#' @importFrom dplyr %>% select left_join everything
#' @importFrom stringr str_subset
#' @importFrom purrr map_dfr
#' @importFrom tidyr separate
#'
#' @export


adcp_import_data <- function(
  path_input = NULL,
  county = "all",
  add_county_col = TRUE,
  path_nsdfa = NULL
) {


  if (is.null(path_input)){
    # path to Open Data folder
    path_input <- file.path("Y:/Coastal Monitoring Program/ADCP/Open Data/County Datasets")

  } else path_input <- path_input

  # list rds files on the path and import -----------------------------------

  dat <- list.files(path_input, full.names = TRUE, pattern = ".rds")

  # filter for specified county(ies)
  if(!("all" %in% county)) dat <- dat %>% str_subset(paste(county, collapse = "|"))

  # read and bind the rds files
  dat <- dat %>%
    purrr::map_dfr(readRDS)

  # add county column
  if(isTRUE(add_county_col)){

    # import county abbrevations from internal data file
    load("R/sysdata.rda")

    # merge dat and county abbreviation files
    dat <- dat %>%
      separate(col = deployment_id, sep = 2, into = c("abb", NA), remove = FALSE) %>%
      left_join(county_abb, by = "abb") %>%
      select(county, everything(), -abb)

  }

  dat

}

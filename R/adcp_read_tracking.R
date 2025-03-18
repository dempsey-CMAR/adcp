#' Read deployment details from CMAR tracking sheet
#'
#' @param link Link to the adcp tracking sheet on Google Drive.
#'
#' @param sheet Character string with the name of the sheet to read in or an
#'   abbreviation of the sheet name. \code{sheet = "details"} will read in the
#'   sheet "Deployment Details", \code{sheet = "current"} will read in sheet
#'   "Current Tracking", and \code{sheet = "wave"} will read in sheet
#'   "Wave Tracking", .
#'
#' @importFrom dplyr select
#' @importFrom googlesheets4 gs4_deauth read_sheet
#' @importFrom lubridate with_tz
#' @importFrom stringr str_detect
#'
#' @return Returns a data frame of the calval tracking sheet. Deployment and
#'   retrieval datetimes are appended in "Canada/Atlantic" and "UTC" timezones.
#' @export


adcp_read_tracking <- function(link = NULL, sheet = "details") {

  if(is.null(link)) {
    link <- "https://docs.google.com/spreadsheets/d/1DVfJbraoWL-BW8-Aiypz8GZh1sDS6-HtYCSrnOSW07U/edit?gid=496612477#gid=496612477"
  }

  sheet <- tolower(sheet)

  if(str_detect(sheet, "details")) sheet <- "Deployment Details"
  if(str_detect(sheet, "current")) sheet <- "Current Tracking"
  if(str_detect(sheet, "wave")) sheet <- "Wave Tracking"

  googlesheets4::gs4_deauth()

  googlesheets4::read_sheet(
    link,
    sheet = sheet,
    col_types = "cccccTTnnncnnnnnnnnnnn",
    na = c("", "NA")
  )
}

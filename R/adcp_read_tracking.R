#' Read deployment details from CMAR tracking sheet
#'
#' @param link Link to the Current & Wave Tracking Deployment Details sheet on
#'   Google Drive.
#'
#' @importFrom googlesheets4 gs4_deauth read_sheet
#'
#' @return Returns a data frame of the Deployment Details sheet.
#'
#' @export


adcp_read_tracking <- function(link = NULL) {

  if(is.null(link)) {
    link <- "https://docs.google.com/spreadsheets/d/1DVfJbraoWL-BW8-Aiypz8GZh1sDS6-HtYCSrnOSW07U/edit?gid=496612477#gid=496612477"
  }

  #sheet <- tolower(sheet)

  # if(str_detect(sheet, "details")) sheet <- "Deployment Details"
  # if(str_detect(sheet, "current")) sheet <- "Current Tracking"
  # if(str_detect(sheet, "wave")) sheet <- "Wave Tracking"

  googlesheets4::gs4_deauth()

  googlesheets4::read_sheet(
    link,
    sheet = "Deployment Details",
    col_types = "cccccTTnnncncnnnnnnnnnc",
    na = c("", "NA")
  )
}

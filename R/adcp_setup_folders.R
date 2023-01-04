#' Set up folder structure for processing ADCP data
#'
#' @param path Path to where the folder will be created. Default is the "Side
#'   Lobe Trimmed" folder on the Perennia shared drive.
#'
#' @param folder Name of the top-level folder to be created. Default is
#'   todays_date_Process.
#'
#' @return Returns folder structure that works well with CMAR ADCP processing
#'   templates.
#'
#' @export


adcp_set_up_folders <- function(path = NULL, folder = NULL) {
  if (is.null(path)) {
    path <- "Y:/coastal_monitoring_program/data_branches/current/raw_data"
  }

  if (is.null(folder)) {
    folder <- paste0(Sys.Date(), "_process")
  }

  path <- file.path(paste(path, folder, sep = "/"))

  dir.create(path)

  dir.create(paste(path, "data_raw", sep = "/"))
  dir.create(paste(path, "figures", sep = "/"))
  dir.create(paste(path, "figures", "flags", sep = "/"))
  dir.create(paste(path, "R", sep = "/"))
  #dir.create(paste(path, "tracking", sep = "/"))
}

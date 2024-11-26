#' Export ADCP Data Deployment Information Dataset
#'
#' @description Imports NSDFA Tracking sheet and ADCP TRACKING and exports the
#'   metadata for the Nova Scotia Open Data Portal.
#'
#' @param path_nsdfa Full file path for the nsdfa tracking sheet, including file
#'   name and extension. If \code{NULL}, will default to the 2023-11-27 version
#'   on the CMAR R drive.
#'
#' @param sheet Name of the sheet to read in as metadata. Defaults is
#'   "CurrMetaData".
#'
#' @return Exports data frame of wave deployment information.
#'
#' @importFrom dplyr %>% arrange case_when transmute select
#' @importFrom lubridate as_date
#'
#' @export


adcp_compile_deployment_info <- function(path_nsdfa = NULL, sheet = NULL) {

  # import files ------------------------------------------------------------
  if(is.null(path_nsdfa)) {
    path_nsdfa <- "R:/tracking_sheets/2023-11-27 - NSDFA Tracking Sheet.xlsx"
  }

  if(is.null(sheet)) sheet <- "CurrMetaData"

  adcp_read_nsdfa_metadata(path_nsdfa, sheet = sheet) %>%
    arrange(County, Waterbody, Depl_Date) %>%
    transmute(
      county = County,
      waterbody = Waterbody,
      station = Station_Name,
      deployment_date = as_date(Depl_Date),
      recovery_date = as_date(Recv_Date),
      deployment_duration_days = Depl_Duration,
      lease = `Lease#`,
      latitude = Depl_Lat,
      longitude = Depl_Lon,
      sensor_model = Inst_Model,
      sensor_serial_number = Inst_Serial,
      deployment_sounding_m = Depl_Sounding,
      sensor_height_above_sea_floor_m = Inst_Altitude,
      first_bin_range_m = First_Bin_Range,
      bin_size_m = Bin_Size,
      current_ensemble_interval_s = Current_Ensemble_Interval_s,
      current_averaging_interval_s = Current_Averaging_Interval_s,
      current_pings_per_ensemble = Current_PingsPerEnsemble,
      wave_ensemble_interval_s = Waves_Ensemble_Interval_s,
      wave_averaging_interval_s = Waves_Averaging_Interval_s,
      wave_pings_per_ensemble = Waves_PingsPerEnsemble
    )
}

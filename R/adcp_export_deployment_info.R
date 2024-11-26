#' Export Current Data Deployment Information Dataset
#'
#' This function has been deprecated. Please use
#' `adcp_compile_deployment_info()`, which includes the wave columns, instead.
#'
#' Imports NSDFA Tracking sheet and Deployment ID tracker and exports the
#' metadata for the Nova Scotia Open Data Portal. User must be connected to CMAR
#' shared drive.
#'
#' @param path_nsdfa Full file path for the nsdfa tracking sheet, including file
#'   name and extension.
#'
#' @param deployments Vector of deployment IDs to include in the dataset.
#'
#' @param path_export File path to the folder where the Deployment Information
#'   Dataset should be exported.
#'
#' @return Exports csv file named todays-date_Current_Data_Deployment_Info.csv.
#'
#' @importFrom dplyr %>% arrange distinct filter left_join rename transmute
#'   select
#' @importFrom googlesheets4 read_sheet
#' @importFrom lifecycle deprecate_warn
#' @importFrom readr write_csv
#' @importFrom readxl read_excel
#' @importFrom stringr str_detect
#'
#' @export



adcp_export_deployment_info <- function(deployments,
                                        path_nsdfa,
                                        path_export) {

  lifecycle::deprecate_warn(
    "3.0.1",
    "adcp_export_deployment_info()",
    "adcp_compile_deployment_info()"
  )

  # import files ------------------------------------------------------------

  nsdfa <- adcp_read_nsdfa_metadata(path_nsdfa) %>%
    arrange(County, Waterbody, Depl_Date)

  # deployment ID's
  link <- "https://docs.google.com/spreadsheets/d/1DVfJbraoWL-BW8-Aiypz8GZh1sDS6-HtYCSrnOSW07U/edit#gid=0"

  depl_id <- googlesheets4::read_sheet(link, sheet = "Tracking") %>%
    select(
      depl_id,
      County = county,
      Waterbody = waterbody,
      Depl_Date = depl_date,
      Station_Name = station) %>%
    na.omit()


  metadata <- nsdfa %>%
    left_join(depl_id, by = c("County", "Waterbody", "Depl_Date", "Station_Name")) %>%
    filter(depl_id %in% deployments) %>%
    transmute(
      deployment_id = depl_id,
      county = County,
      waterbody = Waterbody,
      station = Station_Name,
      deployment_date = as.character(Depl_Date),
      recovery_date = as.character(as_date(Recv_Date)),
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
      ensemble_interval_s = Current_Ensemble_Interval_s,
      averaging_interval_s = Current_Averaging_Interval_s,
      pings_per_ensemble = Current_PingsPerEnsemble
    ) %>%
    arrange(deployment_id)

  # export data -------------------------------------------------------------

  write_csv(
    metadata,
    file = glue("{path_export}/{Sys.Date()}_current_data_deployment_info.csv")
  )
}

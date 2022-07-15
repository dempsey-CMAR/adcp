#' Export Current Data Deployment Information Dataset
#'
#' @description Imports NSDFA Tracking sheet and Deployment ID tracker and
#'   exports the metadata for the NS OpenData Portal. Must be connected to CMAR
#'   shared drive.
#'
#' @param path_nsdfa Full file path for the nsdfa tracking sheet, including file
#'   name and extension.
#'
#' @param deployments Vector of deployment IDs to include in the dataset.
#'
#' @param path_depl_id Full file path to the Deployment ID spreadsheet,
#'   including file name and extension
#'
#' @param path_export File path to the folder where the Deployment Information
#'   Dataset should be exported.
#'
#' @return Exports csv file named todays-date_Current_Data_Deployment_Info.
#'
#' @importFrom dplyr %>% arrange distinct filter left_join rename select
#' @importFrom readr write_csv
#' @importFrom readxl read_excel
#' @importFrom stringr str_detect
#'
#' @export


# path_import <- file.path("Y:/Coastal Monitoring Program/ADCP/Side Lobe Trimmed")
#
# path_export <- file.path("Y:/Coastal Monitoring Program/ADCP/Open Data/Submissions")



adcp_export_deployment_info <- function(
  deployments,
  path_nsdfa,
  path_depl_id,
  path_export
) {

# import files ------------------------------------------------------------

  nsdfa <- adcp_read_nsdfa_metadata(path_nsdfa) %>%
    arrange(County, Waterbody, Depl_Date)

  depl_id <- read_excel(path_depl_id)

  metadata <- nsdfa %>%
    left_join(depl_id, by = c("County", "Waterbody", "Depl_Date", "Station_Name")) %>%
    filter(Depl_ID %in% deployments) %>%
    select(
      county,
      waterbody,
      station = Station_Name,
      deployment_date = Depl_Date,
      recovery_date = Recv_Date,
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
    )


# filter and format columns ----------------------------------------------------------

  # open_data_metadata <- nsdfa %>%
  #   left_join(reports, by = c("County", "Waterbody", "Depl_Date", "Station_Name")) %>%
  #   #filter(str_detect(Report_2022, "YES")) %>%
  #   select(
  #     County,
  #     Waterbody,
  #     Station = Station_Name,
  #     `Deployment Date` = Depl_Date,
  #     `Recovery Date` = Recv_Date,
  #     `Deployment Duration (d)` = Depl_Duration,
  #     Lease = `Lease#`,
  #     Latitude = Depl_Lat,
  #     Longitude = Depl_Lon,
  #
  #     `Instrument Model` = Inst_Model,
  #     `Instrument Serial Number` = Inst_Serial,
  #     `Instrument Depth` = Depl_Sounding,
  #     `Instrument Height Above Sea Floor` = Inst_Altitude,
  #     `First Bin Range (m)` = First_Bin_Range,
  #     `Bin Size (m)` = Bin_Size,
  #     `Ensemble Interval (s)` = Current_Ensemble_Interval_s,
  #     `Averaging Interval (s)` = Current_Averaging_Interval_s,
  #     `Pings Per Ensemble` = Current_PingsPerEnsemble
  #   )
  #


# export data -------------------------------------------------------------

  write_csv(
    metadata,
    file = glue("{path_export}/{Sys.Date()}_Current_Data_Deployment_Info.csv")
  )


}

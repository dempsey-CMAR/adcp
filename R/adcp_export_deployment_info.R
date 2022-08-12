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
#' @param path_export File path to the folder where the Deployment Information
#'   Dataset should be exported.
#'
#' @return Exports csv file named todays-date_Current_Data_Deployment_Info.
#'
#' @importFrom dplyr %>% arrange distinct filter left_join rename transmute
#'   select
#' @importFrom googlesheets4 read_sheet
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
  path_export
) {

# import files ------------------------------------------------------------

  nsdfa <- adcp_read_nsdfa_metadata(path_nsdfa) %>%
    arrange(County, Waterbody, Depl_Date)

  # deployment ID's
  link <- "https://docs.google.com/spreadsheets/d/1-8gt9FdN-mTApWw_D1xYBhHcvuzhT6-8qH_XXxxpqJ4/edit#gid=0"

  depl_id <- googlesheets4::read_sheet(link, sheet = "Tracking") %>%
    select(Depl_ID, County, Waterbody, Depl_Date, Station_Name) %>%
    na.omit()


  metadata <- nsdfa %>%
    left_join(depl_id, by = c("County", "Waterbody", "Depl_Date", "Station_Name")) %>%
    filter(Depl_ID %in% deployments) %>%
    transmute(
      deployment_id = Depl_ID,
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
    file = glue("{path_export}/{Sys.Date()}_Current_Data_Deployment_Info.csv")
  )


}

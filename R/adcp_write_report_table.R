#' Writes deployment table for summary report
#'
#' @param metadata Deployment metadata from the ADCP TRACKING sheet.
#'
#' @return Returns a data frame with columns for the report table.
#'
#' @importFrom dplyr if_else mutate select
#'
#' @export

adcp_write_report_table <- function(metadata) {
  metadata %>%
    mutate(
      depl_duration = as.numeric(
        difftime(retrieval_date, deployment_date, units = "days")
      )
    ) %>%
    select(
      Station = station,
      `Instrument Model` = sensor_model,
      Latitude = latitude, Longitude = longitude,
      `Deployment Date` = deployment_date, `Recovery Date` = retrieval_date,
      `Duration (d)` = depl_duration,
      `Depth Sounding (m)` = deployment_sounding_m,
      `Ensemble Interval (s)` = current_ensemble_interval_s,
      `Averaging Interval (s)` = current_averaging_interval_s,
      `Pings per Ensemble` = current_pings_per_ensemble,
      `Sensor Height above Sea Floor (m)` = sensor_height_above_sea_floor_m,
      `First Bin Range (m)` = first_bin_range_m,
      `Bin Size (m)` = bin_size_m,
    ) %>%
    mutate(
      `Depth Sounding (m)` = as.character(`Depth Sounding (m)`),
      `Depth Sounding (m)` = if_else(
        is.na(`Depth Sounding (m)`), "Not recorded", `Depth Sounding (m)`
      )
    )
}

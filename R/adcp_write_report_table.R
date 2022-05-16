#' Writes deployment table for summary report
#'
#' @param metadata Deployment metadata from the NSDFA tracking sheet.
#'
#' @return Returns a tibble with three columns: \code{DEPLOYMENT},
#'   \code{Depl_Date}, and \code{Station_Name}.
#'
#' @importFrom dplyr mutate select tibble
#'
#' @export

adcp_write_report_table <- function(metadata){

  metadata %>%
    tibble() %>%
    select(
      Station = Station_Name,
      `Instrument Model` = Inst_Model,
      Latitude = Depl_Lat, Longitude = Depl_Lon,
      `Deployment Date` = Depl_Date, `Recovery Date` = Recv_Date,
      `Duration (d)` = Depl_Duration,
      `Depth (m)` = Depl_Sounding,
      `Ensemble intervals (s)` = Current_Ensemble_Interval_s,
      `Averaging intervals (s)` = Current_Averaging_Interval_s,
      `Pings/Ensemble` = Current_PingsPerEnsemble,
      `Bin Size (m)` = Bin_Size,
      `First Bin Range (m)` = First_Bin_Range) %>%
    mutate(`Depth (m)` = as.numeric(`Depth (m)`))

}

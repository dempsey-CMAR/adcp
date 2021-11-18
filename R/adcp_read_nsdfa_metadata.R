#' Import NSDFA tracking sheet and extra deployment metadata
#'
#' @param path Path to the tracking sheet (include file name and extension)
#'
#' @param station Station for which to return metadata.
#'
#' @param deployment_date Date of deployment for which to return metadata.
#'
#' @return Returns dataframe of NSDFA tracking sheet ADCP metadata. Option to
#'   filter for a single deployment.
#'
#' @importFrom readxl read_excel
#' @importFrom dplyr filter mutate select contains
#'
#' @export


adcp_read_nsdfa_metadata <- function(path, station = NULL, deployment_date = NULL){

 # path <- "C:/Users/Danielle Dempsey/Desktop/RProjects/adcp_docs/data/2021-11-15 - NSDFA Tracking Sheet.xlsx"

  nsdfa <- read_excel(path, sheet = "CurrMetaData", na = c("", "n/a")) %>%
    select(-contains("Column")) %>%
    mutate(Bin_Size = as.numeric(Bin_Size),
           First_Bin_Range = as.numeric(First_Bin_Range))

  if(!is.null(station) & !is.null(deployment_date)){

    nsdfa <- nsdfa %>%
      filter(Station_Name == station, Depl_Date = deployment_date) %>%
      select(County, Waterbody, Station_Name, `Lease#`,
             Depl_Date, Depl_Lat, Depl_Lon, Recv_Date,
             Inst_Model, Inst_Serial, Inst_Depth, Inst_Altitude,
             Bin_Size, First_Bin_Range, Notes)

  }

  nsdfa

}

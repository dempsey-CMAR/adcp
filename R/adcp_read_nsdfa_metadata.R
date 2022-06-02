#' Import NSDFA tracking sheet and extra deployment metadata
#'
#' @param path Path to the tracking sheet (include file name and extension).
#'
#' @param sheet Sheet to read in. Defaults to the first sheet.
#'
#' @param station Station for which to return metadata.
#'
#' @param deployment_date Date of deployment for which to return metadata.
#'
#' @return Returns dataframe of NSDFA tracking sheet ADCP metadata. Option to
#'   filter for a single deployment.
#'
#' @importFrom readxl read_excel
#' @importFrom dplyr case_when contains filter mutate select tibble
#' @importFrom lubridate as_date
#' @importFrom janitor convert_to_date
#'
#' @export


adcp_read_nsdfa_metadata <- function(
  path,
  sheet = NULL,
  station = NULL,
  deployment_date = NULL
){

  # row for Grand Passage deployment (FORCE deployment but we have the data)
  force_row <- tibble(
    Station_ID = NA,
    Record_ID = NA,
    County = "Digby",
    Waterbody = "St. Mary's Bay",
    Station_Name = "Grand Passage",
    `Lease#` = "829",
    Status = "Retrieved",
    Depl_Purpose = NA, Depl_Parameters = NA,
    Depl_Date = as_date("2020-08-27"),
    Depl_Time = NA,
    Depl_Lat = 44.273585, Depl_Lon = -66.342362,
    Depl_Sounding = 17,
    Anchor_Wgt = NA,
    Recv_Date = "2020-11-28",
    Recv_Time = NA, Recv_Lat = NA, Recv_Lon = NA,
    Depl_Duration = 93,
    Inst_Model = "Sentinel V100",
    Inst_Serial = NA, Inst_Depth = NA,
    Inst_Altitude = 0.5,
    Inst_Interval = NA,	Depl_Voltage = NA,	Recv_Voltage = NA, Recv_Method = NA,
    Frame = NA,
    Depl_Attendant = "FORCE",
    Recv_Attendant = NA,
    Bin_Size = 1,	First_Bin_Range = 1,
    Current_Ensemble_Interval_s = NA,
    Current_Averaging_Interval_s = NA,
    Current_PingsPerEnsemble = NA, Waves_Ensemble_Interval_s = NA,
    Waves_Averaging_Interval_s  = NA,	Waves_PingsPerEnsemble = NA,	Notes = NA
  )



  # NSDFA Tracking Sheet
  nsdfa <- read_excel(path, sheet = sheet, na = c("", "n/a", "N/A")) %>%
    select(-contains("Column")) %>%
    mutate(
      # Fix incorrect entries
      Waterbody = case_when(
        Waterbody == "Dena's Pond" ~ "Denas Pond",
        Waterbody == "St.Ann's Harbour" ~ "St. Ann's Harbour",
        Waterbody == "St Margarets Bay" ~ "St. Margarets Bay",
        Waterbody == "Straight of Canso" ~ "Strait of Canso",
        Waterbody == "St. Mary's Bay" & Depl_Date == "40632" &
          Station_Name == "Brier Island" ~ "Westport Harbour",
        Waterbody == "Whycocomagh Bay" & Depl_Date == "43327" &
          Station_Name == "Gypsum Mine" ~ "Bras d'Or Lakes",
        Waterbody == "Lennox Passage" & Depl_Date == "44440" &
          Station_Name == "Walshs Deep Cove" ~ "Carry Passage",

        Waterbody == "St Peters Inlet" ~ "St. Peters Inlet",
        TRUE ~ Waterbody
      ),

      Station_Name = case_when(

        Station_Name == "778" & Depl_Date == "44020" ~ "St. Peters Inlet",
        Station_Name == "1042 North" & Depl_Date == "44126" ~ "Cornwallis NE",
        Station_Name == "1042 South" & Depl_Date == "44126" ~ "Cornwallis SW",
        Station_Name == "1181" & Depl_Date == "44075" ~ "Woods Harbour",
        Station_Name == "Buoy Test" & Depl_Date == "43763" ~ "Blue Island",
        Station_Name == "Dena's Pond" & Depl_Date == "43690"  ~ "Denas Pond",
        Station_Name == "Eddy Cove C" & Depl_Date == "41829" ~ "Eddy Cove Center",
        Station_Name == "Inshore" & Depl_Date == "42551" ~ "Roy Island Inshore",
        Station_Name == "Outside" & Depl_Date == "42587" ~ "Roy Island Outer",
        Station_Name == "Outer Island" & Depl_Date == "43503" ~ "Camerons Cove",
        Station_Name == "Ram Island S" & Depl_Date == "43378" ~ "Ram Island",
        Station_Name == "Saddle NE" & Depl_Date == "42650" ~ "Saddle Island NE",
        Station_Name == "Saddle SW" & Depl_Date == "42284" ~ "Saddle Island SW",
        Station_Name == "Shut In Island" & Depl_Date == "44015" ~ "Shut-In Island", # for consistency with strings
        Station_Name == "St Margarets Bay Center" & Depl_Date == "44110" ~ "St. Margarets Bay Center",
        Station_Name == "Tor Bay Center" & Depl_Date == "43501"  ~ "Center Bay",

        TRUE ~ Station_Name
      ),

      Depl_Date = case_when(
        Depl_Date == "Current, Waves, Temperature, Pressure" ~ "40522", # December 10, 2010
        TRUE ~ Depl_Date
      ),

      First_Bin_Range = case_when(
        First_Bin_Range == "1..6" ~ "1.6",
        Station_Name == "Canoe Island" & Depl_Date == "44098" & is.na(First_Bin_Range) ~ "1.62", # from the metadata in the non side-lobe trimmed excel files
        Station_Name == "Woods Harbour" & Depl_Date == "44075" & is.na(First_Bin_Range) ~ "1",   # from the metadata in the non side-lobe trimmed excel files
        TRUE ~ First_Bin_Range
      ),

      # fix column types
      Bin_Size = as.numeric(Bin_Size),
      First_Bin_Range = as.numeric(First_Bin_Range),
      Depl_Date = convert_to_date(as.numeric(Depl_Date))
    ) %>%
    # add in Grand Passage Deployment
    rbind(force_row)

  # filter to deployment of interest
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

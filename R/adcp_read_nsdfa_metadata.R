#' Import NSDFA tracking sheet and extra deployment metadata
#'
#' @details Reads in the NSDFA tracking sheet and corrects known errors (e.g.,
#'   standardizes station and waterbody spellings, fixes deployment dates,
#'   etc.).
#'
#' @param path Path to the NSDFA tracking sheet (include file name and
#'   extension).
#'
#' @param sheet Sheet to read in. Defaults to the first sheet.
#'
#' @param station Station for which to return metadata.
#'
#' @param deployment_date Date of deployment for which to return metadata.
#'
#' @return Returns data frame of NSDFA tracking sheet ADCP metadata. Option to
#'   filter for a single deployment.
#'
#' @importFrom readxl read_excel
#' @importFrom dplyr case_when contains filter mutate select tibble
#' @importFrom lubridate as_date
#' @importFrom janitor convert_to_date
#' @importFrom tidyr separate
#'
#' @export


adcp_read_nsdfa_metadata <- function(path,
                                     sheet = NULL,
                                     station = NULL,
                                     deployment_date = NULL) {

  # row for Grand Passage deployment (FORCE deployment but we have the data)
  force_row <- tibble(
    Station_ID = NA,
    Record_ID = NA,
    Depl_ID = "DG012",
    County = "Digby",
    Waterbody = "Grand Passage",
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
    Inst_Interval = NA, Depl_Voltage = NA, Recv_Voltage = NA, Recv_Method = NA,
    Frame = NA,
    Depl_Attendant = "FORCE",
    Recv_Attendant = NA,
    Bin_Size = 1, First_Bin_Range = 1,
    Current_Ensemble_Interval_s = NA,
    Current_Averaging_Interval_s = NA,
    Current_PingsPerEnsemble = NA, Waves_Ensemble_Interval_s = NA,
    Waves_Averaging_Interval_s = NA, Waves_PingsPerEnsemble = NA, Notes = NA
  )

  # Read in and format tracking sheet ---------------------------------------

  # NSDFA Tracking Sheet
  nsdfa <- read_excel(path, sheet = sheet, na = c("", "n/a", "N/A", "NA")) %>%
    select(-contains("Column")) %>%
    separate(Depl_Time, into = c(NA, "Depl_Time"), sep = " ") %>%
    rename(Depl_ID = CMAR_ID)

  # to correct mistake in 2022-03-17 version of tracking sheet
  if (suppressWarnings(is.na(as_date(nsdfa$Depl_Date[1])))) {
    nsdfa <- nsdfa %>%
      mutate(
        Depl_Date = case_when(
          Depl_Date == "Current, Waves, Temperature, Pressure" ~ "40522", # December 10, 2010
          TRUE ~ Depl_Date
        ),
        Depl_Date = janitor::convert_to_date(as.numeric(Depl_Date))
      )
  }

  nsdfa <- nsdfa %>%
    mutate(
      Depl_Date = as_date(Depl_Date),
      Recv_Date = as_date(Recv_Date),

      # Fix incorrect entries
      Waterbody = case_when(
        Waterbody == "Dena's Pond" ~ "Denas Pond",
        Waterbody == "Owl's Head Bay" ~ "Owls Head Bay",

        Waterbody == "St.Ann's Harbour" ~ "St. Anns Harbour",
        Waterbody == "St Margarets Bay" ~ "St. Margarets Bay",
        Waterbody == "Straight of Canso" ~ "Strait of Canso",
        Waterbody == "St Marys Bay" & Depl_Date == as_date("2011-03-30") &
          Station_Name == "Brier Island" ~ "Westport Harbour",

       Waterbody == "St Marys Bay" ~ "St. Marys Bay",

        Waterbody == "Whycocomagh Bay" & Depl_Date == as_date("2018-08-15") &
          Station_Name == "Gypsum Mine" ~ "Bras d'Or Lakes",
        Waterbody == "Lennox Passage" & Depl_Date == as_date("2021-09-01") &
          Station_Name == "Walshs Deep Cove" ~ "Carry Passage",
        Waterbody == "St Peters Inlet" ~ "St. Peters Inlet",
        TRUE ~ Waterbody
      ),
      Station_Name = case_when(
        Station_Name == "St Marys Bay Center" ~ "St. Marys Bay Center",
        Station_Name == "778" &
          Depl_Date == as_date("2020-07-08") ~ "St. Peters Inlet",
        Station_Name == "1042 North" &
          Depl_Date == as_date("2020-10-22") ~ "Cornwallis NE",
        Station_Name == "1042 South" &
          Depl_Date == as_date("2020-10-22") ~ "Cornwallis SW",
        Station_Name == "1181" &
          Depl_Date == as_date("2020-09-01") ~ "Woods Harbour",
        Station_Name == "Buoy Test" &
          Depl_Date == as_date("2019-10-25") ~ "Blue Island",
        Station_Name == "Dena's Pond" &
          Depl_Date == as_date("2019-08-13") ~ "Denas Pond",
        Station_Name == "Eddy Cove C" &
          Depl_Date == as_date("2014-07-09") ~ "Eddy Cove Center",
        Station_Name == "Inshore" &
          Depl_Date == as_date("2016-06-30") ~ "Roy Island Inshore",
        Station_Name == "Outside" &
          Depl_Date == as_date("2016-08-05") ~ "Roy Island Outer",
        Station_Name == "Outer Island" &
          Depl_Date == as_date("2019-02-07") ~ "Camerons Cove",

        Station_Name == "Owl's Head" &
          Depl_Date == as_date("2009-12-08") ~ "Owls Head",

        Station_Name == "Ram Island S" &
          Depl_Date == as_date("2018-10-05") ~ "Ram Island",
        Station_Name == "Saddle NE" &
          Depl_Date == as_date("2016-10-07") ~ "Saddle Island NE",
        Station_Name == "Saddle SW" &
          Depl_Date == as_date("2015-10-07") ~ "Saddle Island SW",
        Station_Name == "Shut In Island" &
          Depl_Date == as_date("2020-07-03") ~ "Shut-In Island", # for consistency with strings
        Station_Name == "St Margarets Bay Center" &
          Depl_Date == as_date("2020-10-06") ~ "St. Margarets Bay Center",
        Station_Name == "Tor Bay Center" &
          Depl_Date == as_date("2019-02-05") ~ "Center Bay",
        TRUE ~ Station_Name
      ),

      # needs to go here because uses fixed Station names
      County = case_when(
        Waterbody == "Aspotogan Harbour" & Station_Name == "Saddle Island" &
          Depl_Date == as_date("2023-05-10") ~ "Lunenburg",

        Waterbody == "Woods Harbour" & Station_Name == "Camerons Cove" &
          Depl_Date == as_date("2019-02-07") ~ "Shelburne",
        Waterbody == "Woods Harbour" & Station_Name == "Woods Harbour" &
          Depl_Date == as_date("2020-09-01") ~ "Shelburne",
        TRUE ~ County
      ),
      First_Bin_Range = case_when(
        First_Bin_Range == "1..6" ~ "1.6",
        Station_Name == "Canoe Island" & Depl_Date == as_date("2020-09-24") &
          is.na(First_Bin_Range) ~ "1.62", # from the metadata in the non side-lobe trimmed excel files
        Station_Name == "Woods Harbour" & Depl_Date == as_date("2020-09-01") &
          is.na(First_Bin_Range) ~ "1", # from the metadata in the non side-lobe trimmed excel files
        TRUE ~ First_Bin_Range
      ),

      Inst_Model = case_when(
        Inst_Model == "Sentinel V100" ~ "Sentinel_V100", TRUE ~ Inst_model
      ),

      # fix column types
      Bin_Size = as.numeric(Bin_Size),
      First_Bin_Range = as.numeric(First_Bin_Range),
      Depl_Lat = round(Depl_Lat, digits = 5),
      Depl_Lon = round(Depl_Lon, digits = 5)
    ) %>%
    # add in Grand Passage Deployment
    rbind(force_row)

  # filter to deployment of interest
  if (!is.null(station) & !is.null(deployment_date)) {
    nsdfa <- nsdfa %>%
      filter(Station_Name == station, Depl_Date = deployment_date) %>%
      select(
        County, Waterbody, Station_Name, `Lease#`,
        Depl_Date, Depl_Lat, Depl_Lon, Recv_Date,
        Inst_Model, Inst_Serial, Inst_Depth, Inst_Altitude,
        Bin_Size, First_Bin_Range, Notes
      )
  }

  nsdfa
}

# July 23, 2021
# This script converts the DateTime column of the wave datasets to UTC

# Data is in the timezone of when the deployment STARTED

# Note: The MarineLabs buoy and Xeos Buoy data are already in UTC 

# libraries needed
library(readr)
library(readxl)
library(dplyr)
library(lubridate)
library(purrr)

# path to folder with wave data to be corrected & station metadata
path <- file.path("Y:/Coastal Monitoring Program/Waves")

# today's date (for output file name)
file_date <- format(Sys.Date(), "%Y%m%d")

# station locations dataset: Includes Model info 
st_info <- read_excel(
  paste0(path,"/20210603_Station_Location_Wave_Dataset.xlsx")
) %>% 
  select(Deployment_ID =`Deployment ID`, County, Waterbody, Model)

# flag if not one of the recognized models
models <- c("Sentinel V20", "Workhorse Sentinel 600kHz", "Sentinel V100",            
            "Xeos Buoy", "MarineLabs Buoy", "Sentinel V50")

un_models <- unique(st_info$Model)

# warning if any entries in the Model column are not in models 
# (e.g., to highlight spelling mistakes)
if(any(!(un_models %in% models))) {
  
  warning("Unrecognized Model in st_locations. \nHINT: Check spelling.")
  
}

# empty list to store duplicate DateTime values
dups <- list()

# files to correct
dat_files <- list.files(paste0(path, "/Timestamp Conversion"), 
                        pattern = ".csv", full.names = TRUE)

# loop over each file
for(i in seq_along(dat_files)){
  
  # wave data for ith county
  dat.i <- read_csv(dat_files[i], col_types = "ccdddddddcnnnnnnnnnnn") %>% 
    mutate(DateTime = as_datetime(DateTime)) %>% 
    left_join(st_info, by = c("Deployment_ID", "Waterbody"))
  
  # county (for file name)
  county <- unique(dat.i$County)
  
  # add 1 day to timestamps that didn't update the day value at midnight
  if(county == "Halifax" | county == "Yarmouth"){
    
    dat.i <- dat.i %>% 
      mutate(
        DateTime = if_else(
          Min == 59 & Sec == 60 & 
          hour(DateTime) == 0 & day(DateTime) == day(lag(DateTime)), 
          DateTime + days(1), DateTime)
      )
  }
  
  if(county == "Guysborough"){
    dat.i <- dat.i %>% 
      mutate(
        DateTime = if_else(
          Deployment_ID == "WGC0001" &
          Min == 59 & Sec == 60 & 
            hour(DateTime) == 0 & day(DateTime) == day(lag(DateTime)), 
          DateTime + days(1), DateTime)
      )
  }

  # Timestamp already in UTC
  dat_utc <- dat.i %>% 
    filter(Model == "MarineLabs Buoy" | Model == "Xeos Buoy")

  # Timestamp needs to be converted to UTC
  dat_convert <- dat.i %>% 
    filter(Model != "MarineLabs Buoy" & Model != "Xeos Buoy") 
  
  # if number of rows are not what is expected, break loop
  if(nrow(dat_utc) + nrow(dat_convert) != nrow(dat.i)){
    
    print(paste0("Error: check ", dat_files[i]))
    
    break
    
  }

  # convert all observations in the deployment to UTC based on the timezone of the first observation
  dat_out <- dat_convert %>% 
    mutate(DateTime_NS = DateTime) %>% # for comparison
    # table indicating whether start date of deployment was in DST or ADT
    left_join(
      dat_convert %>% 
        group_by(Deployment_ID) %>% 
        summarise(DEPL_START = min(DateTime)) %>% 
        mutate(
          TZ_force = force_tz(DEPL_START, tzone = "America/Halifax"),
          DST = dst(TZ_force)
        ) %>% 
        select(Deployment_ID, DST),
      by = "Deployment_ID"
    ) %>% 
    # convert to UTC based on the time zone it was recorded in
    mutate(
      DateTime = case_when(DST == TRUE ~ DateTime + hours(3),
                           DST == FALSE ~ DateTime + hours(4))
    ) %>% 
    select(-DST, -DateTime_NS) %>% 
    rbind(dat_utc) %>% 
    select(-Model, -County) %>% 
    arrange(Deployment_ID, DateTime) %>% 
    # update Year, Month, etc. columns to match new DateTime
    mutate(
      Year = year(DateTime),
      Month = month(DateTime),
      Day = day(DateTime),
      Hour = hour(DateTime),
      Min = minute(DateTime),
      Sec = second(DateTime),
      DateTime = format(DateTime)
    ) 

  if(nrow(dat.i) != nrow(dat_out)){
    
    print(paste0("Error: number of rows in dat.i and dat_out are not equal for: ", dat_files[i]))
    
    break
    
  }
  
  # check for duplicate DateTimes within a deployment - there should not be any
  dups[[i]] <- dat_out %>% 
    group_by(Deployment_ID) %>% 
    filter(duplicated(DateTime))
  
  file_name <- paste(file_date, county, "County_Wave_Data.csv", sep = "_")
  write_csv(dat_out, file = paste(path, "Timestamp Conversion/Corrected", file_name, sep = "/"))
  
  print(i)
}

# this should have zero rows
dups_out <- map_df(dups, rbind)


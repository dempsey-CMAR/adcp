# November 3, 2020

library(readxl)
library(dplyr)
library(tidyr)
library(readr)

# path to where the ADCP data is saved
path <- file.path("C:/Users/Kiersten Watson/Documents/ADCP Reports/Side Lobe Test/Long Beach/")

# name of the ACDP data file (including extension)
file.name <- "2019.01.17_LongBeach1012_Trimmed - SORTED.xlsx"

# Metadata ----------------------------------------------------------------

metadata <- read_excel(paste(path, "/data/", file.name, sep = ""),
                       sheet = "Metadata")
names(metadata) <- c("Instrument", "Data")

# extra site depth and convert to numeric
site_depth <- metadata[which(metadata$Instrument == "Site Depth (m)"), "Data"]$Data %>% 
  as.numeric()

# speed -------------------------------------------------------------------

# import speed data
speed_raw <- read_excel(paste(path, "/data/", file.name, sep = ""),
                        sheet = "Speed - Sorted",
                        col_names = FALSE)

# remove first 5 cols
# remember to check the number in the next line to remove appropriate columns
# remember to check this every time 
speed_raw <- speed_raw[, c(5:ncol(speed_raw))]

# make a vector of altitudes: select the row that starts with "Approximate altitude"
alt.speed <- speed_raw[which(speed_raw[, 1] == "Approximate altitude"), ] %>% 
  select(-1) %>%                   # remove cell "Approximate altitude"
  t() %>%                          # transpose for fun
  as.numeric() %>%                 # convert to numeric
  as.data.frame() %>%              # convert to dataframe
  rename(alt = 1) %>%              # name the column "alt"
  mutate(DEPTH = site_depth - alt) # calculate depth

DEPTH.speed <- alt.speed$DEPTH     # vector of depths

speed <- speed_raw[-c(1:4), -1]

SPEED.tidy <- NULL

for(i in 1:length(DEPTH.speed)){
  
  depth.i <- DEPTH.speed[i]
  
  speed.i <- speed[, i] %>% 
    rename(SPEED = 1) %>% 
    mutate(DEPTH = depth.i,
           SPEED = as.numeric(SPEED))
  
  speed.i$DEPTH <- depth.i
  speed.i$INDEX <- c(1:nrow(speed.i))
  
  SPEED.tidy <- rbind(SPEED.tidy, speed.i)
}


# Direction ---------------------------------------------------------------

dir_raw <- read_excel(paste(path, "/data/", file.name, sep = ""),
                      sheet = "Direction - Sorted",
                      col_names = FALSE)

# remember to check the number in the next line to remove appropriate columns
# remember to check this every time
dir_raw  <- dir_raw [, c(5:ncol(dir_raw ))]

# make a vector of altitudes: select the row that starts with "Approximate altitude"
alt.dir <- dir_raw [which(dir_raw [, 1] == "Approximate altitude"), ] %>% 
  select(-1) %>%                   # remove cell "Approximate altitude"
  t() %>%                          # transpose for fun
  as.numeric() %>%                 # convert to numeric
  as.data.frame() %>%              # convert to dataframe
  rename(alt = 1) %>%              # name the column "alt"
  mutate(DEPTH = site_depth - alt) # calculate depth

DEPTH.dir <- alt.dir$DEPTH

dir <- dir_raw[-c(1:4), -1]
dir.tidy <- NULL

for(i in 1:length(DEPTH.dir)){
  
  depth.i <- DEPTH.dir[i]
  
  dir.i <- dir[, i] %>% 
    rename(DIRECTION = 1) %>% 
    mutate(DEPTH = depth.i)
  
  dir.i$DEPTH <- depth.i
  dir.i$INDEX <- c(1:nrow(dir.i))
  
  dir.tidy <- rbind(dir.tidy, dir.i)
}


# Merge Speed and Direction by Depth --------------------------------------
ALL.loop <- full_join(SPEED.tidy, dir.tidy, by = c("INDEX", "DEPTH")) %>% 
  select(DEPTH, SPEED, DIRECTION) 


# This particular dataset needs to be converted to cm/s ------------------------
SPEED.cm<-(ALL.loop$SPEED*100)
ALL.loop.cm<-cbind(ALL.loop,SPEED.cm)
rm(SPEED.cm)

write_csv(ALL.loop.cm,paste(path,"/data/", "trimmed.data.csv", sep=""))


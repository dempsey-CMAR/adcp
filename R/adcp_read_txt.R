#' Read ADCP txt file
#'
#' @details Options to trim NA's and fix timestamp.
#'
#' @param path Path to the txt file (including ".txt" extension) or to the
#'   folder where the txt file is saved.
#'
#' @param file_name Required if \code{path} does not include the file name.
#'   Include the ".txt" file extension. Default is \code{file_name = NULL}.
#'
#' @param trim_NA Logical argument indicating whether to trim ensembles that
#'   have NA in each WaterSpeed and WaterDirection bin.
#'
#' @param timestamp_utc Logical argument indicating whether to convert the
#'   TIMESTAMP from the timezone it was recorded in (AST or DST) to UTC. Default
#'   is \code{timestamp_utc = TRUE}.
#'
#' @return Returns a dataframe and / csv file of the data with a single header
#'   row and each row labelled as "SensorDepth", "WaterSpeed", or
#'   "WaterDirection". Single TIMESTAMP column
#'
#' @importFrom data.table fread
#' @importFrom dplyr %>% across case_when everything filter if_else last_col
#'   mutate n select
#' @importFrom lubridate make_datetime
#' @importFrom stringr str_detect

#' @export


adcp_read_txt <- function(path, file_name = NULL,
                          trim_NA = TRUE,
                          timestamp_utc = TRUE){


  if(!is.null(file_name)) path <- paste0(path, "/", file_name)

  path <- file.path(path)

  if(!str_detect(path, "txt")) stop("File extension not found. \nHINT: Include .txt in path or file_name.")

  # names and order of parameters in txt file (SensorDepth, WaterSpeed, WaterDirection)
  params <- data.table::fread(path, nrows = 3, header = FALSE, select = 8)
  params <- params$V8

  # read in data
  dat_raw <- fread(path,
                   sep2 = ",",         # make separate columns for each cell
                   fill = TRUE,        # add NA for cells that do not have data
                   header = TRUE,      # keep header names
                   skip = 2,           # skip first two rows (duplicate header vals)
                   data.table = FALSE) # return a dataframe (instead of data.table)

  # one column will be named SensorDepth, WaterSpeed, or WaterDirection. Change to V8
  colnames(dat_raw)[which(colnames(dat_raw) %in% params)] <- paste0(
    "V", which(colnames(dat_raw) %in% params)
  )

  # rows alternate between SensorDepth, WaterSpeed, and WaterDirection
  dat <- dat_raw %>%
    mutate(INDEX = 1:n(),
           VARIABLE = case_when(
             INDEX %in% seq(1, n(), 3) ~ params[1],
             INDEX %in% seq(2, n(), 3) ~ params[2],
             INDEX %in% seq(3, n(), 3) ~ params[3],
             TRUE ~ NA_character_
           ),
           TIMESTAMP_NS = make_datetime(Year, Month, Day, Hour, Min, Sec)
    ) %>%
    select(-INDEX) %>%
    select(TIMESTAMP_NS, Num, VARIABLE, V8:last_col()) %>%
    mutate(across(V8:last_col(), ~if_else(is.nan(.), NA_real_, .)))

  # Trim and/or Correct Timestamps ------------------------------------------

  if(trim_NA) dat <- dat %>% adcp_trim_NA()
  if(timestamp_utc) dat <- dat %>% adcp_correct_timestamp()

  # QA checks ---------------------------------------------------------------

  # SensorDepth rows should only have data in col V8
  check <- dat %>%
    filter(VARIABLE == "SensorDepth") %>%
    select(V9:last_col())

  if(!all(is.na(check))) warning("More than one SensorDepth found for one row. \nHINT: Check labelling code")

  adcp_check_duplicate_timestamp(dat)

  # Return dat --------------------------------------------------------------

  dat

}

















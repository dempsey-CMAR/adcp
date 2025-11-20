#' Index of first bin column
#'
#' @param dat_wide Data frame of ADCP data, as exported from
#'   \code{adcp_read_txt()}.
#'
#' @return Returns the index of the first column with bin data.
#'
#' @importFrom stringr str_match str_remove
#' @importFrom stats na.omit
#'
#' @export

find_index <- function(dat_wide) {

  # so can use with output directly from adcp_read_text()
  colnames_numeric <- str_match(colnames(dat_wide), "V\\d*$") %>%
    str_remove("V")

  if (length(na.omit(colnames_numeric)) > 0) {
    col_start <- which(
      colnames_numeric == min(as.numeric(colnames_numeric), na.rm = TRUE)
    )

    col_end <- which(
      colnames_numeric == max(as.numeric(colnames_numeric), na.rm = TRUE)
    )

    colnames(dat_wide)[col_start:col_end] <- colnames_numeric[col_start:col_end]
  }

  # index of the first measurement column
  suppressWarnings(
    which(colnames(dat_wide) == min(as.numeric(colnames(dat_wide)), na.rm = TRUE))
  )
}




#' Extract deployment date and station name from file path
#'
#' @param file_path Path to the file, include file name and extension (.csv or
#'   .txt). File name must include the deployment date and the station name, in
#'   the format YYYY-MM-DD_Station Name.ext (e.g., 2007-12-18_Spectacle
#'   Island.txt)
#'
#' @return Returns a tibble with three columns: \code{DEPLOYMENT},
#'   \code{Depl_Date}, and \code{Station_Name}.
#'
#' @importFrom dplyr mutate tibble
#' @importFrom lubridate as_date
#' @importFrom stringi stri_locate
#' @importFrom stringr str_remove str_replace_all str_sub str_trim
#' @importFrom tidyr separate
#'
#' @export

adcp_extract_deployment_info <- function(file_path) {
  data.frame(file_path) %>%
    str_sub(stringi::stri_locate_last(file_path, regex = "/")[1] + 1) %>%
    str_remove(pattern = ".txt|.csv") %>%
    tibble(DEPLOYMENT = .) %>%
    separate(
      col = 1, sep = 10, # separate after the date so will work for station names with more than one word
      into = c("Depl_Date", "Station_Name"), #, "Depl_ID"),
      remove = FALSE
    ) %>%
    mutate(
      Station_Name = str_replace_all(Station_Name, "_", " "),
      Station_Name = str_trim(Station_Name),
      Depl_Date = as_date(Depl_Date)
    )
}


#' Convert depth_flag column to ordered factor
#'
#' @param dat Data frame of ACDP data in long format, as returned by
#'   \code{adcp_flag_data()}.
#'
#' @return Returns \code{dat}, with the \code{depth_flag} column as an ordered
#'   factor, with levels \code{"good" < "SENSOR_DEPTH_BELOW_SURFACE changed by >
#'   x m" < "manual flag"}.
#'
#' @importFrom dplyr mutate
#' @importFrom stringr str_detect
#'
#' @export

adcp_convert_flag_to_ordered_factor <- function(dat) {
  flags <- unique(dat$depth_flag)

  auto_flag <- flags[str_detect(flags, "sensor_depth")]

  flags_order <- c("good", auto_flag, "manual flag")

  dat %>%
    mutate(
      depth_flag = as.character(depth_flag),
      depth_flag = factor(depth_flag, levels = flags_order, ordered = TRUE)
    )
}


#' Check if there are files in the specified folder
#'
#' @param path Path to the folder to check.
#'
#' @param pattern Character string indicating what file type to check for.
#'
#' @returns Returns a Warning if there are files in the folder. Returns a
#'   message if not.
#'
#' @export

adcp_check_new_folder <- function(path, pattern = "csv") {

  dat_new <- list.files(path, pattern = "csv")

  if(length(dat_new) > 0) {
    warning(paste0("There are ", length(dat_new), " files in ", path,
                   ".\nMove these to the county folder to assemble"))
  } else {
    message("No files found in ", path)
  }
}



#' Add a column of current variables in title case
#'
#' @param dat Data frame of current data in long format. Flag columns will be
#'   dropped.
#'
#' @param convert_to_ordered_factor Logical variable indicating whether the new
#'   \code{variable_title} column should be converted to an ordered factor.
#'   Default is \code{TRUE}.
#'
#' @return Returns \code{dat} with an additional \code{variable_title} column
#'   for use in faceted figures.
#'
#' @importFrom dplyr case_when mutate
#' @importFrom stringr str_detect
#'
#' @export
#'

adcp_convert_vars_to_title <- function(dat, convert_to_ordered_factor = TRUE) {

  dat <- dat %>%
    mutate(
      variable_title = case_when(

        variable == "sensor_depth_below_surface_m" ~ "Sensor Depth Below Surface",
        variable == "sea_water_speed_m_s" ~ "Sea Water Speed",
        variable == "sea_water_to_direction_degree" ~
          "Direction Sea Water is Travelling To",

        TRUE ~ NA_character_
      )
    )

  if(isTRUE(convert_to_ordered_factor)) {
    dat <- dat %>%
      mutate(
        variable_title = ordered(
          variable_title,
          levels = c(
            "Sea Water Speed",
            "Direction Sea Water is Travelling To",
            "Sensor Depth Below Surface"))
      )
  }

  dat
}






#' Assign altitude (height above sea floor) to each bin
#'
#' @param dat Output from \code{read_adcp_txt()}.
#'
#' @param metadata Dataframe with metadata information for the deployment in
#'   \code{dat} (e.g., a row from the NSDFA tracking sheet). Must include
#'   columns \code{Inst_Altitude}, \code{Bin_Size}, and \code{First_Bin_Range}.
#'   If default value \code{metadata = NULL} is used, the remaining arguments
#'   must be provided.
#'
#' @param inst_alt Height of the instrument above the sea floor (in metres). Not
#'   required if \code{metadata} argument is specified.
#'
#' @param bin_size Size of each bin (in metres). Not required if \code{metadata}
#'   argument is specified.
#'
#' @param first_bin_range Size of the first bin (in metres). Not required if
#'   \code{metadata} argument is specified.
#'
#' @return Returns \code{dat}, with bin columns re-named with corresponding
#'   altitude (in metres).
#'
#' @export


adcp_assign_altitude <- function(dat,
                            metadata = NULL,
                            inst_alt = NULL,
                            bin_size = NULL,
                            first_bin_range = NULL){

  if(!is.null(metadata)){

    inst_alt <- metadata$Inst_Altitude
    bin_size <- metadata$Bin_Size
    first_bin_range <- metadata$First_Bin_Range

  }

  # number of bins to name
  n_bins <- dat %>% select(V8:last_col()) %>% ncol()

  # altitude of the first bin
  first_bin <- inst_alt + first_bin_range

  # altitude of each bin
  colnames_bins <- seq(first_bin, by = bin_size, length.out = n_bins)

  # keep TIMESTAMP, Num, and VARIABLE column names
  colnames_keep <- colnames(dat)[1:(which(colnames(dat) == "V8") - 1)]


  colnames_new <- c(colnames_keep, colnames_bins)

  names(dat) <- colnames_new

  dat

}

#' Formats deployment table for summary report
#'
#' @param report_table Deployment metadata from the NSDFA tracking sheet, as
#'   returned from \code{adcp_write_report_table()}.
#'
#' @return Returns a flextable object that will render nicely in the Word
#'   report. A table with two columns: the first column (bold) is the column
#'   names of \code{report_table}; the second column is the corresponding
#'   entries in \code{report_table}.
#'
#' @importFrom dplyr mutate select
#' @importFrom officer fp_border
#' @importFrom  flextable delete_part vline border_outer border_inner_h
#'   border_inner_v bold font fontsize autofit fit_to_width
#'
#' @export
#'

adcp_format_report_table <- function(report_table){

  # transpose table and make the column names the first column
  t_table <- report_table %>%
    t() %>%
    data.frame() %>%
    mutate(Record = colnames(report_table)) %>%
    select(Record, 'Deployment Info' = 1)
  rownames(t_table) <- NULL

  # set border style
  small_border <- officer::fp_border(color = "gray", width = 1)

  # format table
  t_table %>%
    flextable::flextable() %>%
    flextable::delete_part(part = "header") %>%
    # borders
    flextable::vline(border = small_border, part = "all" )%>%
    flextable::border_outer(part = "all", border = small_border )%>%
    flextable::border_inner_h(part = "all", border = small_border )%>%
    flextable::border_inner_v(part = "all", border = small_border )%>%
    # font
    flextable::bold(i = NULL, j = 1, bold = TRUE, part = "body") %>%
    flextable::font(part = "all", fontname = "ebrima") %>%
    flextable::fontsize(size = 10, part = "all") %>%
    # fit
    flextable::autofit() %>%
    flextable::fit_to_width(7.5)

}

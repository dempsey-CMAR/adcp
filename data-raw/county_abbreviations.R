library(usethis)


county_abb <- data.frame(
  county = c("Annapolis", "Antigonish", "Cape Breton", "Colchester", "Cumberland",
             "Digby", "Guysborough", "Halifax", "Hants", "Inverness", "Kings",
             "Lunenburg", "Pictou", "Queens", "Richmond", "Shelburne",
             "Victoria", "Yarmouth"),

  abb = c("AN", "AT", "CB", "CL", "CM", "DG", "GY", "HL", "HN", "IV", "KN",
          "LN", "PC", "QN", "RC", "SH", "VC", "YR")

)

usethis::use_data(county_abb, internal = TRUE)

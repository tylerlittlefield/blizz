fetch_region <- function(region) {

  # If the region exist, move on. If not, stop.
  if(any(regions[["region"]] %in% region)) {
    output <- regions[regions[["region"]] == region,][1,]
  } else {
    stop("The region: ", region, " does not exist.")
  }

  # # If the locale is null (default), just grab the first row for the given
  # # region. If the user does give a region and it exists, grab that specific row
  # # else stop.
  # if(is.null(locale)) {
  #   output <- regions[regions[["region"]] == region,][1,]
  # } else if(any(regions[["locale"]] %in% locale)) {
  #   output <- regions[regions[["region"]] == region & regions[["locale"]] == locale, ]
  # } else {
  #   stop("The locale: ", locale, " does not exist.")
  # }

  return(output)

}

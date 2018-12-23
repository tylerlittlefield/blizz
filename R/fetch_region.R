fetch_region <- function(region) {

  # If the region exist, move on. If not, stop.
  if(any(regions[["region"]] %in% region)) {
    output <- regions[regions[["region"]] == region,][1,]
  } else {
    stop("The region: ", region, " does not exist.")
  }

  return(output)

}

#' Extract Data from Blizzards API
#' @description Main function for interactive with Blizzards API. At the bare
#' minimum, you must provide the endpoint (see: Blizzards API docs). You may
#' also suggest a valid region and locale. By default, \code{blizz} defaults to
#' the US. Finally, you may view the data as a JSON object i.e.
#' \code{json = TRUE} or as a R object (default) i.e. \code{json = FALSE}.
#'
#' @param endpoint An endpoint provided by Blizzards API documentation
#' @param region API data is limited to specific regions. For example, US APIs
#' accessed through us.battle.net only contain data from US battlegroups and
#' realms. See the dataset \code{regions} for more info.
#' @param json Logical TRUE/FALSE to return a JSON object or a R object,
#' defaults to R.
#' @export
blizz <- function(endpoint, region = "us", json = FALSE) {

  # Fetch users auth_token
  auth_token <- fetch_creds()[["token"]]

  # Fetch user region
  region <- fetch_region(region)

  # Declare the components needs for the request
  blizz_host <- region[["host"]]
  token <- "access_token={auth_token}"

  request <- glue::glue(blizz_host, endpoint, token)
  request_censored <- glue::glue(blizz_host, endpoint, "access_token=[*]")

  message("Attempting to pull data from:\n", request_censored, "\n")

  if(json) {
    jsonlite::toJSON(jsonlite::fromJSON(request), pretty = TRUE)
  } else {
    jsonlite::fromJSON(request)
  }

}

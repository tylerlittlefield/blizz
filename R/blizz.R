#' Extract Blizzard Game Data
#' @description Main function to grab data from Blizzard's API. At the bare
#' minimum, you must provide the endpoint (see: Blizzard's API docs). You may
#' also provide a valid locale and namespace. Finally, you may view the data as
#' a JSON object i.e. \code{blizz("/some/endpoint", json = TRUE)} or as a R
#' object (default) i.e. \code{blizz("/some/endpoint")}.
#'
#' @param endpoint An endpoint provided by Blizzards API documentation
#' @param locale All available API resources provide localized strings using the
#' locale query string parameter. Supported locales vary from region to region
#' and align with those supported on Blizzard community sites. Defaults to
#' \code{"en_US"}.
#' @param namespace Namespaces in Game Data and Profile APIs that allow JSON
#' documents to be published contextually in relation to a specific patch or
#' point in time. Defaults to \code{NULL}.
#' @param json Logical TRUE/FALSE to return a JSON object or a R object,
#' defaults to R.
#' @param quiet If \code{FALSE}, request information will not print. Defaults to
#' \code{TRUE}.
#' @export
blizz <- function(endpoint, locale = "en_US", namespace = NULL, json = FALSE, quiet = FALSE) {
  x <- httr::VERB(
    verb = "GET",
    url = glue::glue("https://us.api.blizzard.com{endpoint}"),
    query = list(
      namespace = namespace,
      locale = locale,
      access_token = Sys.getenv("BLIZZARD_AUTH_TOKEN")
    )
  )

  if(!quiet)
    print_info(x)

  x <- httr::content(x) # grab the request content

  if(json) {
    jsonlite::toJSON(x, pretty = TRUE)
  } else {
    x <- jsonlite::toJSON(x)
    jsonlite::fromJSON(x)
  }
}

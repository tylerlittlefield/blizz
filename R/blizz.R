#' Extract Data from Blizzards API
#' @description Main function for interactive with Blizzards API. At the bare
#' minimum, you must provide the endpoint (see: Blizzards API docs). You may
#' also suggest a valid region and locale. By default, \code{blizz} defaults to
#' the US. Finally, you may view the data as a JSON object i.e.
#' \code{json = TRUE} or as a R object (default) i.e. \code{json = FALSE}.
#'
#' @param endpoint An endpoint provided by Blizzards API documentation
#' @param locale All available API resources provide localized strings using the
#' locale query string parameter. Supported locales vary from region to region
#' and align with those supported on Blizzard community sites.
#' @param namespace Namespaces in Game Data and Profile APIs that allow JSON
#' documents to be published contextually in relation to a specific patch or
#' point in time.
#' @param json Logical TRUE/FALSE to return a JSON object or a R object,
#' defaults to R.
#' @export
blizz <- function(endpoint, locale = "en_US", namespace = NULL, json = FALSE) {
  x <- httr::VERB(
    verb = "GET",
    url = glue::glue("https://us.api.blizzard.com{endpoint}"),
    query = list(
      namespace = namespace,
      locale = locale,
      access_token = Sys.getenv("BLIZZARD_AUTH_TOKEN")
    )
  )

  print_info(x)         # get request info: url, status code, content type
  x <- httr::content(x) # grab the request content

  if(json) {
    jsonlite::toJSON(x, pretty = TRUE)
  } else {
    x <- jsonlite::toJSON(x)
    jsonlite::fromJSON(x)
  }
}

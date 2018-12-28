refresh_auth <- function(id = NULL, secret = NULL) {
  if(is.null(id) & is.null(secret)) {
    id <- Sys.getenv("BLIZZARD_CLIENT_ID")
    secret <- Sys.getenv("BLIZZARD_CLIENT_SECRET")
    curl_req <- glue::glue("curl -u {id}:{secret} -d grant_type=client_credentials https://us.battle.net/oauth/token")
    curl_resp <- invisible(system(curl_req, intern = TRUE))
    TOKEN <- jsonlite::fromJSON(curl_resp)[["access_token"]]
    AUTH_TOKEN <- glue::glue("BLIZZARD_AUTH_TOKEN='{TOKEN}'")
  } else {
    curl_req <- glue::glue("curl -u {id}:{secret} -d grant_type=client_credentials https://us.battle.net/oauth/token")
    curl_resp <- invisible(system(curl_req, intern = TRUE))
    TOKEN <- jsonlite::fromJSON(curl_resp)[["access_token"]]
    AUTH_TOKEN <- glue::glue("BLIZZARD_AUTH_TOKEN='{TOKEN}'")
  }
}

fetch_creds <- function() {
  id <- Sys.getenv("BLIZZARD_CLIENT_ID")
  secret <- Sys.getenv("BLIZZARD_CLIENT_SECRET")
  token <- Sys.getenv("BLIZZARD_AUTH_TOKEN")
  list(id = id, secret = secret, token = token)
}

fetch_region <- function(region) {
  if(any(regions[["region"]] %in% region)) {
    output <- regions[regions[["region"]] == region,][1,]
  } else {
    stop("The region: ", region, " does not exist.")
  }
  return(output)
}

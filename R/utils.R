authenticate <- function(id, secret) {
  resp <- httr::VERB(
    verb = "POST",
    url = "https://us.battle.net/oauth/token",
    httr::authenticate(
      user = id,
      password = secret
    ),
    body = list(
      grant_type = "client_credentials"
    )
  )

  resp_contents <- httr::content(resp)
  access_token <- resp_contents[["access_token"]]

  list(reponse = resp, contents = resp_contents, token = access_token)
}

refresh_token <- function(access_token) {
  Sys.setenv(BLIZZARD_AUTH_TOKEN = access_token) # to prevent having to restart R
  home <- Sys.getenv("HOME")
  renv <- file.path(home, ".Renviron")

  old_renv <- utils::read.table(renv, stringsAsFactors = FALSE)
  mod_renv <- old_renv[-grep("BLIZZARD_AUTH_TOKEN", old_renv[[1]]), ]
  new_renv <- c(mod_renv, glue::glue("BLIZZARD_AUTH_TOKEN={access_token}"))

  utils::write.table(
    new_renv,
    renv,
    quote = FALSE,
    sep = "\n",
    col.names = FALSE,
    row.names = FALSE
  )
}

fetch_region <- function(region) {
  if(any(regions[["region"]] %in% region)) {
    output <- regions[regions[["region"]] == region,][1,]
  } else {
    stop("The region: ", region, " does not exist.")
  }
  return(output)
}

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

fetch_info <- function(request) {
  req_url <- request[["url"]]
  req_url <- gsub("\\=.*", "", req_url)
  status <- request[["status_code"]]
  content_type <- request[["headers"]][["content-type"]]

  glue::glue(
    "Request: {req_url}=[*]
     Status: {status}
     Content-Type: {content_type}"
  )
}

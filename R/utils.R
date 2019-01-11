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

print_info <- function(request) {
  req_url <- request[["url"]]
  req_url <- gsub("\\?.*", "", req_url)
  status <- request[["status_code"]]
  content_type <- request[["headers"]][["content-type"]]

  x <- glue::glue(crayon::bold(" Request: "), req_url)
  y <- glue::glue(crayon::bold(" Status: "), status)
  z <- glue::glue(crayon::bold(" Content-Type: "), content_type)

  is_success <- !httr::http_error(request)
  if(is_success) {
    cat(
      glue::glue(
        crayon::green(cli::symbol$tick), x, "\n",
        crayon::green(cli::symbol$tick), y, "\n",
        crayon::green(cli::symbol$tick), z, "\n\n"
      )
    )
  } else {
    cat(
      glue::glue(
        crayon::red(cli::symbol$cross), x, "\n",
        crayon::red(cli::symbol$cross), y, "\n\n",
      )
    )
  }
}

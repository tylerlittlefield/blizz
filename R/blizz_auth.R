#' Authenticate Blizzard API
#' @description The function will install the Client ID, Client Secret, and
#' Authentication Token to the \code{.Renviron} file for repeated use. However,
#' tokens expire after 24 hours so after the initial install, running
#' \code{blizz_auth(refresh = TRUE)} will be required once the 24 hour period
#' has passed.
#' @param id The Client ID provided once a Client has been made on Blizzard's Dev Portal.
#' @param secret The Client Secret provided once a Client has been made on Blizzard's Dev Portal.
#' @param refresh If TRUE, the CLIENT_AUTH_TOKEN will be refreshed. Blizzard Auth Tokens expire after 24 hours.
#' @param install If TRUE, will install the key in your \code{.Renviron} file for use in future sessions.  Defaults to TRUE.
#' @export
blizz_auth <- function(id, secret, refresh = FALSE, install = TRUE) {
  if (refresh) {
    credentials <- authenticate(
      id = Sys.getenv("BLIZZARD_CLIENT_ID"),
      secret = Sys.getenv("BLIZZARD_CLIENT_SECRET")
    )

    access_token <- credentials[["token"]]
    refresh_token(access_token)
  } else if (install) {
    if (missing(id) & missing(secret)) {
      stop("Client ID and Secret required to authenticate.")
    } else if (missing(id)) {
      stop("Client ID is required to authenticate.")
    } else if (missing(secret)) {
      stop("Client Secret is required to authenticate.")
    }

    credentials <- authenticate(
      id = id,
      secret = secret
    )

    access_token <- credentials[["token"]]

    home <- Sys.getenv("HOME") # find home
    renv <- file.path(home, ".Renviron") # construct path

    if (file.exists(renv)) {
      # Backup original .Renviron before doing anything else here.
      file.copy(renv, file.path(home, ".Renviron_backup"))
    }
    if (!file.exists(renv)) {
      file.create(renv)
    }

    old_renv <- utils::read.table(renv, stringsAsFactors = FALSE)

    if (length(old_renv[grep("BLIZZARD", old_renv[[1]]), ]) > 0) {
      stop("Blizzard crentials detected in `.Renviron`. No need to install. Perhaps you meant to refresh the token, i.e. `blizz_auth(refresh = TRUE)`?")
    } else {
      client_id <- glue::glue("BLIZZARD_CLIENT_ID={id}")
      client_secret <- glue::glue("BLIZZARD_CLIENT_SECRET={secret}")
      access_token <- glue::glue("BLIZZARD_AUTH_TOKEN={access_token}")

      new_renv <- c(old_renv[[1]], client_id, client_secret, access_token)

      utils::write.table(
        new_renv,
        renv,
        quote = FALSE,
        sep = "\n",
        col.names = FALSE,
        row.names = FALSE
      )
    }
  } else {
    Sys.setenv(BLIZZARD_AUTH_TOKEN = access_token)
  }
}

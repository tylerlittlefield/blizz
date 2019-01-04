blizz_auth <- function(id, secret, refresh = FALSE, install = TRUE) {

  # If refresh = TRUE, we will take the CLIENT_ID and CLIENT_SECRET from the
  # .Renviron file and use it in our request. We then modify the .Renviron file
  # by replacing the old access token with a new one.
  if(refresh) {
    resp <- httr::VERB(
      verb = "POST",
      url = "https://us.battle.net/oauth/token",
      httr::authenticate(
        user = Sys.getenv("BLIZZARD_CLIENT_ID"),
        password = Sys.getenv("BLIZZARD_CLIENT_SECRET")
      ),
      body = list(
        grant_type = "client_credentials"
      )
    )

    resp_contents <- httr::content(resp)
    access_token <- resp_contents[["access_token"]]

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
    # If install = TRUE, we check that the id, secret args aren't missing then
    # make our request with the give id, secret provided by the user. We then
    # look for the .Renviron, if it does exist, we make one. If it does exist,
    # we create a copy of it named ".Renviron_backup". We then check to see if
    # there are an environment variables with "BLIZZARD" in the name, if there
    # is, we throw an error and if not, store the CLIENT_ID, SECRET, and
    # AUTH_TOKEN in .Renviron
    else if(install) {
    if(missing(id) & missing(secret)) {
      stop("Client ID and Secret required to authenticate.")
    } else if(missing(id)) {
      stop("Client ID is required to authenticate.")
    } else if(missing(secret)) {
      stop("Client Secret is required to authenticate.")
    }

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

    home <- Sys.getenv("HOME") # find home
    renv <- file.path(home, ".Renviron") # construct path

    if(file.exists(renv)) {
      # Backup original .Renviron before doing anything else here.
      file.copy(renv, file.path(home, ".Renviron_backup"))
    }
    if(!file.exists(renv)) {
      file.create(renv)
    }
    old_renv <- utils::read.table(renv, stringsAsFactors = FALSE)
    if(length(old_renv[grep("BLIZZARD", old_renv[[1]]),]) > 0) {
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
  }
    # At the end, if the user doesn't want to install, we just set the
    # environment variable for interactive use.
    else {
    Sys.setenv(BLIZZARD_AUTH_TOKEN = access_token)
  }
}

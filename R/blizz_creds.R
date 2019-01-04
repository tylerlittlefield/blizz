#' Install All Required Blizzard Credentials in Your \code{.Renviron} File for
#' Repeated Use
#' @description This function will add your BLIZZARD CLIENT ID,
#' BLIZZARD SECRET ID and BLIZZARD AUTH TOKEN to your \code{.Renviron} file so
#' it can be called securely without being stored in your code. After you have
#' installed your credentials, it can be called any time by typing
#' \code{Sys.getenv("BLIZZARD_CLIENT_ID")} and can be used in package functions
#' by simply typing BLIZZARD_CLIENT_ID. If you do not have an \code{.Renviron}
#' file, the function will create on for you. If you already have an
#' \code{.Renviron} file, the function will append the key to your existing
#' file, while making a backup of your original file for disaster recovery purposes.
#' @param id The CLIENT ID provided to you by Blizzard formated in quotes. A client id can be acquired at \url{https://develop.battle.net/}
#' @param secret The CLIENT SECRET provided to you by Blizzard formated in quotes. A client id can be acquired at \url{https://develop.battle.net/}
#' @param install if TRUE, will install the key in your \code{.Renviron} file for use in future sessions.  Defaults to FALSE.
#' @param overwrite If this is set to TRUE, it will overwrite an existing Blizzard credentials that you already have in your \code{.Renviron} file.
#' @param refresh If this is set to TRUE, the CLIENT_AUTH_TOKEN will be refreshed. Blizzard Auth Tokens expire after 24 hours.
#' @importFrom utils write.table read.table
#' @export
blizz_creds <- function(id, secret, overwrite = FALSE, install = TRUE, refresh = FALSE) {
  if(refresh) {
    token <- refresh_auth()
    bare_token <- strsplit(token, "=")[[1]][2]
    bare_token <- gsub("'", "", bare_token)
    Sys.setenv(BLIZZARD_AUTH_TOKEN = bare_token) # to prevent having to restart R
    home <- Sys.getenv("HOME")
    renv <- file.path(home, ".Renviron")
    old_renv <- utils::read.table(renv, stringsAsFactors = FALSE)
    mod_renv <- old_renv[-grep("BLIZZARD_AUTH_TOKEN", old_renv[[1]]), ]
    new_renv <- c(mod_renv, token)
    utils::write.table(
      new_renv,
      renv,
      quote = FALSE,
      sep = "\n",
      col.names = FALSE,
      row.names = FALSE
    )
  } else if(install) {
    home <- Sys.getenv("HOME")
    renv <- file.path(home, ".Renviron")
    if(file.exists(renv)) {
      # Backup original .Renviron before doing anything else here.
      file.copy(renv, file.path(home, ".Renviron_backup"))
    }
    if(!file.exists(renv)) {
      file.create(renv)
    }
    else {
      if(isTRUE(overwrite)) {
        message("Your original .Renviron will be backed up and stored in your R HOME directory if needed.")
        oldenv=utils::read.table(renv, stringsAsFactors = FALSE)
        newenv <- oldenv[-grep("BLIZZARD_CLIENT_ID", oldenv),]
        newenv <- oldenv[-grep("BLIZZARD_SECRET_ID", oldenv),]
        utils::write.table(newenv, renv, quote = FALSE, sep = "\n",
                           col.names = FALSE, row.names = FALSE)
      }
      else {
        tv <- readLines(renv)
        if(any(grepl("BLIZZARD", tv))) {
          stop("Blizzard credentials already exists. You can overwrite it with the argument overwrite=TRUE", call.=FALSE)
        }
      }
    }
    token <- refresh_auth(id, secret)
    id <- glue::glue("BLIZZARD_CLIENT_ID='{id}'")
    secret <- glue::glue("BLIZZARD_CLIENT_SECRET='{secret}'")
    write(id, renv, sep = "\n", append = TRUE)
    write(secret, renv, sep = "\n", append = TRUE)
    write(token, renv, sep = "\n", append = TRUE)
    message('Your client ID, SECRET and AUTH_TOKEN has been stored in your .Renviron and can be accessed by Sys.getenv("BLIZZARD_CLIENT_ID"), Sys.getenv("BLIZZARD_CLIENT_SECRET") or Sys.getenv("BLIZZARD_AUTH_TOKEN"). \nTo use now, restart R or run `readRenviron("~/.Renviron")`\n')
    return(c(id, secret, token))
  } else {
    message("To install your API key for use in future sessions, run this function with `install = TRUE`.")
    token <- refresh_auth(id, secret)
    token <- sub(".*'(.*)'.*", '\\1', token)
    Sys.setenv(BLIZZARD_CLIENT_ID = id)
    Sys.setenv(BLIZZARD_CLIENT_SECRET = secret)
    Sys.setenv(BLIZZARD_AUTH_TOKEN = token)
  }
}

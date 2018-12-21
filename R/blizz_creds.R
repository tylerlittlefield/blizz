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
#' @importFrom utils write.table read.table
#' @export
blizz_creds <- function(id, secret, overwrite = FALSE, install = TRUE) {
  if (install) {
    home <- Sys.getenv("HOME")
    renv <- file.path(home, ".Renviron")
    if(file.exists(renv)){
      # Backup original .Renviron before doing anything else here.
      file.copy(renv, file.path(home, ".Renviron_backup"))
    }
    if(!file.exists(renv)){
      file.create(renv)
    }
    else{
      if(isTRUE(overwrite)){
        message("Your original .Renviron will be backed up and stored in your R HOME directory if needed.")
        oldenv=utils::read.table(renv, stringsAsFactors = FALSE)
        newenv <- oldenv[-grep("BLIZZARD_CLIENT_ID", oldenv),]
        newenv <- oldenv[-grep("BLIZZARD_SECRET_ID", oldenv),]
        utils::write.table(newenv, renv, quote = FALSE, sep = "\n",
                    col.names = FALSE, row.names = FALSE)
      }
      else{
        tv <- readLines(renv)
        if(any(grepl("BLIZZARD", tv))){
          stop("Blizzard credentials already exists. You can overwrite it with the argument overwrite=TRUE", call.=FALSE)
        }
      }
    }
    ID <- glue::glue("BLIZZARD_CLIENT_ID='{id}'")
    SECRET <- glue::glue("BLIZZARD_CLIENT_SECRET='{secret}'")

    curl_req <- glue::glue("curl -u {id}:{secret} -d grant_type=client_credentials https://us.battle.net/oauth/token")
    curl_resp <- invisible(system(curl_req, intern = TRUE))
    TOKEN <- jsonlite::fromJSON(curl_resp)[["access_token"]]
    AUTH_TOKEN <- glue::glue("BLIZZARD_AUTH_TOKEN='{TOKEN}'")

    # Append API key to .Renviron file
    write(ID, renv, sep = "\n", append = TRUE)
    write(SECRET, renv, sep = "\n", append = TRUE)
    write(AUTH_TOKEN, renv, sep = "\n", append = TRUE)
    message('Your client ID, SECRET and AUTH_TOKEN has been stored in your .Renviron and can be accessed by Sys.getenv("BLIZZARD_CLIENT_ID"), Sys.getenv("BLIZZARD_CLIENT_SECRET") or Sys.getenv("BLIZZARD_AUTH_TOKEN"). \nTo use now, restart R or run `readRenviron("~/.Renviron")`')
    return(c(ID, SECRET))
  } else {
    message("To install your API key for use in future sessions, run this function with `install = TRUE`.")
    Sys.setenv(BLIZZARD_CLIENT_ID = id)
    Sys.setenv(BLIZZARD_CLIENT_SECRET = secret)
  }
}

# Refresh the auth token everytime the library is loaded
.onLoad <- function(libname, pkgname) {
  has_token <- nchar(Sys.getenv("BLIZZARD_AUTH_TOKEN")) > 1
  if(has_token)
    blizz_auth(refresh = TRUE)
}

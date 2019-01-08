# Refresh the auth token everytime the library is loaded
.onLoad <- function(libname, pkgname) {
  if(nchar(Sys.getenv("BLIZZARD_AUTH_TOKEN")) > 1) {
  blizz_auth(refresh = TRUE)
  }
}

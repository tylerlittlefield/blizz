fetch_creds <- function() {
  id <- Sys.getenv("BLIZZARD_CLIENT_ID")
  secret <- Sys.getenv("BLIZZARD_CLIENT_SECRET")
  token <- Sys.getenv("BLIZZARD_AUTH_TOKEN")

  list(id = id, secret = secret, token = token)
}

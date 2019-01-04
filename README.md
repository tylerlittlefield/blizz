
<!-- README.md is generated from README.Rmd. Please edit that file -->

# blizz

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/tyluRp/blizz.svg?branch=master)](https://travis-ci.org/tyluRp/blizz)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/tyluRp/blizz?branch=master&svg=true)](https://ci.appveyor.com/project/tyluRp/blizz)
[![Codecov test
coverage](https://codecov.io/gh/tyluRp/blizz/branch/master/graph/badge.svg)](https://codecov.io/gh/tyluRp/blizz?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

Minimalistic client to access [Blizzards
API](https://develop.battle.net/).

## Installation

You can install from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tyluRp/blizz")
```

## Additional Setup

Installing the package alone isn’t enough to get started. You will need
to create a developer account at Blizzards new [dev
portal](https://develop.battle.net/). Once you’ve created an account, a
client needs to be made. Creating a client will produce a **Client ID**
and **Client Secret**. With these credentials you can simply run:

``` r
blizz_creds("your_client_id", "your_client_secret")
```

This will do a couple things:

1.  Store the Client ID and Secret in the `.Renviron` file. If you don’t
    have one, it’ll create one for you.
2.  Run a system command to produce an **authentication token** which is
    then stored in `.Renviron`.

After this, you’re all set.

However, I realize that allowing some stranger (i.e. me) to modify your
`.Renviron` is scary\! If you want to avoid using `blizz_creds()`, you
can obtain the client ID, secret, and token by following the
[docs](https://develop.battle.net/documentation/guides/getting-started).
Then edit the `.Renviron` file manually and supply the credentials like
so:

``` r
BLIZZARD_CLIENT_ID='your ID'
BLIZZARD_CLIENT_SECRET='your secret'
BLIZZARD_AUTH_TOKEN='your token'
```

Note that Blizzards authentication tokens expire after 24 hours. To
refresh the authentication token run the following:

``` r
blizz_creds(refresh = TRUE)
```

This will remove the expired token from your `.Renviron` and add the
fresh token to it. Additionally it will run
`Sys.setenv("your_new_token")` to avoid having to restart the R session.

## Example

Use the `blizz()` function to access all API endpoints. Note that the
leading slash must be included as well:

``` r
library(blizz)
library(dplyr, warn.conflicts = FALSE)
library(tidyr)
library(janitor)

# Here's one example of extracting the StarCraft II grandmaster ladder
blizz("/sc2/ladder/grandmaster/1?") %>% 
  .[["ladderTeams"]] %>% 
  unnest() %>% 
  as_tibble() %>% 
  clean_names("snake") %>% 
  select(display_name, clan_tag, favorite_race, mmr, wins, losses, points)
#> Attempting to pull data from:
#> https://us.api.blizzard.com/sc2/ladder/grandmaster/1?access_token=[*]
#> # A tibble: 197 x 7
#>    display_name clan_tag favorite_race   mmr  wins losses points
#>    <chr>        <chr>    <chr>         <int> <int>  <int>  <int>
#>  1 Chammy       Scyth    zerg           6607   108     27   2375
#>  2 PartinG      Cl0wn    protoss        6568    42     12    976
#>  3 PartinG      Dicboy   protoss        6564    38      8   1166
#>  4 NoWCSForU    N0SCAM   protoss        6390   202     44   2266
#>  5 scarlett     N0SCAM   protoss        6389    59     14   1494
#>  6 puCK         ROOT     protoss        6257    61     21   2012
#>  7 LiquidTLO    <NA>     zerg           6242    76     26   1772
#>  8 Nice         <NA>     protoss        6204     1      0     73
#>  9 DisK         PSISTM   protoss        6174    73     25   2006
#> 10 JonSnow      PSISTM   zerg           6150    64     36   1829
#> # ... with 187 more rows
```

When making a request you pretty much need to copy and paste everything
in-between the request URL and the access token. In the example above,
we needed `/sc2/ladder/grandmaster/1?`.

Additionally, we can print the response as JSON thanks to the
[`jsonlite`](https://github.com/jeroen/jsonlite) package:

``` r
blizz("/d3/data/act/1?locale=en_US&", json = TRUE)
#> Attempting to pull data from:
#> https://us.api.blizzard.com/d3/data/act/1?locale=en_US&access_token=[*]
#> {
#>   "slug": ["act-i"],
#>   "number": [1],
#>   "name": ["Act I"],
#>   "quests": [
#>     {
#>       "id": 87700,
#>       "name": "The Fallen Star",
#>       "slug": "the-fallen-star"
#>     },
#>     {
#>       "id": 72095,
#>       "name": "The Legacy of Cain",
#>       "slug": "the-legacy-of-cain"
#>     },
#>     {
#>       "id": 72221,
#>       "name": "A Shattered Crown",
#>       "slug": "a-shattered-crown"
#>     },
#>     {
#>       "id": 72061,
#>       "name": "Reign of the Black King",
#>       "slug": "reign-of-the-black-king"
#>     },
#>     {
#>       "id": 117779,
#>       "name": "Sword of the Stranger",
#>       "slug": "sword-of-the-stranger"
#>     },
#>     {
#>       "id": 72738,
#>       "name": "The Broken Blade",
#>       "slug": "the-broken-blade"
#>     },
#>     {
#>       "id": 73236,
#>       "name": "The Doom in Wortham",
#>       "slug": "the-doom-in-wortham"
#>     },
#>     {
#>       "id": 72546,
#>       "name": "Trailing the Coven",
#>       "slug": "trailing-the-coven"
#>     },
#>     {
#>       "id": 72801,
#>       "name": "The Imprisoned Angel",
#>       "slug": "the-imprisoned-angel"
#>     },
#>     {
#>       "id": 136656,
#>       "name": "Return to New Tristram",
#>       "slug": "return-to-new-tristram"
#>     }
#>   ]
#> }
```

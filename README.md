
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

<img src="man/figures/Nagrand_Concept_Art_Peter_Lee_1.jpg" width="100%" />

Minimalistic client to access [Blizzards
API](https://develop.battle.net/).

## Installation

You can install from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tyluRp/blizz")
```

## Additional Setup

You need to create a developer account at Blizzard’s [**dev
portal**](https://develop.battle.net/). Once you’ve created an account,
a client needs to be made. Creating a client will produce a **Client
ID** and **Client Secret**. With these credentials you can run:

``` r
# replace ID/SECRET with your own
blizz_auth("ID", "SECRET")
```

After this, you’re all set.

If you want to avoid using `blizz_auth()`, you can obtain the Client ID,
Secret, and Token by following the
[docs](https://develop.battle.net/documentation/guides/getting-started).
Then edit the `.Renviron` file manually and supply the credentials like
so:

``` r
BLIZZARD_CLIENT_ID='your ID'
BLIZZARD_CLIENT_SECRET='your secret'
BLIZZARD_AUTH_TOKEN='your token'
```

Note: Blizzard’s authentication tokens expire after 24 hours. To avoid
having to refresh the token everyday, `blizz` runs the following command
everytime the library is loaded:

``` r
blizz_auth(refresh = TRUE)
```

This will remove the expired token from your `.Renviron` and add the
fresh token to it. More info on how to get started can be found in
[**this**](https://blizz.netlify.com/articles/auth.html) vignette.

## Example

Use the `blizz()` function to access all API endpoints. Note that the
leading slash must be included as well:

``` r
library(blizz)

blizz("/d3/data/act/1")
#> ✔ Request: https://us.api.blizzard.com/d3/data/act/1
#> ✔ Status: 200
#> ✔ Content-Type: application/json;charset=UTF-8
#> $slug
#> [1] "act-i"
#> 
#> $number
#> [1] 1
#> 
#> $name
#> [1] "Act I"
#> 
#> $quests
#>        id                    name                    slug
#> 1   87700         The Fallen Star         the-fallen-star
#> 2   72095      The Legacy of Cain      the-legacy-of-cain
#> 3   72221       A Shattered Crown       a-shattered-crown
#> 4   72061 Reign of the Black King reign-of-the-black-king
#> 5  117779   Sword of the Stranger   sword-of-the-stranger
#> 6   72738        The Broken Blade        the-broken-blade
#> 7   73236     The Doom in Wortham     the-doom-in-wortham
#> 8   72546      Trailing the Coven      trailing-the-coven
#> 9   72801    The Imprisoned Angel    the-imprisoned-angel
#> 10 136656  Return to New Tristram  return-to-new-tristram
```

Additionally, we can print the response as JSON thanks to the
[`jsonlite`](https://github.com/jeroen/jsonlite) package:

``` r
blizz("/d3/data/act/1", json = TRUE)
#> ✔ Request: https://us.api.blizzard.com/d3/data/act/1
#> ✔ Status: 200
#> ✔ Content-Type: application/json;charset=UTF-8
#> {
#>   "slug": ["act-i"],
#>   "number": [1],
#>   "name": ["Act I"],
#>   "quests": [
#>     {
#>       "id": [87700],
#>       "name": ["The Fallen Star"],
#>       "slug": ["the-fallen-star"]
#>     },
#>     {
#>       "id": [72095],
#>       "name": ["The Legacy of Cain"],
#>       "slug": ["the-legacy-of-cain"]
#>     },
#>     {
#>       "id": [72221],
#>       "name": ["A Shattered Crown"],
#>       "slug": ["a-shattered-crown"]
#>     },
#>     {
#>       "id": [72061],
#>       "name": ["Reign of the Black King"],
#>       "slug": ["reign-of-the-black-king"]
#>     },
#>     {
#>       "id": [117779],
#>       "name": ["Sword of the Stranger"],
#>       "slug": ["sword-of-the-stranger"]
#>     },
#>     {
#>       "id": [72738],
#>       "name": ["The Broken Blade"],
#>       "slug": ["the-broken-blade"]
#>     },
#>     {
#>       "id": [73236],
#>       "name": ["The Doom in Wortham"],
#>       "slug": ["the-doom-in-wortham"]
#>     },
#>     {
#>       "id": [72546],
#>       "name": ["Trailing the Coven"],
#>       "slug": ["trailing-the-coven"]
#>     },
#>     {
#>       "id": [72801],
#>       "name": ["The Imprisoned Angel"],
#>       "slug": ["the-imprisoned-angel"]
#>     },
#>     {
#>       "id": [136656],
#>       "name": ["Return to New Tristram"],
#>       "slug": ["return-to-new-tristram"]
#>     }
#>   ]
#> }
```

## Acknowledgements

  - [Blizzard](https://develop.battle.net/): API
  - [Peter Lee](https://www.artstation.com/peterconcept): Nagrand
    concept art
  - [Jeroen Ooms](https://github.com/jeroen): `jsonlite` package
  - [r-lib](https://github.com/r-lib): `httr` package

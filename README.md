
<!-- README.md is generated from README.Rmd. Please edit that file -->

# blizz

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/tyluRp/blizz.svg?branch=master)](https://travis-ci.org/tyluRp/blizz)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/tyluRp/blizz?branch=master&svg=true)](https://ci.appveyor.com/project/tyluRp/blizz)
[![Codecov test
coverage](https://codecov.io/gh/tyluRp/blizz/branch/master/graph/badge.svg)](https://codecov.io/gh/tyluRp/blizz?branch=master)
[![LICENSE](https://img.shields.io/github/license/tylurp/blizz.svg)](https://github.com/tyluRp/blizz)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

Minimalistic client to access [Blizzards
API](https://develop.battle.net/)

## Installation

You can install from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tyluRp/blizz")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(blizz)

act1 <- blizz("d3/data/act/1")

act1[["quests"]]
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

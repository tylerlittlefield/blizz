#' Blizzard API Regions
#'
#' A dataset containing all available regions, hosts, and locales. API data is
#' limited to specific regions. For example, US APIs accessed through
#' us.battle.net only contain data from US battlegroups and realms. Locale
#' support is limited to locations supported on Blizzard community game sites.
#' Game information is different from region to region. For example, a user
#' that has both US and EU WoW accounts has different characters, achievements,
#' and other information in each region. Likewise, a D3 user who has a single
#' license for D3 on their account has a different character list for each
#' region in which the game operates.
#'
#' @format A data frame with 13 rows and 3 variables:
#' \describe{
#'   \item{region}{The region: us, eu, kr, tw, or cn}
#'   \item{host}{The host for example, https://us.api.blizzard.com/}
#'   \item{locale}{The localization, see the \code{regions} dataset}
#' }
#' @source \url{https://develop.battle.net/documentation/guides/regionality-partitions-and-localization}
"regions"

#' Diablo 3 Acts
#'
#' A dataset containing all available Acts in the Diablo 3 storyline.
#'
#' @format A data frame with 39 rows and 6 variables:
#' \describe{
#'   \item{id}{Act ID: \emph{87700, 72095, ...}}
#'   \item{act}{Act: \emph{Act I, Act II, ...}}
#'   \item{act_slug}{Act Slug: \emph{act-ii, act-ii, ...}}
#'   \item{number}{Act Number: \emph{1, 2, ...}}
#'   \item{name}{Act Name: \emph{The Fallen Star, The Legacy of Cain, ...}}
#'   \item{name_slug}{Act Name Slug: \emph{the-fallen-star, the-legacy-of-cain, ...}}
#' }
#' @source \url{https://develop.battle.net/documentation/api-reference}
"d3acts"

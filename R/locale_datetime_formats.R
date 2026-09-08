#' Determine locale-aware date and date-time formats
#'
#' Returns an ordered set of `strptime()`-style format strings, used as the
#' default value of `accepted_datetime_formats` in [stabilize_date()],
#' [stabilize_dttm()], and their siblings. Character input is tried against
#' each format in turn, in order, until one of them parses every element (see
#' those functions for details).
#'
#' @param locale_time (`character(1)`) The current `LC_TIME` locale, as
#'   returned by `Sys.getlocale("LC_TIME")`. Used only to guess whether the
#'   locale's conventional date order is month-first (as in the United
#'   States) or day-first (most other locales); this is a coarse heuristic
#'   based on the locale string, not a full locale-aware calendar
#'   implementation.
#' @returns A `character()` vector of `strptime()`-style format strings,
#'   always starting with `"%Y-%m-%dT%H:%M:%S"`, `"%Y-%m-%d %H:%M:%S"`, and
#'   `"%Y-%m-%d"` (in that order), followed by the locale's conventional
#'   day/month order with `"/"` and then `"-"` separators (each listed with,
#'   then without, a `" %H:%M:%S"` suffix).
#' @family date functions
#' @family datetime functions
#' @export
#' @examples
#' locale_datetime_formats("en_US.UTF-8")
#' locale_datetime_formats("en_GB.UTF-8")
locale_datetime_formats <- function(locale_time = Sys.getlocale("LC_TIME")) {
  locale_time <- to_chr_scalar(locale_time, x_arg = "locale_time")
  date_order <- .locale_date_order(locale_time)
  date_formats <- unique(c(
    "%Y-%m-%d",
    paste0("%", date_order[[1]], "/%", date_order[[2]], "/%Y"),
    paste0("%", date_order[[1]], "-%", date_order[[2]], "-%Y")
  ))
  unlist(lapply(date_formats, .datetime_format_variants), use.names = FALSE)
}

#' Expand a date format into date and date-time variants
#'
#' @param date_format (`character(1)`) A `strptime()`-style date format.
#' @returns A `character()` vector: `date_format` with a `"T%H:%M:%S"` suffix
#'   (only when `date_format` is `"%Y-%m-%d"`), with a `" %H:%M:%S"` suffix,
#'   and bare, in that order.
#' @keywords internal
.datetime_format_variants <- function(date_format) {
  variants <- character(0)
  if (identical(date_format, "%Y-%m-%d")) {
    variants <- c(variants, paste0(date_format, "T%H:%M:%S"))
  }
  c(variants, paste0(date_format, " %H:%M:%S"), date_format)
}

#' Guess a locale's conventional day/month order
#'
#' @inheritParams locale_datetime_formats
#' @returns A length-2 character vector, either `c("m", "d")` (month before
#'   day) or `c("d", "m")` (day before month).
#' @keywords internal
.locale_date_order <- function(locale_time) {
  # A coarse heuristic: month-first order is largely a United States
  # convention (with a handful of smaller exceptions this package does not
  # attempt to enumerate). Everything else defaults to day-first.
  is_month_first <- grepl(
    "(^|[^[:alnum:]])(US|USA)([^[:alnum:]]|$)|united[ _]?states",
    locale_time,
    ignore.case = TRUE
  )
  if (isTRUE(is_month_first)) {
    c("m", "d")
  } else {
    c("d", "m")
  }
}

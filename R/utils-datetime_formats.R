#' Convert a strptime()-style format string to a shape-checking regex
#'
#' Used to verify that a character vector's *shape* matches a candidate
#' format before handing it to [as.Date()], since that function silently
#' ignores unmatched trailing characters rather than failing.
#'
#' @param fmt (`character(1)`) A `strptime()`-style format string built from
#'   `%Y`, `%m`, `%d`, `%H`, `%M`, and `%S` specifiers and literal separators.
#' @returns A `character(1)` regular expression, anchored with `^` and `$`,
#'   that matches strings shaped like `fmt`.
#' @keywords internal
.format_to_regex <- function(fmt) {
  pattern <- gsub("%Y", "\\d{4}", fmt, fixed = TRUE)
  # Each specifier is substituted separately with fixed = TRUE; a single
  # gsub() with a specifier-matching regex would need the replacement to go
  # through non-fixed backslash processing, which mangles "\\d".
  for (specifier in c("%m", "%d", "%H", "%M", "%S")) {
    pattern <- gsub(specifier, "\\d{2}", pattern, fixed = TRUE)
  }
  paste0("^", pattern, "$")
}

#' Convert a strptime()-style format string to a field-capturing regex
#'
#' Unlike [.format_to_regex()], this keeps track of which calendar field each
#' capture group corresponds to, so the captured digits can be reassembled
#' regardless of the order in which the format places them (for example
#' `"%m/%d/%Y"` vs. `"%Y-%m-%d"`).
#'
#' @inheritParams .format_to_regex
#' @returns A list with:
#'   - `regex`: the unanchored regex body (not yet wrapped in `^`/`$`).
#'   - `fields`: a character vector naming the calendar field (one of `"Y"`,
#'   `"m"`, `"d"`, `"H"`, `"M"`, or `"S"`) captured by each group, in the
#'   order the groups appear in `regex`.
#' @keywords internal
.format_to_capture_regex <- function(fmt) {
  tokens <- regmatches(fmt, gregexpr("%[YmdHMS]|[^%]+", fmt))[[1]]
  group_patterns <- c(
    Y = "(\\d{4})",
    m = "(\\d{2})",
    d = "(\\d{2})",
    H = "(\\d{2})",
    M = "(\\d{2})",
    S = "(\\d{2})"
  )
  is_specifier <- grepl("^%[YmdHMS]$", tokens)
  fields <- substr(tokens[is_specifier], 2, 2)
  regex_parts <- tokens
  regex_parts[is_specifier] <- group_patterns[fields]
  list(regex = paste(regex_parts, collapse = ""), fields = fields)
}

#' Try candidate date formats against a character vector
#'
#' Tries each format in `formats`, in order, and returns the first one that
#' parses every non-`NA` element of `x` without failure. If none succeed for
#' every element, returns the result of the first format tried, so that error
#' messages describe a concrete (if incomplete) failure rather than an
#' arbitrary one.
#'
#' @param x `(character)` The vector to parse.
#' @param formats `(character)` Candidate `strptime()`-style format strings,
#'   tried in order.
#' @returns A list with `parsed` (a [base::Date] vector) and `failures` (a
#'   logical vector, the same length as `x`, `TRUE` where an element could not
#'   be parsed with the chosen format).
#' @keywords internal
.try_date_formats <- function(x, formats) {
  not_na <- !is.na(x)
  first <- NULL
  for (fmt in formats) {
    regex <- .format_to_regex(fmt)
    well_shaped <- grepl(regex, x)
    parsed <- as.Date(x, format = fmt)
    failures <- not_na & (!well_shaped | is.na(parsed))
    result <- list(parsed = parsed, failures = failures)
    if (is.null(first)) {
      first <- result
    }
    if (!any(failures)) {
      return(result)
    }
  }
  first
}

#' Try candidate date-time formats against a character vector
#'
#' Like [.try_date_formats()], but for date-time strings, with an optional
#' trailing UTC offset (`"Z"` or a numeric offset such as `"+05:00"`).
#' Elements with an offset are converted using that offset; elements without
#' one are treated as wall-clock time in `tz`.
#'
#' @inheritParams .try_date_formats
#' @param tz `(character(1))` The time zone to assume for date-times with no
#'   explicit offset, and to attach to the result.
#' @returns A list with `parsed` (a [base::POSIXct] vector, in `tz`) and
#'   `failures` (a logical vector, the same length as `x`).
#' @keywords internal
.try_dttm_formats <- function(x, formats, tz) {
  not_na <- !is.na(x)
  offset_group <- "(Z|z|[+-]\\d{2}:\\d{2})?"
  first <- NULL
  for (fmt in formats) {
    parts <- .format_to_capture_regex(fmt)
    pattern <- paste0("^", parts$regex, offset_group, "$")
    matches <- regmatches(x, regexec(pattern, x))
    well_shaped <- lengths(matches) > 0L
    parsed <- as.POSIXct(rep(NA_character_, length(x)), tz = tz)
    to_parse <- not_na & well_shaped
    if (any(to_parse)) {
      parsed[to_parse] <- .parse_dttm_matches(
        matches[to_parse],
        parts$fields,
        tz
      )
    }
    failures <- not_na & (!well_shaped | is.na(parsed))
    result <- list(parsed = parsed, failures = failures)
    if (is.null(first)) {
      first <- result
    }
    if (!any(failures)) {
      return(result)
    }
  }
  first
}

#' Parse capture-group matches from `.try_dttm_formats()` into instants
#'
#' @param matches `(list)` Regex captures from [regmatches()]: the full
#'   match, one group per calendar field named in `fields`, and a trailing
#'   UTC-offset group (possibly `""` when absent).
#' @param fields `(character)` Which calendar field (`"Y"`, `"m"`, `"d"`,
#'   `"H"`, `"M"`, or `"S"`) each non-offset capture group corresponds to, in
#'   the order the groups appear.
#' @param tz `(character(1))` The time zone to assume for elements with no
#'   explicit offset.
#' @returns A [base::POSIXct] vector (in `tz`), the same length as `matches`,
#'   with `NA` at any position that describes an impossible date-time (such
#'   as `"2024-02-30"`).
#' @keywords internal
.parse_dttm_matches <- function(matches, fields, tz) {
  parts <- do.call(rbind, matches)
  n_fields <- length(fields)
  get_field <- function(letter, default) {
    idx <- which(fields == letter)
    if (length(idx) == 0L) {
      return(rep(default, nrow(parts)))
    }
    as.integer(parts[, idx + 1L])
  }
  # ISOdatetime() (unlike as.POSIXct(format = ...)) returns NA for
  # out-of-range components instead of rolling over, so it doubles as the
  # calendar validity check.
  naive <- ISOdatetime(
    year = get_field("Y", 1970L),
    month = get_field("m", 1L),
    day = get_field("d", 1L),
    hour = get_field("H", 0L),
    min = get_field("M", 0L),
    sec = get_field("S", 0L),
    tz = "UTC"
  )
  offset_chr <- parts[, n_fields + 2L]
  has_offset <- offset_chr != ""
  offset_seconds <- ifelse(has_offset, .parse_dttm_offset(offset_chr), 0)
  from_offset <- as.numeric(naive) - offset_seconds
  # Elements without an offset are wall-clock time in `tz`; reinterpret the
  # same digits (currently tagged UTC by ISOdatetime()) as local time in
  # `tz` instead.
  from_tz <- as.numeric(as.POSIXct(
    format(naive, "%Y-%m-%d %H:%M:%S", tz = "UTC"),
    tz = tz
  ))
  result_seconds <- ifelse(has_offset, from_offset, from_tz)
  as.POSIXct(result_seconds, origin = "1970-01-01", tz = tz)
}

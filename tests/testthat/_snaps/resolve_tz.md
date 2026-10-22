# resolve_tz() errors when the time zone can't be determined (#370)

    Code
      resolve_tz(default = NA_character_)
    Condition <stbl-error-bad_tz>
      Error:
      ! `default` must be "" or a value from `OlsonNames()`.
      x NA is not a recognized time zone.

# resolve_tz() errors for an unrecognized tzone on x (#370)

    Code
      resolve_tz(x)
    Condition <stbl-error-bad_tz>
      Error:
      ! `tz` must be "" or a value from `OlsonNames()`.
      x "this is not a timezone" is not a recognized time zone.

# .check_tz() rejects an unrecognized local time zone (#370)

    Code
      .check_tz("")
    Condition <stbl-error-bad_tz>
      Error:
      ! `tz` must be a recognized time zone.
      x Can't determine the local time zone ("Not/A_Zone" is not recognized).
      i Supply a value from `OlsonNames()` as `tz`.


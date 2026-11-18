test_that(".normalize_patterns() accepts NULL and empty lists (#292)", {
  expect_identical(.normalize_patterns(NULL, ".patterns", NULL), list())
  expect_identical(.normalize_patterns(list(), ".patterns", NULL), list())
  patterns <- list("^a" = stabilize_int, "^a" = to_chr)
  expect_identical(.normalize_patterns(patterns, ".patterns", NULL), patterns)
})

test_that(".normalize_patterns() errors for invalid patterns (#292)", {
  call <- rlang::current_env()
  expect_pkg_error_snapshot(
    .normalize_patterns("a", ".patterns", call),
    "stbl",
    "bad_patterns",
    "not_list"
  )
  expect_pkg_error_snapshot(
    .normalize_patterns(list(stabilize_int), ".patterns", call),
    "stbl",
    "bad_patterns",
    "missing_name"
  )
  expect_pkg_error_snapshot(
    .normalize_patterns(
      list("[" = stabilize_int, "(" = stabilize_int),
      ".patterns",
      call
    ),
    "stbl",
    "bad_patterns",
    "invalid_regex"
  )
  expect_pkg_error_snapshot(
    .normalize_patterns(
      list("a" = 1, "b" = stabilize_int),
      ".patterns",
      call
    ),
    "stbl",
    "bad_patterns",
    "invalid_spec"
  )
})

test_that(".match_patterns() matches unanchored and skips empty names (#292)", {
  patterns <- list("^S_" = stabilize_int, "b" = stabilize_int)
  expect_identical(
    .match_patterns(c("S_a", "xbx", "", "z"), patterns),
    matrix(
      c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE),
      nrow = 4
    )
  )
  expect_identical(
    .match_patterns(character(), patterns),
    matrix(logical(), nrow = 0, ncol = 2)
  )
})

test_that(".match_patterns() supports ECMAScript-style syntax (#292)", {
  skip_if_not_installed("stringi")
  patterns <- list(
    "^(?!x_)[a-z]+$" = stabilize_int,
    "^\\p{L}+$" = stabilize_int,
    "(?<=a)b" = stabilize_int
  )
  expect_identical(
    unname(.match_patterns(c("abc", "x_a", "\u00e9"), patterns)[, 1:3]),
    matrix(
      c(TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE),
      nrow = 3
    )
  )
})

test_that(".names_matching_patterns() returns names matching any pattern (#292)", {
  patterns <- list("^S_" = stabilize_int, "n$" = stabilize_int)
  expect_identical(
    .names_matching_patterns(c("S_a", "b", "I_n"), patterns),
    c("S_a", "I_n")
  )
  expect_identical(.names_matching_patterns(character(), patterns), character())
  expect_identical(.names_matching_patterns("a", list()), character())
})

test_that(".validate_pattern_elements() applies and reconciles specs (#292)", {
  x <- list(a_b = 1, c = 2, 3)
  nms <- rlang::names2(x)
  patterns <- list("a" = stabilize_int, "b" = specify_dbl())
  matches <- .match_patterns(nms, patterns)
  expect_identical(
    .validate_pattern_elements(
      x,
      nms,
      list(),
      patterns,
      matches,
      "x",
      rlang::current_env()
    ),
    list(a_b = 1L, c = 2, 3)
  )
  expect_identical(
    .validate_pattern_elements(
      x,
      nms,
      list(),
      rev(patterns),
      .match_patterns(nms, rev(patterns)),
      "x",
      rlang::current_env()
    ),
    list(a_b = 1L, c = 2, 3)
  )
})

test_that(".validate_pattern_elements() keeps NULL results and applies exact specs (#292)", {
  x <- list(a = 1, a = 2)
  nms <- names(x)
  patterns <- list("^a" = function(x, ...) NULL)
  expect_identical(
    .validate_pattern_elements(
      x,
      nms,
      list(),
      patterns,
      .match_patterns(nms, patterns),
      "x",
      rlang::current_env()
    ),
    list(a = NULL, a = NULL)
  )
  patterns <- list("^a" = stabilize_int)
  expect_pkg_error_classes(
    .validate_pattern_elements(
      list(a = 1.5),
      "a",
      list(a = specify_dbl()),
      patterns,
      .match_patterns("a", patterns),
      "x",
      rlang::current_env()
    ),
    "stbl",
    "cant_stabilize_patterns"
  )
})

test_that(".validate_pattern_elements() reports all failures together (#292)", {
  x <- list(S_a = "x", S_b = 1L, S_c = "z", d = "no")
  nms <- names(x)
  patterns <- list("^S_" = specify_int_scalar())
  matches <- .match_patterns(nms, patterns)
  expect_pkg_error_snapshot(
    .validate_pattern_elements(
      x,
      nms,
      list(),
      patterns,
      matches,
      "x",
      rlang::current_env()
    ),
    "stbl",
    "cant_stabilize_patterns"
  )
  err <- rlang::catch_cnd(
    .validate_pattern_elements(
      x,
      nms,
      list(),
      patterns,
      matches,
      "x",
      rlang::current_env()
    ),
    classes = "error"
  )
  expect_identical(err$locations, c(1L, 3L))
})

test_that(".validate_pattern_elements() errors for specs that disagree (#292)", {
  x <- list(a_b = 1L)
  patterns <- list("a" = specify_dbl(), "b" = function(x, ...) 2L)
  expect_pkg_error_snapshot(
    .validate_pattern_elements(
      x,
      "a_b",
      list(),
      patterns,
      .match_patterns("a_b", patterns),
      "x",
      rlang::current_env()
    ),
    "stbl",
    "cant_stabilize_patterns"
  )
})

# docs mention condition classes ---------------------------------------------- ----

test_that("stabilize docs list condition classes (#308)", {
  checks <- list(
    stabilize_chr = c("<stbl-error-bad_null>", "<stbl-error-must>"),
    stabilize_dbl = c(
      "<stbl-error-incompatible_type>",
      "<stbl-error-outside_range>"
    ),
    stabilize_df = c(
      "<stbl-error-missing_cols>",
      "<stbl-error-duplicate_names>"
    ),
    stabilize_lst = c("<stbl-error-bad_unnamed>", "<stbl-error-unnamed_spec>"),
    stabilize_any_of = c(
      "<stbl-error-empty_specs>",
      "<stbl-error-cant_stabilize_any_of>"
    )
  )

  for (topic in names(checks)) {
    rd_path <- test_path("../../man", paste0(topic, ".Rd"))
    expect_true(file.exists(rd_path), label = paste0(topic, ".Rd exists"))

    rd_text <- paste(readLines(rd_path), collapse = "\n")
    expect_true(grepl("<stbl-error>", rd_text, fixed = TRUE))
    expect_true(grepl("<stbl-condition>", rd_text, fixed = TRUE))

    for (cls in checks[[topic]]) {
      expect_true(
        grepl(cls, rd_text, fixed = TRUE),
        label = paste0(topic, " documents ", cls)
      )
    }
  }
})

# assert_present() errors for NULL (#110, #299)

    Code
      (expect_pkg_error_classes(assert_present(NULL), "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `NULL` must not be <NULL>.


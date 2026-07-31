# stabilize_present() is deprecated in favor of assert_present() (#299)

    Code
      (expect_pkg_error_classes(stabilize_present("hello"), "stbl", "deprecated"))
    Output
      <error/stbl-error-deprecated>
      Error:
      ! `stabilize_present()` was renamed to `assert_present()`.
      i Please call `assert_present()` instead.


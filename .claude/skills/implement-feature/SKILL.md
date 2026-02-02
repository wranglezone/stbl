---
name: implement-feature
description: Guides implementation of new features or refactoring in R packages. Use when working on code changes, writing tests, or completing development tasks. Includes coding philosophy, testing patterns, and wrap-up checklist.
---

# Implement Feature

## Code philosophy

### Functional core, imperative shell

- **Functional core**: Pure, testable functions that accept data and return data with minimal side effects.
- **Imperative shell**: Orchestrates program flow, manages state, and calls the functional core (e.g., R6 methods, Shiny server logic).

### Key principles

**Single responsibility & small functions**
- Strive for small, single-purpose functions, aiming for around five lines of code if possible.
- Refactoring technique: Extract Method.

**Single level of abstraction**
- A function should either orchestrate calls to other functions OR perform a direct operation on data, but not mix these two levels.

**Simplify control flow**
- Prefer guard clauses and returning early over complex if/else structures.
- Refactoring technique: Combine if statements.

**Pure conditionals**
- The expression inside a conditional check should not cause side effects.
- Refactoring technique: Extract Method to separate the pure check from the impure action.

**Favor composition**
- Break down complex classes into smaller, specialized helper classes.
- Refactoring technique: Introduce Strategy Pattern.

**Use polymorphism over conditional dispatch**
- When encountering switch or if/else chains based on type, consider replacing with different classes sharing a common interface.
- Refactoring technique: Replace Type Code with Classes.

## Comments

Comments should be sparse. They explain *why*, not *what*. If code is hard to understand, abstract it into a well-named helper function rather than adding a comment.

**Bad comment:**
```r
# Paste together x and y.
paste(x, y)
```

**Good comment:**
```r
# This is defined outside of bootstrapLib() because registerThemeDependency()
# wants a non-anonymous function with a single argument.
```

**Do not remove:**
- Comments ending in `----` (RStudio document outline markers)
- `# nocov` comments (code coverage exclusions)—but suggest tests if you can think of them

## Testing

### General rules

- Every file in `R/` should have a corresponding `tests/testthat/test-*.R` file.
- All new code should have an accompanying test.
- Strive for 100% code coverage (necessary but not always sufficient).
- Keep tests minimal and focused.

### Test file structure

- Do not create objects outside of `test_that()` blocks. Each block should be executable on its own after `devtools::load_all()`.
- If you need shared setup, suggest creating a `tests/testthat/helper-*.R` file.
- Place new tests next to similar existing tests.

### Test style

- Strive for the simplest possible test that verifies the behavior.
- Avoid complex testing harnesses or mocks when a direct function call would suffice.
- Use `testthat::expect_snapshot()` for complex outputs like error messages or generated UI.

### TDD workflow

If the user specifies TDD, implement red-green-refactor:

1. **Red**: Write the simplest failing test (often just calling the function with no arguments). Run it to confirm it fails.
2. **Green**: Write the minimum code to pass the test.
3. **Refactor**: Clean up while keeping tests passing.

## Development wrap-up

When the user signals a task is nearing completion ("I think we're done", "anything else?", "time to push"), work through these steps:

1. Run tests for the specific feature
2. Check code coverage for the specific feature
3. Document the new feature or fix
4. Rebuild package documentation (`devtools::document()`)
5. Run all tests (`devtools::test()`)
6. Run R CMD check (`devtools::check()`)
7. Check overall code coverage
8. Verify DESCRIPTION and README.Rmd are still valid
9. Update NEWS.md
10. **Ask the user** before bumping the version number with `usethis::use_version("dev")`

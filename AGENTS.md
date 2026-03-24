# AGENTS.md

## Repository overview

**stbl** — Stabilize Function Arguments

A set of consistent, opinionated functions to quickly check
    function arguments, coerce them to the desired configuration, or
    deliver informative error messages when that is not possible.

https://stbl.wrangle.zone/, https://github.com/wranglezone/stbl

### Philosophy

stbl follows [Postel's Law](https://en.wikipedia.org/wiki/Robustness_principle): be liberal in what you accept (coerce when safe), conservative in what you return (ensure inputs have the expected classes and features). The goal is to fail fast with clear error messages before expensive operations, and to intelligently coerce compatible types (e.g., `"1"` to `1L`).

### Function families

| Family | Purpose | Speed | Example |
|--------|---------|-------|---------|
| `to_*()` | Fast type coercion | Fast | `to_int("1")` → `1L` |
| `is_*_ish()` | Check if coercible (single logical) | Fast | `is_int_ish(1.0)` → `TRUE` |
| `are_*_ish()` | Check if coercible (element-wise) | Fast | `are_int_ish(c(1, 1.5))` → `c(TRUE, FALSE)` |
| `stabilize_*()` | Comprehensive validation | Slower | `stabilize_int(x, min_value = 0)` |
| `specify_*()` | Create pre-configured validators | N/A | `specify_int(min_value = 0)` |

**Supported types (but future development may add more):** `chr`/`character`, `dbl`/`double`, `int`/`integer`, `lgl`/`logical`, `fct`/`factor`, `lst`/`list`

**Variants:**
- `*_scalar()` — optimized for length-1 values
- British spellings — `stabilise_*()` as synonyms

### Overall structure

The project follows standard R package conventions with these key directories:

stbl/
├── R/                          # R source code
│   ├── aaa-conditions.R        # Error helpers (.stbl_abort, .stop_cant_coerce, etc.)
│   ├── aaa-shared_params.R     # Shared roxygen parameter definitions
│   ├── stbl-package.R          # Auto-generated package docs
│   └── *.R                     # Function definitions, 1 file ~= 1 exported function
├── .github/
│   ├── ISSUE_TEMPLATE/         # GitHub issue templates
│   ├── skills/                 # Agent skill definitions
│   └── workflows/              # CI/CD configurations
├── tests/testthat/             # Test suite
├── man/                        # Generated documentation
├── AGENTS.md                   # Main agent setup file
├── DESCRIPTION                 # Package metadata
├── NAMESPACE                   # Auto-generated export information
├── NEWS.md                     # Changelog
└── Various config files        # .gitignore, codecov.yml, etc.

---

## Standard workflow

For any feature, fix, or refactor:

1. **Update packages**: `pak::pak()`
2. **Run tests** — confirm passing before changes: `devtools::test(reporter = "check")`. If any fail, stop and ask.
3. **Plan** — identify affected R files; check if new exports are needed.
4. **Test first** — write failing test, then implement: `devtools::test(filter = "name", reporter = "check")`.
5. **Implement** — minimal code to pass tests.
6. **Refactor** — clean up, keep tests green.
7. **Document** — document any new or changed exports.
8. **Verify**: `devtools::check(error_on = "warning")`. Resolve warnings, errors, and NOTEs.
9. **News** — add a bullet at the top of `NEWS.md` for user-facing changes.

---

## General

- R console: use `--quiet --vanilla`.
- Comments explain *why*, not *what*.
- Do not remove comments ending in `----` (RStudio document outline markers) or `# nocov` comments (code coverage exclusions).

### Namespacing

Use `pkg::fn()` for all external package functions, with these exceptions:
- Functions from the `base` package
- Functions from `stbl` itself (including explicitly imported functions)
- Functions from `testthat` (and related packages like `httptest2`, `shinytest2`) when writing tests
- Functions from `shiny` when working within a Shiny app

### `NEWS.md`

- Every user-facing change should be given a bullet in `NEWS.md`. Do not add bullets for small documentation changes or internal refactorings.
- Each bullet should briefly describe the change to the end user and mention the related issue in parentheses.
- A bullet can consist of multiple sentences but should not contain any new lines (i.e. DO NOT line wrap).
- If the change is related to a function, put the name of the function early in the bullet.
- Order bullets alphabetically by function name. Put all bullets that don't mention function names at the beginning.

### Writing

- Use sentence case for headings.
- Use US English.

### Proofreading

If the user asks you to proofread a file, act as an expert proofreader and editor with a deep understanding of clear, engaging, and well-structured writing.

Work paragraph by paragraph, always starting by making a TODO list that includes individual items for each top-level heading.

Fix spelling, grammar, and other minor problems without asking the user. Label any unclear, confusing, or ambiguous sentences with a FIXME comment.

Only report what you have changed.

## Skills

| Triggers | Path |
|----------|------|
| create GitHub issues | @.github/skills/create-issue/SKILL.md |
| document functions | @.github/skills/document/SKILL.md |
| from github | @.github/skills/github/SKILL.md |
| implement issue / work on #NNN | @.github/skills/implement-issue/SKILL.md |
| writing R functions / API design / error handling | @.github/skills/r-code/SKILL.md |
| search / rewrite code | @.github/skills/search-code/SKILL.md |
| writing or reviewing tests | @.github/skills/tdd-workflow/SKILL.md |

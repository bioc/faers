#' @importFrom cli qty
assert_inclusive <- function(x, y, allow_null = FALSE,
                             arg = caller_arg(x),
                             call = caller_env()) {
    if (!allow_null && is.null(x)) {
        cli::cli_abort("{.arg {arg}} cannot be {.code NULL}", call = call)
    }
    missing_items <- setdiff(x, y)
    if (length(missing_items)) {
        cli::cli_abort(c(
            x = "Invalid {qty(length(missing_items))} value{?s} in {.arg {arg}}: {.val {missing_items}}",
            i = "{.arg {arg}} must contain only values from {.val {y}}"
        ), call = call)
    }
}

assert_internet <- function(call = rlang::caller_env()) {
    if (!curl::has_internet()) {
        cli::cli_abort("No internet", call = call)
    }
}

#' Combine a list FAERS objects into one
#'
#' Packed all [FAERSascii] or [FAERSxml] objects into a single [FAERSascii] or
#' [FAERSxml] object
#' @param x A list of [FAERSxml] or [FAERSascii] objects.
#' @return A [FAERSxml] or [FAERSascii] object.
faers_combine <- function(x) {
    assert_(x, is.list, "a list")
    l <- length(x)
    if (length(x) == 0L) {
        cli::cli_abort("empty list")
    }
    type <- NULL
    for (allowed_type in c("ascii", "xml")) {
        if (all(isMatchedFAERS(x, allowed_type))) {
            type <- allowed_type
        }
    }
    if (is.null(type)) {
        cli::cli_abort(
            "All elements of {.arg x} must be of the same class, {.cls FAERSascii} or {.cls FAERSxml}"
        )
    }
    if (l == 1L) {
        return(x[[1L]])
    }
    cli::cli_alert("Combining all {l} FAERS Quarterly {type} Data files")
    switch(type,
        ascii = combine_faers_ascii(x),
        xml = combine_faers_xml(x)
    )
}

isMatchedFAERS <- function(x, type) {
    vapply(x, methods::is, logical(1L), class2 = paste0("FAERS", type))
}

combine_faers_ascii <- function(x) {
    out <- lapply(faers_ascii_file_fields, function(field) {
        data.table::rbindlist(
            lapply(x, function(obj) obj@data[[field]]),
            fill = TRUE, use.names = TRUE
        )
    })
    data.table::setattr(out, "names", faers_ascii_file_fields)
    methods::new("FAERSascii",
        data = out,
        year = unlist(lapply(x, function(obj) obj@year),
            use.names = FALSE
        ),
        quarter = unlist(lapply(x, function(obj) obj@quarter),
            use.names = FALSE
        ),
        deletedCases = list_flatten(
            lapply(x, function(obj) obj@deletedCases)
        )
    )
}

combine_faers_xml <- function(x) {
    methods::new("FAERSxml",
        data = data.table::rbindlist(
            lapply(x, function(obj) obj@data),
            fill = TRUE, use.names = TRUE
        ),
        year = unlist(lapply(x, function(obj) obj@year),
            use.names = FALSE
        ),
        quarter = unlist(lapply(x, function(obj) obj@quarter),
            use.names = FALSE
        )
    )
}
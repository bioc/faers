#' FAERS meta data
#'
#' @format A [data.table][data.table::data.table] reporting years, period,
#' quarter, and file urls and file sizes.
#' @source https://fis.fda.gov/extensions/FPD-QDE-FAERS/FPD-QDE-FAERS.html
meta <- faers_meta(force = TRUE)
saveRDS(
    list(data = meta, date = Sys.time()),
    "inst/extdata/faers_meta_data.rds",
    compress = "gzip"
)

#' Sampled 2004q1 and 2017q2 standardized data from FAERS
set.seed(2004L)
faers_sample(2004, "q1", dir = "inst/extdata")
set.seed(2007L)
faers_sample(2017, "q2", dir = "inst/extdata")
data <- faers(c(2004, 2017), c("q1", "q2"),
    dir = system.file("extdata", package = "faers"),
    compress_dir = tempdir()
)

#' Use meddra data to standardize FAERS data
#' Note: You must provide your meddra data (version: 26.1)
data <- faers_standardize(data, "~/Data/MedDRA/MedDRA_26_1_English") # nolint
saveRDS(data, "inst/extdata/standardized_data.rds")

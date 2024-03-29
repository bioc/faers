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
faers_sample(2004, "q1", dir = "inst/extdata")
faers_sample(2017, "q2", dir = "inst/extdata")
data <- faers(c(2004, 2017), c("q1", "q2"),
    dir = system.file("extdata", package = "faers"),
    compress_dir = tempdir()
)

#' Use meddra data to standardize FAERS data
#' Note: You must provide your meddra data (version: 26.1)
data <- faers_standardize(data, "~/Data/MedDRA/MedDRA_26_1_English") # nolint
saveRDS(data, "inst/extdata/standardized_data.rds")

#' Immune-related adverse events examined in ICI-associated adverse events
#' 
#' @references
#' - Chen Chen, Bin Wu, ChenYu Zhang, Ting Xu,Immune-related adverse events
#' associated with immune checkpoint inhibitors: An updated comprehensive
#' disproportionality analysis of the FDA adverse event reporting system,
#' International Immunopharmacology
#' @source
#' https://ars.els-cdn.com/content/image/1-s2.0-S156757692100134X-mmc1.docx
doc <- docxtractr::read_docx("inst/extdata/irAEs.docx")
irAEs <- docxtractr::docx_extract_tbl(doc, tbl_number = 2L)
irAEs <- tidyr::fill(
    dplyr::mutate(irAEs, Toxicity.types = dplyr::na_if(Toxicity.types, "")),
    Toxicity.types
)
data.table::setDT(irAEs)
irAEs <- unique(irAEs)
saveRDS(irAEs, "inst/extdata/irAEs.rds", compress = "bzip2")

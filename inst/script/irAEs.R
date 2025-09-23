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

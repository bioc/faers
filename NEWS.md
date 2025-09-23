# faers 1.5.1

* Fixed error in `handle_setopt(h, ...)` caused by unsupported option `multi_timeout`.
  Requires `curl` >= 6.0.0.

# faers 1.1.6

* fda_drugs() now directly use a fixed url to download the data

* faers_meta(internal = TRUE) will always use the cache data in the package. 

* Rename "gndr_cod" into "gender" for periods before 2014q2, and rename "sex" into "gender" for periods after or equal to 2014q2. 

* "sex" was added, which recoded any values other than "F" or "M" as `NA`.

# faers 1.1.4

* fix error when download failed

* meddra augment additional argument `primary_soc` to help save the full meddra data

# faers 0.99.0

* Initial Bioconductor submission.

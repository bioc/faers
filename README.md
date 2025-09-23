FAERS-Pharmacovigilance
================

- [Introduction](#introduction)
- [Installation](#installation)
- [Pharmacovigilance Analysis using
  FAERS](#pharmacovigilance-analysis-using-faers)
  - [Check metadata of FAERS](#check-metadata-of-faers)
  - [Download and Parse quarterly data files from
    FAERS](#download-and-parse-quarterly-data-files-from-faers)
  - [Standardize and De-duplication](#standardize-and-de-duplication)
  - [Pharmacovigilance analysis](#pharmacovigilance-analysis)
- [sessionInfo](#sessioninfo)

## Introduction

The FDA Adverse Event Reporting System (FAERS) stands as a database
dedicated to the monitoring of post-marketing drug safety and exercises
a notable influence over FDA safety guidance documents, including the
modification of drug labels. The quantity of cases stored within FAERS
has experienced an exponential surge due to the refinement of submission
techniques and adherence to standardized data protocols, making it a
pivotal asset for the realm of regulatory science. While FAERS has
predominantly focused on safety signal detection, the faers package acts
as the intermediary, seamlessly bridging the gap between the FAERS
database and the programming language R. Moreover, the faers package
provides a unified methodology for the seamless execution of
pharmacovigilance analysis, facilitating the integration of genetic
tools in R. With an ultimate ambition towards precision medicine, it
aspires to scrutinize the vast expanse of the human genome, revealing
drug pathways that may be intricately tied to potentially functional,
population-differentiated polymorphisms.

## Installation

To install from Bioconductor, use the following code:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}
BiocManager::install("faers")
```

You can install the development version of `faers` from
[GitHub](https://github.com/WangLabCSU/faers) with:

``` r
if (!requireNamespace("pak")) {
    install.packages("pak",
        repos = sprintf(
            "https://r-lib.github.io/p/pak/devel/%s/%s/%s",
            .Platform$pkgType, R.Version()$os, R.Version()$arch
        )
    )
}
pak::pkg_install("WangLabCSU/faers")
```

## Pharmacovigilance Analysis using FAERS

FAERS is a database for the spontaneous reporting of adverse events and
medication errors involving human drugs and therapeutic biological
products. This package accelarate the process of Pharmacovigilance
Analysis using FAERS.

``` r
library(faers)
```

### Check metadata of FAERS

This will return a data.table reporting years, period, quarter, and file
urls and file sizes. By default, this will use the cached file in
`tools::R_user_dir("faers", "cache")`. If it doesn’t exist, the internal
will parse metadata in
<https://fis.fda.gov/extensions/FPD-QDE-FAERS/FPD-QDE-FAERS.html>

``` r
faers_meta()
```

An metadata copy was associated with the package, just set
`internal = TRUE`.

``` r
faers_meta(internal = TRUE)
#> → Using internal FAERS metadata
#>   Snapshot time: 2024-09-19 00:18:06.64623
#>      year quarter             period
#>     <int>  <char>             <char>
#>  1:  2024      q2       April - June
#>  2:  2024      q1    January - March
#>  3:  2023      q4 October - December
#>  4:  2023      q3   July - September
#>  5:  2023      q2       April - June
#>  6:  2023      q1    January - March
#>  7:  2022      q4 October - December
#>  8:  2022      q3   July - September
#>  9:  2022      q2       April - June
#> 10:  2022      q1    January - March
#> 11:  2021      q4 October - December
#> 12:  2021      q3   July - September
#> 13:  2021      q2       April - June
#> 14:  2021      q1    January - March
#> 15:  2020      q4 October - December
#> 16:  2020      q3   July - September
#> 17:  2020      q2       April - June
#> 18:  2020      q1    January - March
#> 19:  2019      q4 October - December
#> 20:  2019      q3   July - September
#> 21:  2019      q2       April - June
#> 22:  2019      q1    January - March
#> 23:  2018      q4 October - December
#> 24:  2018      q3   July - September
#> 25:  2018      q2       April - June
#> 26:  2018      q1    January - March
#> 27:  2017      q4 October - December
#> 28:  2017      q3   July - September
#> 29:  2017      q2       April - June
#> 30:  2017      q1    January - March
#> 31:  2016      q4 October - December
#> 32:  2016      q3   July - September
#> 33:  2016      q2       April - June
#> 34:  2016      q1    January - March
#> 35:  2015      q4 October - December
#> 36:  2015      q3   July - September
#> 37:  2015      q2       April - June
#> 38:  2015      q1    January - March
#> 39:  2014      q4 October - December
#> 40:  2014      q3   July - September
#> 41:  2014      q2       April - June
#> 42:  2014      q1    January - March
#> 43:  2013      q4 October - December
#> 44:  2013      q3   July - September
#> 45:  2013      q2       April - June
#> 46:  2013      q1    January - March
#> 47:  2012      q4 October - December
#> 48:  2012      q3   July - September
#> 49:  2012      q2       April - June
#> 50:  2012      q1    January - March
#> 51:  2011      q4 October - December
#> 52:  2011      q3   July - September
#> 53:  2011      q2       April - June
#> 54:  2011      q1    January - March
#> 55:  2010      q4 October - December
#> 56:  2010      q3   July - September
#> 57:  2010      q2       April - June
#> 58:  2010      q1    January - March
#> 59:  2009      q4 October - December
#> 60:  2009      q3   July - September
#> 61:  2009      q2       April - June
#> 62:  2009      q1    January - March
#> 63:  2008      q4 October - December
#> 64:  2008      q3   July - September
#> 65:  2008      q2       April - June
#> 66:  2008      q1    January - March
#> 67:  2007      q4 October - December
#> 68:  2007      q3   July - September
#> 69:  2007      q2       April - June
#> 70:  2007      q1    January - March
#>                                                     ascii_urls ascii_file_size
#>                                                         <char>          <char>
#>  1: https://fis.fda.gov/content/Exports/faers_ascii_2024q2.zip          63.9MB
#>  2: https://fis.fda.gov/content/Exports/faers_ascii_2024q1.zip          63.1MB
#>  3: https://fis.fda.gov/content/Exports/faers_ascii_2023Q4.zip          69.1MB
#>  4: https://fis.fda.gov/content/Exports/faers_ascii_2023Q3.zip          60.1MB
#>  5: https://fis.fda.gov/content/Exports/faers_ascii_2023q2.zip          64.5MB
#>  6: https://fis.fda.gov/content/Exports/faers_ascii_2023q1.zip          64.3MB
#>  7: https://fis.fda.gov/content/Exports/faers_ascii_2022Q4.zip            69MB
#>  8: https://fis.fda.gov/content/Exports/faers_ascii_2022Q3.zip          63.2MB
#>  9: https://fis.fda.gov/content/Exports/faers_ascii_2022q2.zip            63MB
#> 10: https://fis.fda.gov/content/Exports/faers_ascii_2022q1.zip          64.7MB
#> 11: https://fis.fda.gov/content/Exports/faers_ascii_2021Q4.zip            59MB
#> 12: https://fis.fda.gov/content/Exports/faers_ascii_2021Q3.zip            70MB
#> 13: https://fis.fda.gov/content/Exports/faers_ascii_2021Q2.zip            66MB
#> 14: https://fis.fda.gov/content/Exports/faers_ascii_2021Q1.zip            69MB
#> 15: https://fis.fda.gov/content/Exports/faers_ascii_2020Q4.zip            71MB
#> 16: https://fis.fda.gov/content/Exports/faers_ascii_2020Q3.zip            64MB
#> 17: https://fis.fda.gov/content/Exports/faers_ascii_2020Q2.zip            66MB
#> 18: https://fis.fda.gov/content/Exports/faers_ascii_2020Q1.zip            65MB
#> 19: https://fis.fda.gov/content/Exports/faers_ascii_2019Q4.zip            60MB
#> 20: https://fis.fda.gov/content/Exports/faers_ascii_2019Q3.zip            62MB
#> 21: https://fis.fda.gov/content/Exports/faers_ascii_2019Q2.zip            62MB
#> 22: https://fis.fda.gov/content/Exports/faers_ascii_2019Q1.zip            56MB
#> 23: https://fis.fda.gov/content/Exports/faers_ascii_2018q4.zip            60MB
#> 24: https://fis.fda.gov/content/Exports/faers_ascii_2018q3.zip            60MB
#> 25: https://fis.fda.gov/content/Exports/faers_ascii_2018q2.zip            60MB
#> 26: https://fis.fda.gov/content/Exports/faers_ascii_2018q1.zip            52MB
#> 27: https://fis.fda.gov/content/Exports/faers_ascii_2017q4.zip            41MB
#> 28: https://fis.fda.gov/content/Exports/faers_ascii_2017q3.zip            48MB
#> 29: https://fis.fda.gov/content/Exports/faers_ascii_2017q2.zip            46MB
#> 30: https://fis.fda.gov/content/Exports/faers_ascii_2017q1.zip            48MB
#> 31: https://fis.fda.gov/content/Exports/faers_ascii_2016q4.zip            44MB
#> 32: https://fis.fda.gov/content/Exports/faers_ascii_2016q3.zip            46MB
#> 33: https://fis.fda.gov/content/Exports/faers_ascii_2016q2.zip            44MB
#> 34: https://fis.fda.gov/content/Exports/faers_ascii_2016q1.zip            46MB
#> 35: https://fis.fda.gov/content/Exports/faers_ascii_2015q4.zip            42MB
#> 36: https://fis.fda.gov/content/Exports/faers_ascii_2015q3.zip            47MB
#> 37: https://fis.fda.gov/content/Exports/faers_ascii_2015q2.zip            38MB
#> 38: https://fis.fda.gov/content/Exports/faers_ascii_2015q1.zip            39MB
#> 39: https://fis.fda.gov/content/Exports/faers_ascii_2014q4.zip            28MB
#> 40: https://fis.fda.gov/content/Exports/faers_ascii_2014q3.zip            28MB
#> 41: https://fis.fda.gov/content/Exports/faers_ascii_2014q2.zip            25MB
#> 42: https://fis.fda.gov/content/Exports/faers_ascii_2014q1.zip            30MB
#> 43: https://fis.fda.gov/content/Exports/faers_ascii_2013q4.zip            26MB
#> 44: https://fis.fda.gov/content/Exports/faers_ascii_2013q3.zip            22MB
#> 45: https://fis.fda.gov/content/Exports/faers_ascii_2013q2.zip            21MB
#> 46: https://fis.fda.gov/content/Exports/faers_ascii_2013q1.zip            25MB
#> 47: https://fis.fda.gov/content/Exports/faers_ascii_2012q4.zip            28MB
#> 48:  https://fis.fda.gov/content/Exports/aers_ascii_2012q3.zip            16MB
#> 49:  https://fis.fda.gov/content/Exports/aers_ascii_2012q2.zip            25MB
#> 50:  https://fis.fda.gov/content/Exports/aers_ascii_2012q1.zip            26MB
#> 51:  https://fis.fda.gov/content/Exports/aers_ascii_2011q4.zip            23MB
#> 52:  https://fis.fda.gov/content/Exports/aers_ascii_2011q3.zip            23MB
#> 53:  https://fis.fda.gov/content/Exports/aers_ascii_2011q2.zip            23MB
#> 54:  https://fis.fda.gov/content/Exports/aers_ascii_2011q1.zip            21MB
#> 55:  https://fis.fda.gov/content/Exports/aers_ascii_2010q4.zip            20MB
#> 56:  https://fis.fda.gov/content/Exports/aers_ascii_2010q3.zip            22MB
#> 57:  https://fis.fda.gov/content/Exports/aers_ascii_2010q2.zip            17MB
#> 58:  https://fis.fda.gov/content/Exports/aers_ascii_2010q1.zip            16MB
#> 59:  https://fis.fda.gov/content/Exports/aers_ascii_2009q4.zip            16MB
#> 60:  https://fis.fda.gov/content/Exports/aers_ascii_2009q3.zip            16MB
#> 61:  https://fis.fda.gov/content/Exports/aers_ascii_2009q2.zip            14MB
#> 62:  https://fis.fda.gov/content/Exports/aers_ascii_2009q1.zip            13MB
#> 63:  https://fis.fda.gov/content/Exports/aers_ascii_2008q4.zip            13MB
#> 64:  https://fis.fda.gov/content/Exports/aers_ascii_2008q3.zip            13MB
#> 65:  https://fis.fda.gov/content/Exports/aers_ascii_2008q2.zip            12MB
#> 66:  https://fis.fda.gov/content/Exports/aers_ascii_2008q1.zip            12MB
#> 67:  https://fis.fda.gov/content/Exports/aers_ascii_2007q4.zip            12MB
#> 68:  https://fis.fda.gov/content/Exports/aers_ascii_2007q3.zip           9.9MB
#> 69:  https://fis.fda.gov/content/Exports/aers_ascii_2007q2.zip           9.5MB
#> 70:  https://fis.fda.gov/content/Exports/aers_ascii_2007q1.zip           9.6MB
#>                                                     xml_urls xml_file_size
#>                                                       <char>        <char>
#>  1: https://fis.fda.gov/content/Exports/faers_xml_2024q2.zip         126MB
#>  2: https://fis.fda.gov/content/Exports/faers_xml_2024q1.zip         128MB
#>  3: https://fis.fda.gov/content/Exports/faers_xml_2023Q4.zip         140MB
#>  4: https://fis.fda.gov/content/Exports/faers_xml_2023Q3.zip         123MB
#>  5: https://fis.fda.gov/content/Exports/faers_xml_2023q2.zip         130MB
#>  6: https://fis.fda.gov/content/Exports/faers_xml_2023q1.zip         133MB
#>  7: https://fis.fda.gov/content/Exports/faers_xml_2022Q4.zip         144MB
#>  8: https://fis.fda.gov/content/Exports/faers_xml_2022Q3.zip         132MB
#>  9: https://fis.fda.gov/content/Exports/faers_xml_2022q2.zip         140MB
#> 10: https://fis.fda.gov/content/Exports/faers_xml_2022q1.zip         136MB
#> 11: https://fis.fda.gov/content/Exports/faers_xml_2021Q4.zip         123MB
#> 12: https://fis.fda.gov/content/Exports/faers_xml_2021Q3.zip         132MB
#> 13: https://fis.fda.gov/content/Exports/faers_xml_2021Q2.zip         123MB
#> 14: https://fis.fda.gov/content/Exports/faers_xml_2021Q1.zip         130MB
#> 15: https://fis.fda.gov/content/Exports/faers_xml_2020Q4.zip         131MB
#> 16: https://fis.fda.gov/content/Exports/faers_xml_2020Q3.zip         121MB
#> 17: https://fis.fda.gov/content/Exports/faers_xml_2020Q2.zip         123MB
#> 18: https://fis.fda.gov/content/Exports/faers_xml_2020Q1.zip         125MB
#> 19: https://fis.fda.gov/content/Exports/faers_xml_2019Q4.zip         113MB
#> 20: https://fis.fda.gov/content/Exports/faers_xml_2019Q3.zip         118MB
#> 21: https://fis.fda.gov/content/Exports/faers_xml_2019Q2.zip         118MB
#> 22: https://fis.fda.gov/content/Exports/faers_xml_2019Q1.zip         103MB
#> 23: https://fis.fda.gov/content/Exports/faers_xml_2018q4.zip         112MB
#> 24: https://fis.fda.gov/content/Exports/faers_xml_2018q3.zip         112MB
#> 25: https://fis.fda.gov/content/Exports/faers_xml_2018q2.zip         112MB
#> 26: https://fis.fda.gov/content/Exports/faers_xml_2018q1.zip          94MB
#> 27: https://fis.fda.gov/content/Exports/faers_xml_2017q4.zip          76MB
#> 28: https://fis.fda.gov/content/Exports/faers_xml_2017q3.zip          91MB
#> 29: https://fis.fda.gov/content/Exports/faers_xml_2017q2.zip          86MB
#> 30: https://fis.fda.gov/content/Exports/faers_xml_2017q1.zip          91MB
#> 31: https://fis.fda.gov/content/Exports/faers_xml_2016q4.zip          82MB
#> 32: https://fis.fda.gov/content/Exports/faers_xml_2016q3.zip          87MB
#> 33: https://fis.fda.gov/content/Exports/faers_xml_2016q2.zip          81MB
#> 34: https://fis.fda.gov/content/Exports/faers_xml_2016q1.zip          84MB
#> 35: https://fis.fda.gov/content/Exports/faers_xml_2015q4.zip          77MB
#> 36: https://fis.fda.gov/content/Exports/faers_xml_2015q3.zip          88MB
#> 37: https://fis.fda.gov/content/Exports/faers_xml_2015q2.zip          70MB
#> 38: https://fis.fda.gov/content/Exports/faers_xml_2015q1.zip          72MB
#> 39: https://fis.fda.gov/content/Exports/faers_xml_2014q4.zip          53MB
#> 40: https://fis.fda.gov/content/Exports/faers_xml_2014q3.zip          54MB
#> 41: https://fis.fda.gov/content/Exports/faers_xml_2014q2.zip          44MB
#> 42: https://fis.fda.gov/content/Exports/faers_xml_2014q1.zip          52MB
#> 43: https://fis.fda.gov/content/Exports/faers_xml_2013q4.zip          46MB
#> 44: https://fis.fda.gov/content/Exports/faers_xml_2013q3.zip          40MB
#> 45: https://fis.fda.gov/content/Exports/faers_xml_2013q2.zip          38MB
#> 46: https://fis.fda.gov/content/Exports/faers_xml_2013q1.zip          44MB
#> 47: https://fis.fda.gov/content/Exports/faers_xml_2012q4.zip          50MB
#> 48: https://fis.fda.gov/content/Exports/aers_sgml_2012q3.zip          21MB
#> 49: https://fis.fda.gov/content/Exports/aers_sgml_2012q2.zip          32MB
#> 50: https://fis.fda.gov/content/Exports/aers_sgml_2012q1.zip          33MB
#> 51: https://fis.fda.gov/content/Exports/aers_sgml_2011q4.zip          29MB
#> 52: https://fis.fda.gov/content/Exports/aers_sgml_2011q3.zip          29MB
#> 53: https://fis.fda.gov/content/Exports/aers_sgml_2011q2.zip          29MB
#> 54: https://fis.fda.gov/content/Exports/aers_sgml_2011q1.zip          26MB
#> 55: https://fis.fda.gov/content/Exports/aers_sgml_2010q4.zip          25MB
#> 56: https://fis.fda.gov/content/Exports/aers_sgml_2010q3.zip          28MB
#> 57: https://fis.fda.gov/content/Exports/aers_sgml_2010q2.zip          22MB
#> 58: https://fis.fda.gov/content/Exports/aers_sgml_2010q1.zip          20MB
#> 59: https://fis.fda.gov/content/Exports/aers_sgml_2009q4.zip          20MB
#> 60: https://fis.fda.gov/content/Exports/aers_sgml_2009q3.zip          19MB
#> 61: https://fis.fda.gov/content/Exports/aers_sgml_2009q2.zip          18MB
#> 62: https://fis.fda.gov/content/Exports/aers_sgml_2009q1.zip          16MB
#> 63: https://fis.fda.gov/content/Exports/aers_sgml_2008q4.zip          16MB
#> 64: https://fis.fda.gov/content/Exports/aers_sgml_2008q3.zip          16MB
#> 65: https://fis.fda.gov/content/Exports/aers_sgml_2008q2.zip          16MB
#> 66: https://fis.fda.gov/content/Exports/aers_sgml_2008q1.zip          15MB
#> 67: https://fis.fda.gov/content/Exports/aers_sgml_2007q4.zip          14MB
#> 68: https://fis.fda.gov/content/Exports/aers_sgml_2007q3.zip          13MB
#> 69: https://fis.fda.gov/content/Exports/aers_sgml_2007q2.zip          12MB
#> 70: https://fis.fda.gov/content/Exports/aers_sgml_2007q1.zip          12MB
#>  [ reached getOption("max.print") -- omitted 13 rows ]
```

### Download and Parse quarterly data files from FAERS

The FAERS Quarterly Data files contain raw data extracted from the AERS
database for the indicated time ranges. The quarterly data files, which
are available in ASCII or SGML formats, include:

- `demo`: demographic and administrative information
- `drug`: drug information from the case reports
- `reac`: reaction information from the reports
- `outc`: patient outcome information from the reports
- `rpsr`: information on the source of the reports
- `ther`: drug therapy start dates and end dates for the reported drugs
- `indi`: contains all “Medical Dictionary for Regulatory Activities”
  (MedDRA) terms coded for the indications for use (diagnoses) for the
  reported drugs

Generally, we can use `faers()` function to download and parse all
quarterly data files from FAERS. Internally, the `faers()` function
seamlessly utilizes `faers_download()` and `faers_parse()` to preprocess
each quarterly data file from the FAERS repository. The default `format`
was `ascii` and will return a `FAERSascii` object. (xml format would
also be okay , but presently, the XML file receives only minimal support
in the following process.)

Some variables has been added into specific field. See `?faers_parse`
for details.

``` r
# Please make sure to replace dir with your own directory path, as the file
# included in the package is a sampled version.
data1 <- faers(2004, "q1",
    dir = system.file("extdata", package = "faers"),
    compress_dir = tempdir()
)
#> Finding 1 file already downloaded: 'aers_ascii_2004q1.zip'
data1
#> FAERS data from 1 Quarterly ascii file
#>   Total reports: 100 (with duplicates)
```

Furthermore, in cases where multiple quarterly data files are requisite,
the `faers_combine()` function is judiciously employed.

``` r
data2 <- faers(c(2004, 2017), c("q1", "q2"),
    dir = system.file("extdata", package = "faers"),
    compress_dir = tempdir()
)
#> Finding 2 files already downloaded: 'aers_ascii_2004q1.zip' and
#> 'faers_ascii_2017q2.zip'
#> → Combining all 2 <FAERS> Datas
data2
#> FAERS data from 2 Quarterly ascii files
#>   Total reports: 200 (with duplicates)
```

You can use `faers_get()` to get specific field data, a data.table will
be returned.

``` r
faers_get(data2, "demo")
#>       year quarter primaryid   caseid i_f_code foll_seq     image event_dt
#>      <int>  <char>    <char>   <char>   <char>    <int>    <char>    <int>
#>   1:  2004      q1   4263764  4060920        I       NA 4263764-6 20020101
#>   2:  2004      q1   4263927  4064250        I       NA 4263927-X       NA
#>   3:  2004      q1   4264001  4062524        I       NA 4264001-9 20031218
#>   4:  2004      q1   4264319  4064506        I       NA 4264319-X 20031216
#>   5:  2004      q1   4266745  4056689        I       NA 4266745-1 20030529
#>  ---                                                                      
#> 196:  2017      q2 136874291 13687429        I       NA      <NA>       NA
#> 197:  2017      q2 136987441 13698744        I       NA      <NA>   201706
#> 198:  2017      q2 137054551 13705455        I       NA      <NA> 20160103
#> 199:  2017      q2 137055661 13705566        I       NA      <NA>       NA
#> 200:  2017      q2 137086221 13708622        I       NA      <NA>       NA
#>        mfr_dt   fda_dt rept_cod                                      mfr_num
#>         <int>    <int>   <char>                                       <char>
#>   1: 20031219 20040102      EXP                                 USA031255171
#>   2: 20031209 20040102      EXP                                    B0317710A
#>   3: 20031219 20040102      EXP                        JP-JNJFOC-20031204393
#>   4: 20031218 20040105      EXP                                 MEDI-0001221
#>   5: 20040105 20040108      EXP                 FR-GLAXOSMITHKLINE-B0318977A
#>  ---                                                                        
#> 196: 20170612 20170624      EXP                          GB-TORRENT-00015363
#> 197: 20170623 20170628      EXP                     JP-PFIZER INC-2017277430
#> 198: 20170501 20170630      EXP                         US-BAYER-2017-084170
#> 199: 20140423 20170630      PER  US-IPSEN BIOPHARMACEUTICALS, INC.-2014-2195
#> 200: 20151116 20170630      PER US-IPSEN BIOPHARMACEUTICALS, INC.-2015-08780
#>                                    mfr_sndr   age age_cod gender  e_sub    wt
#>                                      <char> <num>  <char> <char> <char> <num>
#>   1:                  ELI LILLY AND COMPANY    68      YR      F      N  82.0
#>   2: GLAXOSMITHKLINE GLOBAL CLINICAL SAFETY    58      YR      F      N    NA
#>   3:                         CENTOCOR, INC.    53      YR      F      N  36.8
#>   4:                         MEDIMUNE, INC.    NA    <NA>      F      N    NA
#>   5:                        GLAXOSMITHKLINE    48      YR      F      Y    NA
#>  ---                                                                         
#> 196:                                TORRENT    NA    <NA>   <NA>      Y    NA
#> 197:                                 PFIZER    NA    <NA>   <NA>      Y    NA
#> 198:                                  BAYER    84      YR      M      Y    NA
#> 199:                                  IPSEN    NA    <NA>      F      Y    NA
#> 200:                                  IPSEN    52      YR      F      Y    NA
#>      wt_cod  rept_dt occp_cod death_dt to_mfr confid    v23 caseversion
#>      <char>    <int>   <char>   <lgcl> <char> <char> <lgcl>       <int>
#>   1:     KG 20031223     <NA>       NA   <NA>   <NA>     NA           0
#>   2:   <NA> 20031219     <NA>       NA   <NA>   <NA>     NA           0
#>   3:     KG 20031231       MD       NA   <NA>   <NA>     NA           0
#>   4:   <NA> 20031231       MD       NA   <NA>   <NA>     NA           0
#>   5:   <NA> 20040108       CN       NA   <NA>   <NA>     NA           0
#>  ---                                                                   
#> 196:   <NA> 20170624       CN       NA   <NA>   <NA>     NA           1
#> 197:   <NA> 20170628       MD       NA   <NA>   <NA>     NA           1
#> 198:   <NA> 20170630       LW       NA   <NA>   <NA>     NA           1
#> 199:   <NA> 20170630       OT       NA   <NA>   <NA>     NA           1
#> 200:   <NA> 20170630       MD       NA   <NA>   <NA>     NA           1
#>      age_in_years country_code    sex init_fda_dt             auth_num lit_ref
#>             <num>       <char> <char>       <int>               <char>  <char>
#>   1:           68         <NA> Female          NA                 <NA>    <NA>
#>   2:           58         <NA> Female          NA                 <NA>    <NA>
#>   3:           53         <NA> Female          NA                 <NA>    <NA>
#>   4:           NA         <NA> Female          NA                 <NA>    <NA>
#>   5:           48         <NA> Female          NA                 <NA>    <NA>
#>  ---                                                                          
#> 196:           NA           GB   <NA>    20170624 GB-MHRA-ADR 24016450    <NA>
#> 197:           NA           JP   <NA>    20170628                 <NA>    <NA>
#> 198:           84           US   Male    20170630                 <NA>    <NA>
#> 199:           NA           US Female    20170630                 <NA>    <NA>
#> 200:           52           US Female    20170630                 <NA>    <NA>
#>      age_grp reporter_country occr_country
#>       <char>           <char>       <char>
#>   1:    <NA>             <NA>         <NA>
#>   2:    <NA>             <NA>         <NA>
#>   3:    <NA>             <NA>         <NA>
#>   4:    <NA>             <NA>         <NA>
#>   5:    <NA>             <NA>         <NA>
#>  ---                                      
#> 196:       N               GB           GB
#> 197:    <NA>               JP           JP
#> 198:       E               US           US
#> 199:    <NA>               US           US
#> 200:    <NA>               US           US
```

### Standardize and De-duplication

The `reac` file provides the adverse drug reactions, where it includes
the “P.T.” field or the “Preferred Term” level terminology from the
Medical Dictionary for Regulatory Activities (MedDRA). The `indi` file
contains the drug indications, which also uses the “P.T.” level of
MedDRA as a descriptor for the drug indication. In this way, `MedDRA`
was necessary to standardize this field and add additional informations,
such as `System Organ Classes`.

``` r
# you must replace `meddra_path` with the path of uncompressed meddra data
data <- faers_standardize(data2, meddra_path)
```

To proceed following steps, we just read a standardized data.

``` r
data <- readRDS(system.file("extdata", "standardized_data.rds", package = "faers"))
data
#> Standardized FAERS data from 2 Quarterly ascii files
#>   Total reports: 200 (with duplicates)
```

The internal will save the complete MedDRA data in the `@meddra` slot,
MedDRA consists of two components: hierarchy and SMQ data. We can
specify these components using the use argument.

``` r
faers_meddra(data)
#> Hierarchy data for MedDRA (version 26.1)
faers_meddra(data, use = "hierarchy")
#> Index: <primary_soc_fg>
#>        llt_code
#>           <int>
#>     1: 10000001
#>     2: 10000002
#>     3: 10000003
#>     4: 10000004
#>     5: 10000005
#>    ---         
#> 87588: 10089903
#> 87589: 10089904
#> 87590: 10089905
#> 87591: 10089906
#> 87592: 10089907
#>                                                                llt_name
#>                                                                  <char>
#>     1:                                        "Ventilation" pneumonitis
#>     2:                                   11-beta-hydroxylase deficiency
#>     3:                                      11-oxysteroid activity incr
#>     4:                                 11-oxysteroid activity increased
#>     5:                                            17 ketosteroids urine
#>    ---                                                                 
#> 87588:                                Unintentional exposure to product
#> 87589:                       Unintentional exposure to product by child
#> 87590:                                Smouldering systemic mastocytosis
#> 87591: Systemic mastocytosis with an associated haematological neoplasm
#> 87592:                                              Smouldering myeloma
#>         pt_code                                 pt_name hlt_code
#>           <int>                                  <char>    <int>
#>     1: 10081988            Hypersensitivity pneumonitis 10024972
#>     2: 10000002          11-beta-hydroxylase deficiency 10021608
#>     3: 10033315            Oxycorticosteroids increased 10001339
#>     4: 10033315            Oxycorticosteroids increased 10001339
#>     5: 10000005                   17 ketosteroids urine 10038589
#>    ---                                                          
#> 87588: 10073317          Accidental exposure to product 10073316
#> 87589: 10073318 Accidental exposure to product by child 10073316
#> 87590: 10089905       Smouldering systemic mastocytosis 10018845
#> 87591: 10089805          Advanced systemic mastocytosis 10018845
#> 87592: 10035226                     Plasma cell myeloma 10074470
#>                                                               hlt_name
#>                                                                 <char>
#>     1: Lower respiratory tract inflammatory and immunologic conditions
#>     2:                              Inborn errors of steroid synthesis
#>     3:                                            Adrenal cortex tests
#>     4:                                            Adrenal cortex tests
#>     5:                                   Reproductive hormone analyses
#>    ---                                                                
#> 87588:                                 Accidental exposures to product
#> 87589:                                 Accidental exposures to product
#> 87590:                                      Haematologic neoplasms NEC
#> 87591:                                      Haematologic neoplasms NEC
#> 87592:                                            Plasma cell myelomas
#>        hlgt_code
#>            <int>
#>     1:  10024967
#>     2:  10027424
#>     3:  10014706
#>     4:  10014706
#>     5:  10014706
#>    ---          
#> 87588:  10079145
#> 87589:  10079145
#> 87590:  10018865
#> 87591:  10018865
#> 87592:  10035227
#>                                                                 hlgt_name
#>                                                                    <char>
#>     1: Lower respiratory tract disorders (excl obstruction and infection)
#>     2:                     Metabolic and nutritional disorders congenital
#>     3:                       Endocrine investigations (incl sex hormones)
#>     4:                       Endocrine investigations (incl sex hormones)
#>     5:                       Endocrine investigations (incl sex hormones)
#>    ---                                                                   
#> 87588:          Medication errors and other product use errors and issues
#> 87589:          Medication errors and other product use errors and issues
#> 87590:           Haematopoietic neoplasms (excl leukaemias and lymphomas)
#> 87591:           Haematopoietic neoplasms (excl leukaemias and lymphomas)
#> 87592:                                              Plasma cell neoplasms
#>        soc_code
#>           <int>
#>     1: 10038738
#>     2: 10010331
#>     3: 10022891
#>     4: 10022891
#>     5: 10022891
#>    ---         
#> 87588: 10022117
#> 87589: 10022117
#> 87590: 10029104
#> 87591: 10029104
#> 87592: 10029104
#>                                                                   soc_name
#>                                                                     <char>
#>     1:                     Respiratory, thoracic and mediastinal disorders
#>     2:                          Congenital, familial and genetic disorders
#>     3:                                                      Investigations
#>     4:                                                      Investigations
#>     5:                                                      Investigations
#>    ---                                                                    
#> 87588:                      Injury, poisoning and procedural complications
#> 87589:                      Injury, poisoning and procedural complications
#> 87590: Neoplasms benign, malignant and unspecified (incl cysts and polyps)
#> 87591: Neoplasms benign, malignant and unspecified (incl cysts and polyps)
#> 87592: Neoplasms benign, malignant and unspecified (incl cysts and polyps)
#>        soc_abbrev primary_soc_fg
#>            <char>         <char>
#>     1:       Resp              Y
#>     2:       Cong              Y
#>     3:        Inv              Y
#>     4:        Inv              Y
#>     5:        Inv              Y
#>    ---                          
#> 87588:      Inj&P              Y
#> 87589:      Inj&P              Y
#> 87590:      Neopl              Y
#> 87591:      Neopl              Y
#> 87592:      Neopl              Y
```

The internal will include a `meddra_hierarchy_idx` column that
represents the index of the MedDRA hierarchy data in the `indi` and
`reac` field when standardized. Additionally, the columns
`meddra_hierarchy_from`, `meddra_code`, and `meddra_pt` will also be
added which provide standardized names of the original PT (indi:
indi_pt; reac: pt) (refer to `ASC_NTS.pdf` or `ASC_NTS.docx` in the
FAERS quarterly file for the meanings of the original names, most
original names will remain unchanged except for some names different
between FAERS quarterly files, see `?faers_parse` for details). We can
retrieve this data using the `faers_meddra()` function. When we use
`faers_get()` to retrieve `indi` or `reac` data from the standardized
`FAERSascii` object, the meddra hierarchy columns are automatically
added to the returned data.table.

``` r
faers_get(data, "indi")
#>       year quarter primaryid indi_drug_seq
#>      <int>  <char>    <char>         <int>
#>   1:  2004      q1   4263927    1004493661
#>   2:  2004      q1   4264001    1004493811
#>   3:  2004      q1   4264001    1004520441
#>   4:  2004      q1   4264001    1004520538
#>   5:  2004      q1   4264319    1004494389
#>  ---                                      
#> 376:  2017      q2 137054551            15
#> 377:  2017      q2 137054551            16
#> 378:  2017      q2 137054551            17
#> 379:  2017      q2 137055661             1
#> 380:  2017      q2 137086221             1
#>                                      indi_pt   caseid meddra_hierarchy_from
#>                                       <char>   <char>                <char>
#>   1: DIABETES MELLITUS NON-INSULIN-DEPENDENT     <NA>                   llt
#>   2:                    RHEUMATOID ARTHRITIS     <NA>                   llt
#>   3:                    RHEUMATOID ARTHRITIS     <NA>                   llt
#>   4:                    RHEUMATOID ARTHRITIS     <NA>                   llt
#>   5:                   ANTIVIRAL PROPHYLAXIS     <NA>                   llt
#>  ---                                                                       
#> 376:        Gastrooesophageal reflux disease 13705455                   llt
#> 377:                       Colitis ischaemic 13705455                   llt
#> 378:             Blood cholesterol increased 13705455                   llt
#> 379:                              Acromegaly 13705566                   llt
#> 380:     Product used for unknown indication 13708622                   llt
#>      meddra_code                               meddra_pt llt_code
#>           <char>                                  <char>    <int>
#>   1:    10012613 Diabetes mellitus non-insulin-dependent 10012613
#>   2:    10039073                    Rheumatoid arthritis 10039073
#>   3:    10039073                    Rheumatoid arthritis 10039073
#>   4:    10039073                    Rheumatoid arthritis 10039073
#>   5:    10049087                   Antiviral prophylaxis 10049087
#>  ---                                                             
#> 376:    10017885        Gastrooesophageal reflux disease 10017885
#> 377:    10009895                       Colitis ischaemic 10009895
#> 378:    10005425             Blood cholesterol increased 10005425
#> 379:    10000599                              Acromegaly 10000599
#> 380:    10070592     Product used for unknown indication 10070592
#>                                     llt_name  pt_code
#>                                       <char>    <int>
#>   1: Diabetes mellitus non-insulin-dependent 10067585
#>   2:                    Rheumatoid arthritis 10039073
#>   3:                    Rheumatoid arthritis 10039073
#>   4:                    Rheumatoid arthritis 10039073
#>   5:                   Antiviral prophylaxis 10049087
#>  ---                                                 
#> 376:        Gastrooesophageal reflux disease 10017885
#> 377:                       Colitis ischaemic 10009895
#> 378:             Blood cholesterol increased 10005425
#> 379:                              Acromegaly 10000599
#> 380:     Product used for unknown indication 10070592
#>                                  pt_name hlt_code
#>                                   <char>    <int>
#>   1:            Type 2 diabetes mellitus 10012602
#>   2:                Rheumatoid arthritis 10039078
#>   3:                Rheumatoid arthritis 10039078
#>   4:                Rheumatoid arthritis 10039078
#>   5:               Antiviral prophylaxis 10002790
#>  ---                                             
#> 376:    Gastrooesophageal reflux disease 10017933
#> 377:                   Colitis ischaemic 10009888
#> 378:         Blood cholesterol increased 10008651
#> 379:                          Acromegaly 10002700
#> 380: Product used for unknown indication 10027700
#>                                                    hlt_name hlgt_code
#>                                                      <char>     <int>
#>   1:                      Diabetes mellitus (incl subtypes)  10018424
#>   2:                               Rheumatoid arthropathies  10023213
#>   3:                               Rheumatoid arthropathies  10023213
#>   4:                               Rheumatoid arthropathies  10023213
#>   5:                                Antiinfective therapies  10043413
#>  ---                                                                 
#> 376: Gastrointestinal atonic and hypomotility disorders NEC  10017977
#> 377:                               Colitis (excl infective)  10017969
#> 378:                                   Cholesterol analyses  10024580
#> 379:                       Anterior pituitary hyperfunction  10021112
#> 380:                             Therapeutic procedures NEC  10043413
#>                                                  hlgt_name soc_code
#>                                                     <char>    <int>
#>   1: Glucose metabolism disorders (incl diabetes mellitus) 10027433
#>   2:                                       Joint disorders 10028395
#>   3:                                       Joint disorders 10028395
#>   4:                                       Joint disorders 10028395
#>   5:        Therapeutic procedures and supportive care NEC 10042613
#>  ---                                                               
#> 376:  Gastrointestinal motility and defaecation conditions 10017947
#> 377:              Gastrointestinal inflammatory conditions 10017947
#> 378:                                        Lipid analyses 10022891
#> 379:            Hypothalamus and pituitary gland disorders 10014698
#> 380:        Therapeutic procedures and supportive care NEC 10042613
#>                                             soc_name soc_abbrev primary_soc_fg
#>                                               <char>     <char>         <char>
#>   1:              Metabolism and nutrition disorders      Metab              Y
#>   2: Musculoskeletal and connective tissue disorders       Musc              Y
#>   3: Musculoskeletal and connective tissue disorders       Musc              Y
#>   4: Musculoskeletal and connective tissue disorders       Musc              Y
#>   5:                 Surgical and medical procedures       Surg              Y
#>  ---                                                                          
#> 376:                      Gastrointestinal disorders      Gastr              Y
#> 377:                      Gastrointestinal disorders      Gastr              Y
#> 378:                                  Investigations        Inv              Y
#> 379:                             Endocrine disorders       Endo              Y
#> 380:                 Surgical and medical procedures       Surg              Y
```

``` r
faers_get(data, "reac")
#>       year quarter primaryid                                            pt
#>      <int>  <char>    <char>                                        <char>
#>   1:  2004      q1   4263764                      BLOOD PRESSURE INCREASED
#>   2:  2004      q1   4263764          DIABETES MELLITUS INADEQUATE CONTROL
#>   3:  2004      q1   4263927                      ACCELERATED HYPERTENSION
#>   4:  2004      q1   4263927                                     DIZZINESS
#>   5:  2004      q1   4263927                                       FATIGUE
#>  ---                                                                      
#> 638:  2017      q2 136987441                     Interstitial lung disease
#> 639:  2017      q2 137054551                                   Haemothorax
#> 640:  2017      q2 137055661                                     Diarrhoea
#> 641:  2017      q2 137055661 Inappropriate schedule of drug administration
#> 642:  2017      q2 137086221                            Menstrual disorder
#>          v3   caseid drug_rec_act meddra_hierarchy_from meddra_code
#>      <lgcl>   <char>       <lgcl>                <char>      <char>
#>   1:     NA     <NA>           NA                   llt    10005750
#>   2:     NA     <NA>           NA                   llt    10012607
#>   3:     NA     <NA>           NA                   llt    10000358
#>   4:     NA     <NA>           NA                   llt    10013573
#>   5:     NA     <NA>           NA                   llt    10016256
#>  ---                                                               
#> 638:     NA 13698744           NA                   llt    10022611
#> 639:     NA 13705455           NA                   llt    10019027
#> 640:     NA 13705566           NA                   llt    10012735
#> 641:     NA 13705566           NA                   llt    10021597
#> 642:     NA 13708622           NA                   llt    10027327
#>                                          meddra_pt llt_code
#>                                             <char>    <int>
#>   1:                      Blood pressure increased 10005750
#>   2:          Diabetes mellitus inadequate control 10012607
#>   3:                      Accelerated hypertension 10000358
#>   4:                                     Dizziness 10013573
#>   5:                                       Fatigue 10016256
#>  ---                                                       
#> 638:                     Interstitial lung disease 10022611
#> 639:                                   Haemothorax 10019027
#> 640:                                     Diarrhoea 10012735
#> 641: Inappropriate schedule of drug administration 10021597
#> 642:                            Menstrual disorder 10027327
#>                                           llt_name  pt_code
#>                                             <char>    <int>
#>   1:                      Blood pressure increased 10005750
#>   2:          Diabetes mellitus inadequate control 10012607
#>   3:                      Accelerated hypertension 10000358
#>   4:                                     Dizziness 10013573
#>   5:                                       Fatigue 10016256
#>  ---                                                       
#> 638:                     Interstitial lung disease 10022611
#> 639:                                   Haemothorax 10019027
#> 640:                                     Diarrhoea 10012735
#> 641: Inappropriate schedule of drug administration 10081572
#> 642:                            Menstrual disorder 10027327
#>                                               pt_name hlt_code
#>                                                <char>    <int>
#>   1:                         Blood pressure increased 10047110
#>   2:             Diabetes mellitus inadequate control 10012602
#>   3:                         Accelerated hypertension 10000356
#>   4:                                        Dizziness 10029306
#>   5:                                          Fatigue 10003550
#>  ---                                                          
#> 638:                        Interstitial lung disease 10033979
#> 639:                                      Haemothorax 10035761
#> 640:                                        Diarrhoea 10012736
#> 641: Inappropriate schedule of product administration 10079147
#> 642:                               Menstrual disorder 10027335
#>                                      hlt_name hlgt_code
#>                                        <char>     <int>
#>   1: Vascular tests NEC (incl blood pressure)  10007512
#>   2:        Diabetes mellitus (incl subtypes)  10018424
#>   3:   Accelerated and malignant hypertension  10057166
#>   4:      Neurological signs and symptoms NEC  10029305
#>   5:                      Asthenic conditions  10018073
#>  ---                                                   
#> 638:           Parenchymal lung disorders NEC  10024967
#> 639:   Pneumothorax and pleural effusions NEC  10035597
#> 640:               Diarrhoea (excl infective)  10017977
#> 641: Product administration errors and issues  10079145
#> 642:    Menstruation and uterine bleeding NEC  10013326
#>                                                               hlgt_name
#>                                                                  <char>
#>   1:            Cardiac and vascular investigations (excl enzyme tests)
#>   2:              Glucose metabolism disorders (incl diabetes mellitus)
#>   3:                                    Vascular hypertensive disorders
#>   4:                                         Neurological disorders NEC
#>   5:                                       General system disorders NEC
#>  ---                                                                   
#> 638: Lower respiratory tract disorders (excl obstruction and infection)
#> 639:                                                  Pleural disorders
#> 640:               Gastrointestinal motility and defaecation conditions
#> 641:          Medication errors and other product use errors and issues
#> 642:                     Menstrual cycle and uterine bleeding disorders
#>      soc_code                                             soc_name soc_abbrev
#>         <int>                                               <char>     <char>
#>   1: 10022891                                       Investigations        Inv
#>   2: 10027433                   Metabolism and nutrition disorders      Metab
#>   3: 10047065                                   Vascular disorders       Vasc
#>   4: 10029205                             Nervous system disorders       Nerv
#>   5: 10018065 General disorders and administration site conditions      Genrl
#>  ---                                                                         
#> 638: 10038738      Respiratory, thoracic and mediastinal disorders       Resp
#> 639: 10038738      Respiratory, thoracic and mediastinal disorders       Resp
#> 640: 10017947                           Gastrointestinal disorders      Gastr
#> 641: 10022117       Injury, poisoning and procedural complications      Inj&P
#> 642: 10038604             Reproductive system and breast disorders      Repro
#>      primary_soc_fg
#>              <char>
#>   1:              Y
#>   2:              Y
#>   3:              Y
#>   4:              Y
#>   5:              Y
#>  ---               
#> 638:              Y
#> 639:              Y
#> 640:              Y
#> 641:              Y
#> 642:              Y
```

One limitation of FAERS database is duplicate and incomplete reports.
There are many instances of duplicative reports and some reports do not
contain all the necessary information. We deemed two cases to be
identical if they exhibited a full concordance across drugs
administered, and adverse reactions and but showed discrepancies in one
or none of the following fields: gender, age, reporting country, event
date, start date, and drug indications.

``` r
data <- faers_dedup(data)
#> → deduplication from the same source by retain the most recent report
#> → merging `drug`, `indi`, `ther`, and `reac` data
#> → deduplication from multiple sources by matching sex, age, reporting country, event date, start date, drug indications, drugs administered, and adverse reactions
data
#> Standardized and De-duplicated FAERS data from 2 Quarterly ascii files
#>   Total unique reports: 200
```

### Pharmacovigilance analysis

Pharmacovigilance is the science and activities relating to the
detection, assessment, understanding and prevention of adverse effects
or any other medicine/vaccine related problem.

To mine the signals of “insulin”, we start by using the `faers_filter()`
function. In this function, the `.fn` argument should be a function that
accepts data specified in `.field`. It is important to note that `.fn`
should always return the `primaryid` that you want to keep.

To enhance our analysis, it would be advantageous to include all drug
synonym names for `insulin`. These synonyms can be obtained by querying
sources such as <https://go.drugbank.com/> or alternative databases.
Furthermore, we extract the brand names of insulin from the
[Drugs@FDA](https://www.fda.gov/drugs/drug-approvals-and-databases/drugsfda-data-files)
dataset, which can be easily obtained using the `fda_drugs()` function.

``` r
insulin_names <- "insulin"
insulin_pattern <- paste(insulin_names, collapse = "|")
fda_insulin <- fda_drugs()[
    grepl(insulin_pattern, ActiveIngredient, ignore.case = TRUE)
]
#> → Using Drugs@FDA data from cached
#>   '/home/yun/.cache/R/faers/faers/fdadrugs/fda_drugs_data_2025-09-23.zip'
#>   Snapshot date: 2025-09-23
insulin_pattern <- paste0(
    unique(tolower(c(insulin_names, fda_insulin$DrugName))),
    collapse = "|"
)
insulin_data <- faers_filter(data, .fn = function(x) {
    idx <- grepl(insulin_pattern, x$drugname, ignore.case = TRUE) |
        grepl(insulin_pattern, x$prod_ai, ignore.case = TRUE)
    x[idx, primaryid]
}, .field = "drug")
insulin_data
#> Standardized and De-duplicated FAERS data from 2 Quarterly ascii files
#>   Total unique reports: 9
```

Then, signal can be easily obtained with `faers_phv_signal()` which
internally use `faers_phv_table()` to create a contingency table and use
`phv_signal()` to do signal analysis specified in `.methods` argument.
By default, all supported signal analysis methods will be run, including
“ror”, “prr”, “chisq”, “bcpnn_norm”, “bcpnn_mcmc”, “obsexp_shrink”,
“fisher”, and “ebgm”.

The most important argument for this function is `.object`, which should
be a de-duplicated FAERSascii object containing the data for the drugs
or traits of interest. Additionally, you must specify either `.full`,
which represents the background distributions data (usually the entire
FAERS data), or you can specify `.object2`, which should be the control
data or another drug of interest for comparison.

``` r
insulin_signals <- faers_phv_signal(insulin_data,
    .full = data,
    BPPARAM = BiocParallel::SerialParam(RNGseed = 1L)
)
#> ℹ Running `phv_ror()`
#> ℹ Running `phv_prr()`
#> ℹ Running `phv_chisq()`
#> ℹ Running `phv_bcpnn_norm()`
#> ℹ Running `phv_bcpnn_mcmc()`
#> ℹ Running `phv_obsexp_shrink()`
#> ℹ Running `phv_fisher()`
#> ℹ Running `phv_ebgm()`
insulin_signals
#> Key: <soc_name>
#>                                                                soc_name     a
#>                                                                  <char> <int>
#>  1:                                Blood and lymphatic system disorders     1
#>  2:                                                   Cardiac disorders     2
#>  3:                          Congenital, familial and genetic disorders     0
#>  4:                                         Ear and labyrinth disorders     0
#>  5:                                                 Endocrine disorders     0
#>  6:                                                       Eye disorders     0
#>  7:                                          Gastrointestinal disorders     1
#>  8:                General disorders and administration site conditions     3
#>  9:                                             Hepatobiliary disorders     0
#> 10:                                             Immune system disorders     1
#> 11:                                         Infections and infestations     1
#> 12:                      Injury, poisoning and procedural complications     2
#> 13:                                                      Investigations     5
#> 14:                                  Metabolism and nutrition disorders     2
#> 15:                     Musculoskeletal and connective tissue disorders     2
#>         b     c     d expected       ror ror_ci_low ror_ci_high       prr
#>     <int> <int> <int>    <num>     <num>      <num>       <num>     <num>
#>  1:     8    10   181    0.495 2.2625000 0.25725215   19.898400 2.1222222
#>  2:     7    14   177    0.720 3.6122449 0.68476430   19.055189 3.0317460
#>  3:     9     1   190    0.045 0.0000000 0.00000000         NaN 0.0000000
#>  4:     9     1   190    0.045 0.0000000 0.00000000         NaN 0.0000000
#>  5:     9     1   190    0.045 0.0000000 0.00000000         NaN 0.0000000
#>  6:     9     3   188    0.135 0.0000000 0.00000000         NaN 0.0000000
#>  7:     8    33   158    1.530 0.5984848 0.07238296    4.948459 0.6430976
#>  8:     6    63   128    2.970 1.0158730 0.24595627    4.195860 1.0105820
#>  9:     9     7   184    0.315 0.0000000 0.00000000         NaN 0.0000000
#> 10:     8     5   186    0.270 4.6500000 0.48490936   44.590808 4.2444444
#> 11:     8    20   171    0.945 1.0687500 0.12702886    8.991866 1.0611111
#> 12:     7    30   161    1.440 1.5333333 0.30372417    7.740942 1.4148148
#> 13:     4    23   168    1.260 9.1304348 2.28530339   36.478675 4.6135266
#> 14:     7    16   175    0.810 3.1250000 0.59851341   16.316468 2.6527778
#> 15:     7    16   175    0.810 3.1250000 0.59851341   16.316468 2.6527778
#>     prr_ci_low prr_ci_high        chisq chisq_pvalue bcpnn_norm_ic
#>          <num>       <num>        <num>        <num>         <num>
#>  1: 0.30379118   14.825405 5.596283e-05  0.994031217    0.07104720
#>  2: 0.80811718   11.373950 9.617573e-01  0.326744514    0.56756743
#>  3: 0.00000000         NaN 3.656454e-27  1.000000000   -0.51110211
#>  4: 0.00000000         NaN 3.656454e-27  1.000000000   -0.51110211
#>  5: 0.00000000         NaN 3.656454e-27  1.000000000   -0.51110211
#>  6: 0.00000000         NaN 6.503567e-28  1.000000000   -0.83645056
#>  7: 0.09874593    4.188270 7.421123e-04  0.978266926   -0.74210295
#>  8: 0.39248199    2.602096 7.473582e-32  1.000000000   -0.20701337
#>  9: 0.00000000         NaN 1.786975e-29  1.000000000   -1.15078008
#> 10: 0.55173607   32.652041 2.115031e-01  0.645591807    0.35698592
#> 11: 0.15969124    7.050836 4.127312e-31  1.000000000   -0.34437600
#> 12: 0.39906207    5.016014 3.116430e-03  0.955481225    0.03350040
#> 13: 2.29367967    9.279686 1.014420e+01  0.001447562    1.27887175
#> 14: 0.71637974    9.823324 6.763452e-01  0.410848097    0.48796446
#> 15: 0.71637974    9.823324 6.763452e-01  0.410848097    0.48796446
#>     bcpnn_norm_ic_ci_low bcpnn_norm_ic_ci_high bcpnn_mcmc_ic
#>                    <num>                 <num>         <num>
#>  1:           -2.4976231              2.639718    0.59289239
#>  2:           -1.5265734              2.661708    1.03548539
#>  3:           -4.8776285              3.855424   -0.12173930
#>  4:           -4.8776285              3.855424   -0.12173930
#>  5:           -4.8776285              3.855424   -0.12173930
#>  6:           -4.8584283              3.185527   -0.34296004
#>  7:           -3.2168766              1.732671   -0.43639278
#>  8:           -1.9734584              1.559432    0.01244120
#>  9:           -5.0194729              2.717913   -0.70378441
#> 10:           -2.3142523              3.028224    0.96326361
#> 11:           -2.8481952              2.159443    0.05418696
#> 12:           -2.0013075              2.068308    0.36601183
#> 13:           -0.2922032              2.849947    1.64403679
#> 14:           -1.5933747              2.569304    0.93273250
#> 15:           -1.5933747              2.569304    0.93273250
#>     bcpnn_mcmc_ic_ci_low bcpnn_mcmc_ic_ci_high    oe_ratio oe_ratio_ci_low
#>                    <num>                 <num>       <num>           <num>
#>  1:           -3.0102202             2.0880732  0.59219407      -3.1909068
#>  2:           -1.3187573             2.2101554  1.03504695      -1.5580207
#>  3:          -10.0407092             2.1339131 -0.12432814      -9.9495140
#>  4:           -9.9798292             2.1441716 -0.12432814      -9.9461122
#>  5:          -10.0105588             2.1297171 -0.12432814     -10.0407092
#>  6:          -10.3155180             1.9044035 -0.34482850     -10.2035257
#>  7:           -4.0344771             1.0414647 -0.43651723      -4.2196181
#>  8:           -1.7245681             0.9206723  0.01241926      -2.0569464
#>  9:          -10.5755765             1.5508494 -0.70487196     -10.5739398
#> 10:           -2.6472043             2.4553831  0.96203215      -2.8210687
#> 11:           -3.5870730             1.5310781  0.05389301      -3.7292078
#> 12:           -1.9666079             1.5187159  0.36587144      -2.2271962
#> 13:            0.4991892             2.3671228  1.64385619       0.0816764
#> 14:           -1.3982876             2.0999196  0.93236128      -1.6607064
#> 15:           -1.4095817             2.0956930  0.93236128      -1.6607064
#>     oe_ratio_ci_high odds_ratio odds_ratio_ci_low odds_ratio_ci_high
#>                <num>      <num>             <num>              <num>
#>  1:        2.2796203  2.2497947        0.04640325          19.939227
#>  2:        2.4264491  3.5751799        0.33257276          21.377226
#>  3:        2.1496123  0.0000000        0.00000000         817.112299
#>  4:        2.1269540  0.0000000        0.00000000         817.112299
#>  5:        2.1339131  0.0000000        0.00000000         817.112299
#>  6:        1.9277455  0.0000000        0.00000000          55.536645
#>  7:        1.2509090  0.5998010        0.01309984           4.736220
#>  8:        1.2189129  1.0158008        0.15919644           4.943911
#>  9:        1.5433315  0.0000000        0.00000000          16.615730
#> 10:        2.6494584  4.5816265        0.08749672          48.962674
#> 11:        1.7413193  1.0684062        0.02295250           8.703699
#> 12:        1.7572736  1.5296110        0.14818709           8.572929
#> 13:        2.6284559  8.9547789        1.78787699          48.608711
#> 14:        2.3237635  3.0984073        0.29094788          18.237662
#> 15:        2.3237635  3.0984073        0.29094788          18.237662
#>     fisher_pvalue     ebgm ebgm_ci_low ebgm_ci_high
#>             <num>    <num>       <num>        <num>
#>  1:    0.40543496 1.395816        0.91         2.05
#>  2:    0.15526163 1.435648        0.95         2.09
#>  3:    1.00000000 1.373343        0.89         2.03
#>  4:    1.00000000 1.373343        0.89         2.03
#>  5:    1.00000000 1.373343        0.89         2.03
#>  6:    1.00000000 1.365913        0.89         2.02
#>  7:    1.00000000 1.315687        0.86         1.93
#>  8:    1.00000000 1.321095        0.88         1.91
#>  9:    1.00000000 1.351290        0.88         2.00
#> 10:    0.24411452 1.414544        0.93         2.08
#> 11:    1.00000000 1.359809        0.89         1.99
#> 12:    0.63824281 1.378028        0.91         2.00
#> 13:    0.00322619 1.560910        1.06         2.22
#> 14:    0.18867787 1.428183        0.94         2.08
#> 15:    0.18867787 1.428183        0.94         2.08
#>  [ reached getOption("max.print") -- omitted 13 rows ]
```

The column containing the events of interest can be specified using an
atomic character in the `.events` (default: “soc_name”) argument. The
combination of all specified columns will define the unique event.
Additionally, we can control which field data to find the columns in the
`.field` (default: “reac”) argument.

``` r
insulin_signals_hlgt <- faers_phv_signal(
    insulin_data,
    .events = "hlgt_name", .full = data,
    BPPARAM = BiocParallel::SerialParam(RNGseed = 1L)
)
#> ℹ Running `phv_ror()`
#> ℹ Running `phv_prr()`
#> ℹ Running `phv_chisq()`
#> ℹ Running `phv_bcpnn_norm()`
#> ℹ Running `phv_bcpnn_mcmc()`
#> ℹ Running `phv_obsexp_shrink()`
#> ℹ Running `phv_fisher()`
#> ℹ Running `phv_ebgm()`
insulin_signals_hlgt
#> Key: <hlgt_name>
#>                                                       hlgt_name     a     b
#>                                                          <char> <int> <int>
#>   1:                                   Abortions and stillbirth     0     9
#>   2:                                        Acid-base disorders     0     9
#>   3:                              Administration site reactions     0     9
#>   4:                                        Allergic conditions     1     8
#>   5:               Anaemias nonhaemolytic and marrow depression     1     8
#>  ---                                                                       
#> 136:                                 Viral infectious disorders     0     9
#> 137:                                           Vision disorders     0     9
#> 138:                                  Vitamin related disorders     0     9
#> 139: Vulvovaginal disorders (excl infections and inflammations)     0     9
#> 140:                                 White blood cell disorders     0     9
#>          c     d expected       ror ror_ci_low ror_ci_high       prr prr_ci_low
#>      <int> <int>    <num>     <num>      <num>       <num>     <num>      <num>
#>   1:     1   190    0.045  0.000000  0.0000000         NaN  0.000000  0.0000000
#>   2:     1   190    0.045  0.000000  0.0000000         NaN  0.000000  0.0000000
#>   3:     7   184    0.315  0.000000  0.0000000         NaN  0.000000  0.0000000
#>   4:     3   188    0.180  7.833333  0.7313919    83.89635  7.074074  0.8140454
#>   5:     2   189    0.135 11.812500  0.9671714   144.27139 10.611111  1.0580416
#>  ---                                                                           
#> 136:     5   186    0.225  0.000000  0.0000000         NaN  0.000000  0.0000000
#> 137:     2   189    0.090  0.000000  0.0000000         NaN  0.000000  0.0000000
#> 138:     1   190    0.045  0.000000  0.0000000         NaN  0.000000  0.0000000
#> 139:     1   190    0.045  0.000000  0.0000000         NaN  0.000000  0.0000000
#> 140:     4   187    0.180  0.000000  0.0000000         NaN  0.000000  0.0000000
#>      prr_ci_high        chisq chisq_pvalue bcpnn_norm_ic bcpnn_norm_ic_ci_low
#>            <num>        <num>        <num>         <num>                <num>
#>   1:         NaN 3.656454e-27    1.0000000    -0.5111021            -4.877628
#>   2:         NaN 3.656454e-27    1.0000000    -0.5111021            -4.877628
#>   3:         NaN 1.786975e-29    1.0000000    -1.1507801            -5.019473
#>   4:    61.47388 6.078522e-01    0.4355976     0.5096749            -2.261566
#>   5:   106.41895 1.049089e+00    0.3057170     0.6062445            -2.253967
#>  ---                                                                         
#> 136:         NaN 1.530722e-28    1.0000000    -1.0141202            -4.932568
#> 137:         NaN 3.065558e-31    1.0000000    -0.7103510            -4.841467
#> 138:         NaN 3.656454e-27    1.0000000    -0.5111021            -4.877628
#> 139:         NaN 3.656454e-27    1.0000000    -0.5111021            -4.877628
#> 140:         NaN 7.493363e-31    1.0000000    -0.9330202            -4.892221
#>      bcpnn_norm_ic_ci_high bcpnn_mcmc_ic bcpnn_mcmc_ic_ci_low
#>                      <num>         <num>                <num>
#>   1:              3.855424    -0.1217393            -9.949514
#>   2:              3.855424    -0.1217393            -9.946112
#>   3:              2.717913    -0.7037844           -10.647371
#>   4:              3.280916     1.1429684            -2.451903
#>   5:              3.466456     1.2420025            -2.377199
#>  ---                                                         
#> 136:              2.904328    -0.5346491           -10.419653
#> 137:              3.420765    -0.2366002           -10.059217
#> 138:              3.855424    -0.1217393           -10.109186
#> 139:              3.855424    -0.1217393            -9.993573
#> 140:              3.026180    -0.4419941           -10.270609
#>      bcpnn_mcmc_ic_ci_high   oe_ratio oe_ratio_ci_low oe_ratio_ci_high
#>                      <num>      <num>           <num>            <num>
#>   1:              2.149612 -0.1243281       -9.949514         2.149612
#>   2:              2.126954 -0.1243281       -9.946112         2.126954
#>   3:              1.546410 -0.7048720      -10.647371         1.546410
#>   4:              2.637610  1.1413558       -2.641745         2.828782
#>   5:              2.723221  1.2401340       -2.542967         2.927560
#>  ---                                                                  
#> 136:              1.718654 -0.5360529      -10.393320         1.725435
#> 137:              2.016519 -0.2387869      -10.152698         2.033643
#> 138:              2.135864 -0.1243281      -10.057893         2.136312
#> 139:              2.140545 -0.1243281      -10.025352         2.129330
#> 140:              1.813233 -0.4436067      -10.299000         1.794391
#>      odds_ratio odds_ratio_ci_low odds_ratio_ci_high fisher_pvalue     ebgm
#>           <num>             <num>              <num>         <num>    <num>
#>   1:   0.000000         0.0000000          817.11230     1.0000000 1.118622
#>   2:   0.000000         0.0000000          817.11230     1.0000000 1.118622
#>   3:   0.000000         0.0000000           16.61573     1.0000000 0.998863
#>   4:   7.641475         0.1327801          108.45121     0.1693996 1.468797
#>   5:  11.402720         0.1781480          241.08148     0.1296368 1.553892
#>  ---                                                                       
#> 136:   0.000000         0.0000000           25.82927     1.0000000 1.026924
#> 137:   0.000000         0.0000000          118.46131     1.0000000 1.090039
#> 138:   0.000000         0.0000000          817.11230     1.0000000 1.118622
#> 139:   0.000000         0.0000000          817.11230     1.0000000 1.118622
#> 140:   0.000000         0.0000000           35.42367     1.0000000 1.044722
#>      ebgm_ci_low ebgm_ci_high
#>            <num>        <num>
#>   1:        0.92         4.64
#>   2:        0.92         4.64
#>   3:        0.92         4.61
#>   4:        0.92         4.66
#>   5:        0.92         4.66
#>  ---                         
#> 136:        0.92         4.62
#> 137:        0.92         4.64
#> 138:        0.92         4.64
#> 139:        0.92         4.64
#> 140:        0.92         4.63
```

## sessionInfo

``` r
sessionInfo()
#> R version 4.4.2 (2024-10-31)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.1 LTS
#> 
#> Matrix products: default
#> BLAS/LAPACK: /usr/lib/x86_64-linux-gnu/libmkl_rt.so;  LAPACK version 3.8.0
#> 
#> locale:
#>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
#>  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
#>  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
#> [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
#> 
#> time zone: Asia/Shanghai
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] faers_1.1.7
#> 
#> loaded via a namespace (and not attached):
#>  [1] Matrix_1.7-1        bit_4.0.5           gtable_0.3.6       
#>  [4] dplyr_1.1.4         compiler_4.4.2      crayon_1.5.3       
#>  [7] tidyselect_1.2.1    MatrixModels_0.5-3  parallel_4.4.2     
#> [10] scales_1.4.0        splines_4.4.2       BiocParallel_1.38.0
#> [13] yaml_2.3.10         fastmap_1.2.0       lattice_0.22-6     
#> [16] coda_0.19-4.1       R6_2.6.1            ggplot2_4.0.0      
#> [19] generics_0.1.3      MCMCpack_1.7-0      knitr_1.50         
#> [22] MASS_7.3-61         tibble_3.2.1        openEBGM_0.9.1     
#> [25] RColorBrewer_1.1-3  pillar_1.9.0        tzdb_0.4.0         
#> [28] rlang_1.1.6         utf8_1.2.5          xfun_0.52          
#> [31] S7_0.2.0            bit64_4.0.5         cli_3.6.5          
#> [34] magrittr_2.0.3      mcmc_0.9-8          digest_0.6.37      
#> [37] grid_4.4.2          vroom_1.6.5         quantreg_5.99.1    
#> [40] lifecycle_1.0.4     vctrs_0.6.5         evaluate_1.0.3     
#> [43] SparseM_1.84-2      glue_1.8.0          data.table_1.16.99 
#> [46] farver_2.1.2        codetools_0.2-20    survival_3.7-0     
#> [49] fansi_1.0.6         rmarkdown_2.29      tools_4.4.2        
#> [52] pkgconfig_2.0.3     htmltools_0.5.8.1
```

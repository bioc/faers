% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/phv_.R
\name{phv_signal}
\alias{phv_signal}
\alias{phv_ror}
\alias{phv_prr}
\alias{phv_chisq}
\alias{phv_fisher}
\alias{phv_bcpnn_norm}
\alias{phv_bcpnn_mcmc}
\alias{phv_obsexp_shrink}
\alias{phv_ebgm}
\title{Pharmacovigilance Analysis}
\usage{
phv_signal(
  a,
  b,
  c,
  d,
  methods = NULL,
  alpha = 0.05,
  correct = TRUE,
  n_mcmc = 100000L,
  alpha1 = 0.5,
  alpha2 = 0.5,
  theta_init = NULL,
  squashing = TRUE,
  BPPARAM = SerialParam()
)

phv_ror(a, b, c, d, alpha = 0.05)

phv_prr(a, b, c, d, alpha = 0.05)

phv_chisq(a, b, c, d, correct = TRUE, BPPARAM = SerialParam())

phv_fisher(a, b, c, d, alpha = 0.05, BPPARAM = SerialParam())

phv_bcpnn_norm(a, b, c, d, alpha = 0.05)

phv_bcpnn_mcmc(
  a,
  b,
  c,
  d,
  alpha = 0.05,
  n_mcmc = 100000L,
  BPPARAM = SerialParam()
)

phv_obsexp_shrink(
  a,
  b,
  c,
  d,
  alpha = 0.05,
  alpha1 = 0.5,
  alpha2 = 0.5,
  n_mcmc = 100000L,
  BPPARAM = SerialParam()
)

phv_ebgm(a, b, c, d, alpha = 0.05, theta_init = NULL, squashing = TRUE)
}
\arguments{
\item{a}{also referred to as \code{n11} as this is the count of event of interest
under exposure of interest.}

\item{b}{also referred to as \code{n10} as this is the count of \emph{not} event
of interest under exposure of interest.}

\item{c}{also referred to as \code{n01} as this is the count of event of interest
under \emph{not} exposure of interest.}

\item{d}{also referred to as \code{n00} as this is the count of \emph{not} event
of interest under \emph{not} exposure of interest.}

\item{methods}{An atomic character, specifies the method used to signal
mining. Currently, only "ror", "prr", "chisq", "bcpnn_norm", "bcpnn_mcmc",
"obsexp_shrink", "fisher", and "ebgm" are supported. If \code{NULL}, all supported
methods will be used.}

\item{alpha}{Level of significance, for construction of the confidence
intervals.}

\item{correct}{A bool indicating whether to apply Yates's continuity
correction when computing the chi-squared statistic.}

\item{n_mcmc}{Number of MCMC simulations per \verb{(a,b,c,d)}-tuple to calculate
confidence intervals.}

\item{alpha1}{Numerator shrinkage parameter \verb{>=0}, default \code{0.5}.}

\item{alpha2}{Denominator shrinkage parameter \verb{>=0}, default \code{0.5}.}

\item{theta_init}{A data frame of initial hyperparameter guesses with columns
ordered as:\verb{ alpha1, beta1, alpha2, beta2, P}. See \link[openEBGM:autoHyper]{openEBGM::autoHyper}}

\item{squashing}{A bool, whether do automated data squashing. If any zeros
found in \code{a}, will always be \code{TRUE}.}

\item{BPPARAM}{An optional \code{\link[BiocParallel]{BiocParallelParam}} instance
    defining the parallel back-end to be used during evaluation.
  }
}
\value{
A \link[data.table:data.table]{data.table} with columns of estimated
value and it's confidence interval (\code{ci_low} and \code{ci_high}). Estimated column
are as follows:
\itemize{
\item \code{phv_ror}: reporting odds ratio (\code{ror}).
\item \code{phv_prr}: proportional reporting ratio (\code{prr}). Signal defined as a \code{prr}
of at least 2, chi-squared with Yates's correction of at least 4 and \code{a >= 3}. An equivalent alternative to chi-squared is to calculate a confidence
interval around the \code{prr}.
\item \code{phv_bcpnn_norm}: information component (\code{ic}).
\item \code{phv_bcpnn_mcmc}: information component (\code{ic}).
\item \code{phv_obsexp_shrink}: observed to expected ratio (\code{oe_ratio}).
\item \code{phv_ebgm}: Empirical Bayes Geometric Mean (\code{ebgm}).
}
}
\description{
Pharmacovigilance, also known as drug safety. In the context of
pharmacovigilance studies, disproportionality analysis primarily served as a
tool to evaluate possible association between a specific adverse event and a
particular drug which can then be investigated through clinical assessment of
individual case reports.
}
\details{
Note that the \code{a}, \code{b}, \code{c}, \code{d} inputs can be an atomic vectors of equal
length, for which the function will perform the calculations for each
individual \verb{(a,b,c,d)}-tuple moving across the vectors.

It is assumed that the contingency table under consideration has
drugs/exposures in the rows and outcomes/events in the columns. See
contingency table section.

We use the \code{distinct} patient count method to obtain the frequency counts of
patients exposed to each interested drug, those reporting interested event.
As illustrated in the Contingency table, \code{n} equals the total number of
patients in the database, \code{n11} is the number of patients with exposure to
the interested drug during the model period and reporting interested events,
\code{n10} is the number of patients that have used the interested drug but did
not experience interested event during any of the model periods associated
with the drug, \code{n01} is the number of patients that did not use the
interested drug but experienced interested event, and \code{n00} is the number of
patients that were not exposed to the interested drug and did not report
interested condition.
}
\section{Contingency table}{
\tabular{llll}{
    \tab ADR of interest \tab Other ADRs \tab Total \cr
   Drug of interest \tab a=n11 \tab b=n10 \tab a+b=n1. \cr
   Other drugs \tab c=n01 \tab d=n00 \tab c+d=n0. \cr
   Total \tab a+c=n.1 \tab b+d=n.0 \tab a+b+c+d=n \cr
}
}

\section{phv_obsexp_shrink}{


The observed to expected (OE) ratio with approximate confidence intervals are
constructed on the log2 scale as outlined in Norén et al. (2013).

Expected value was estimated by \code{(a + b) / (a + b + c + d) * (a + c)}.

The OE ratio with shrinkage estimates is calculated as \code{(O + alpha1) / (E + alpha2)}.

If \code{(O + alpha1) < 1}, then the exact uncertainty limits should be used. That
is the confidence intervals as implemented in \code{phv_bcpnn_mcmc} (Norén et al.,
2013).

\code{log2(OE)} approximates the Bayesian confidence propagation neural
network information component (IC) with reasonable accuracy when \code{alpha1 = alpha2 = 0.5} (Norén et al., 2013).
}

\section{phv_ebgm}{

An implementation of the Gamma-Poisson Shrinker (GPS) model for identifying
unexpected counts in large contingency tables using an empirical Bayes
approach. The Empirical Bayes Geometric Mean (EBGM) and quantile scores are
obtained from the GPS model estimates.
The GPS was proposed by DuMouchel as a signal detection tool for large
frequency tables with both observed (O) and expected (E) counts for each
drug-outcome pair. It assumes the observed count of any drug-outcome pair
follows the Poisson distribution.

For each drug-outcome pair, the primary parameter of interest was the risk
ratio. Rather than using the observed over expected (O/E), GPS uses the
empirical Bayesian geometric mean (EBGM) posterior distribution of the risk
ratio and the surrounding confidence interval for each drug-outcome pair to
identify statistical signals of excess risk. To prevent spurious false
positives due to implausibly high risk ratios, GPS implements a Bayesian
framework that “shrinks” O/E estimates towards a value which is close to the
average O/E values for all drug-event pairs at each level of granularity.
}

\examples{
phv_signal(122, 1320, 381, 31341)
phv_signal(122, 1320, 381, 31341, "ror")
phv_ror(122, 1320, 381, 31341)
phv_signal(122, 1320, 381, 31341, "prr")
phv_prr(122, 1320, 381, 31341)
phv_signal(122, 1320, 381, 31341, "chisq")
phv_chisq(122, 1320, 381, 31341)
phv_signal(122, 1320, 381, 31341, "bcpnn_norm")
phv_bcpnn_norm(122, 1320, 381, 31341)
phv_signal(122, 1320, 381, 31341, "bcpnn_mcmc")
phv_bcpnn_mcmc(122, 1320, 381, 31341)
phv_signal(122, 1320, 381, 31341, "obsexp_shrink")
phv_obsexp_shrink(122, 1320, 381, 31341)
phv_signal(122, 1320, 381, 31341, "fisher")
phv_fisher(122, 1320, 381, 31341)
phv_signal(122, 1320, 381, 31341, "ebgm")
phv_ebgm(122, 1320, 381, 31341)
}
\references{
\itemize{
\item David Olaleye, SAS Institute Inc. (2019), Real-World Evidence and
Population Health Analytics: Intersection and Application,
\url{https://support.sas.com/resources/papers/proceedings19/3361-2019.pdf}
}

\itemize{
\item Evans, S.J.W., Waller, P.C. and Davis, S. (2001), Use of proportional
reporting ratios (PRRs) for signal generation from spontaneous adverse drug
reaction reports. Pharmacoepidem. Drug Safe., 10: 483-486.
\url{https://doi.org/10.1002/pds.677}
}

\itemize{
\item Norén GN, Hopstadius J, Bate A. Shrinkage observed-to-expected ratios for
robust and transparent large-scale pattern discovery.  Statistical methods
in medical research. 2013 Feb;22(1):57-69.
}

\itemize{
\item \url{https://journal.r-project.org/archive/2017/RJ-2017-063/RJ-2017-063.pdf}
}
}

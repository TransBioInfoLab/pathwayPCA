% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/superPC_optimWeibullParams.R
\name{OptimGumbelMixParams}
\alias{OptimGumbelMixParams}
\title{Calculate the optimal parameters for a mixture of Weibull Extreme Value
   Distributions for supervised PCA}
\usage{
OptimGumbelMixParams(max_tControl_vec, pathwaySize_vec, initialVals = c(p
  = 0.5, mu1 = 1, s1 = 0.5, mu2 = 1, s2 = 0.5), optimMethod = "L-BFGS-B",
  lowerBD = c(0, -Inf, 0, -Inf, 0), upperBD = c(1, Inf, Inf, Inf, Inf))
}
\arguments{
\item{max_tControl_vec}{A vector of the maximum absolute \eqn{t}-scores for
each pathway (returned by the \code{\link{pathway_tControl}} function)
when under the null model. Under the null model, the response vector will
have been randomly generated or parametrically bootstrapped.}

\item{pathwaySize_vec}{A vector of the number of genes in each pathway.}

\item{initialVals}{A named vector of initial values for the Weibull
parameters. The values are
\itemize{
  \item{\eqn{p} : }{The mixing proportion between the Gumbel minimum and
     Gumbel maximum distributions. This parameter is bounded by
     \eqn{[0, 1]} and defaults to 0.5.}
  \item{\eqn{\mu_1} : }{The mean of the first distribution. This parameter
     is unbounded and defaults to 1.}
  \item{\eqn{s_1} : }{The precision of the first distribution. This
     parameter is bounded below by 0 and defaults to 0.5.}
  \item{\eqn{\mu_2} : }{The mean of the second distribution. This parameter
     is unbounded and defaults to 1.}
  \item{\eqn{s_2} : }{The precision of the second distribution. This
     parameter is bounded below by 0 and defaults to 0.5.}
}}

\item{optimMethod}{Which numerical optimization routine to pass to the
\code{\link[stats]{optim}} function. Defaults to \code{"L-BFGS-B"}, which
allows for lower and upper bound constraints. When this option is
specified, lower and upper bounds for ALL parameters must be supplied.}

\item{lowerBD}{A vector of the lower bounds on the \code{initialVals}.
Defaults to \code{c(0, -Inf, 0, -Inf, 0)}.}

\item{upperBD}{A vector of the upper bounds on the \code{initialVals}.
Defaults to \code{c(1, Inf, Inf, Inf, Inf)}.}
}
\value{
A named vector of the estimated values for the parameters which
   minimize the negative log-likelihood of the mixture Weibull Extreme Value
   distributions.
}
\description{
Calculate the parameters which minimise the negative log-
   likelihood of a mixture of two Weibull Extreme Value distributions.
}
\details{
The likelihood function is equation (4) in Chen et al (2008): a
   mixture of two Gumbel Extreme Value probability density functions, with
   mixing proportion \eqn{p}. Within the code of this function, the values
   \code{mu1}, \code{mu2} and \code{s1}, \code{s2} are placeholders for the
   mean and precision, respectively.

   A computational note: the \code{"L-BFGS-B"} option within the
   \code{\link[stats]{optim}} function requires a bounded function or
   likelihood. We therefore replaced \code{Inf} with \code{10 ^ 200} in the
   check for boundedness. As we are attempting to minimise the negative log-
   likelihood, this maximum machine value is effectively \code{+Inf}.

   See \url{https://doi.org/10.1093/bioinformatics/btn458} for more
   information.
}
\examples{
  # DO NOT CALL THIS FUNCTION DIRECTLY.
  # Use SuperPCA_pVals() instead.

\dontrun{
  ###  Load the Example Data  ###
  data("colon_pathwayCollection")


  ###  Simulate Maximum Absolute Control t-Values  ###
  # The SuperPCA algorithm defaults to 20 threshold values; the example
  #   pathway collection has 15 pathways.
  t_mat <- matrix(rt(15 * 20, df = 5), nrow = 15)

  absMax <- function(vec){
    vec[which.max(abs(vec))]
  }
  tAbsMax_num <- apply(t_mat, 1, absMax)


  ###  Calculate Optimal Parameters for the Gumbel Distribution  ###
  OptimGumbelMixParams(
    max_tControl_vec = tAbsMax_num,
    pathwaySize_vec = lengths(colon_pathwayCollection$pathways)
  )
}

}
\seealso{
\code{\link[stats]{optim}}; \code{\link{GumbelMixpValues}};
   \code{\link{pathway_tControl}}; \code{\link{SuperPCA_pVals}}
}
\keyword{internal}

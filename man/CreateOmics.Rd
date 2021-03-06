% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/createOmics_Wrapper.R
\name{CreateOmics}
\alias{CreateOmics}
\title{Generation Wrapper function for \code{-Omics*}-class objects}
\usage{
CreateOmics(assayData_df, pathwayCollection_ls, response = NULL,
  respType = c("none", "survival", "regression", "categorical"),
  centerScale = c(TRUE, TRUE), minPathSize = 3, ...)
}
\arguments{
\item{assayData_df}{An \eqn{N \times p} data frame with named columns.}

\item{pathwayCollection_ls}{A \code{pathwayCollection} list of known gene
pathways with two or three elements:
\itemize{
  \item{\code{pathways} : }{A named list of character vectors. Each vector
     contains the names of the individual genes within that pathway as a
     vector of character strings. The names contained in these vectors must
     have non-empty overlap with the \emph{column names} of the
     \code{assayData_df} data frame. The names of the pathways (the list
     elements themselves) should be the a shorthand representation of the
     full pathway name.}
  \item{\code{TERMS}: }{ A character vector the same length as the
     \code{pathways} list with the proper names of the pathways.}
  \item{\code{description} : }{An optional character vector the same length
     as the \code{pathways} list with additional information about the
     pathways.}
}
If your gene pathways list is stored in a \code{.gmt} file, use the
\code{\link{read_gmt}} function to import your pathways list as a
\code{pathwayCollection} list object.}

\item{response}{An optional response object. See "Details" for more
information. Defaults to \code{NULL}.}

\item{respType}{What type of response has been supplied. Options are
\code{"none"}, \code{"survival"}, \code{"regression"}, and
\code{"categorical"}. Defaults to \code{"none"} to match the default
\code{response = NULL} value.}

\item{centerScale}{Should the values in \code{assayData_df} be centered and
scaled? Defaults to \code{TRUE} for centering and scaling, respectively.
See \code{\link{scale}} for more information.}

\item{minPathSize}{What is the smallest number of genes allowed in each
pathway? Defaults to 3.}

\item{...}{Dots for additional arguments passed to the internal
\code{\link{CheckAssay}} function.}
}
\value{
A valid object of class \code{OmicsPathway}, \code{OmicsSurv},
  \code{OmicsReg}, or \code{OmicsCateg}.
}
\description{
This function calls the \code{\link{CreateOmicsPath}},
   \code{\link{CreateOmicsSurv}}, \code{\link{CreateOmicsReg}}, and
   \code{\link{CreateOmicsCateg}} functions to create valid objects of the
   classes \code{OmicsPathway}, \code{OmicsSurv}, \code{OmicsReg}, or
   \code{OmicsCateg}, respectively.
}
\details{
This function is a wrapper around the four \code{CreateOmics*}
   functions. The values supplied to the \code{response} function argument
   can be in a list, data frame, matrix, vector, \code{\link[survival]{Surv}}
   object, or any class which extends these. Because this function makes
   "best guess" type conversions based on the \code{respType} argument, this
   argument is mandatory if \code{response} is non-\code{NULL}. Further, it
   is the responsibility of the user to ensure that the coerced response
   contained in the resulting \code{Omics} object accurately reflects the
   supplied response.

   For \code{respType = "survival"}, \code{response} is assumed to be ordered
   by event time, then event indicator. For example, if the response is a
   data frame or matrix, this function assumes that the first column is the
   time and the second column the death indicator. If the response is a list,
   then this function assumes that the first entry in the list is the event
   time and the second entry the death indicator. The death indicator must
   be a logical or binary (0-1) vector, where 1 or \code{TRUE} represents a
   death and 0 or \code{FALSE} represents right-censoring.

   Some of the pathways in the supplied pathways list will be removed, or
   "trimmed", during object creation. For the pathway-testing methods, these
   trimmed pathways will have \eqn{p}-values given as \code{NA}. For an
   explanation of pathway trimming, see the documentation for the
   \code{\link{IntersectOmicsPwyCollct}} function.
}
\examples{
  ###  Load the Example Data  ###
  data("colonSurv_df")
  data("colon_pathwayCollection")

  ###  Create an OmicsPathway Object  ###
  colon_OmicsPath <- CreateOmics(
    assayData_df = colonSurv_df[, -(2:3)],
    pathwayCollection_ls = colon_pathwayCollection
  )

  ###  Create an OmicsSurv Object  ###
  colon_OmicsSurv <- CreateOmics(
    assayData_df = colonSurv_df[, -(2:3)],
    pathwayCollection_ls = colon_pathwayCollection,
    response = colonSurv_df[, 1:3],
    respType = "surv"
  )

  ###  Create an OmicsReg Object  ###
  colon_OmicsReg <- CreateOmics(
    assayData_df = colonSurv_df[, -(2:3)],
    pathwayCollection_ls = colon_pathwayCollection,
    response = colonSurv_df[, 1:2],
    respType = "reg"
  )

  ###  Create an OmicsCateg Object  ###
  colon_OmicsCateg <- CreateOmics(
    assayData_df = colonSurv_df[, -(2:3)],
    pathwayCollection_ls = colon_pathwayCollection,
    response = colonSurv_df[, c(1,3)],
    respType = "cat"
  )

}
\seealso{
\code{\link[=OmicsPathway-class]{OmicsPathway}},
   \code{\link{CreateOmicsPath}},
   \code{\link[=OmicsSurv-class]{OmicsSurv}},
   \code{\link{CreateOmicsSurv}},
   \code{\link[=OmicsCateg-class]{OmicsCateg}},
   \code{\link{CreateOmicsCateg}}
   \code{\link[=OmicsReg-class]{OmicsReg}},
   \code{\link{CreateOmicsReg}},
   \code{\link{CheckAssay}},
   \code{\link{CheckPwyColl}}, and
   \code{\link{IntersectOmicsPwyCollct}}
}

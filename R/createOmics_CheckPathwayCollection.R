#' Check an Input Pathway Collection
#'
#' @description Check the class and names of a \code{pathwayCollection} object.
#'    Add or fix names as appropriate. Add the \code{setsize} vector to the
#'    object.
#'
#' @param pwyColl_ls A pathway collection supplied to the
#'    \code{\link{CreateOmics}} function
#'
#' @return The same pathway collection, but with names modified as described in
#'    "Details" and the number of genes per pathway as the \code{setsize}
#'    element of the collection object.
#'
#' @details If there are no names, create them. If there are missing names,
#'    label them. If there are duplicated names (because R is stupid and allows
#'    duplicate element names in a list---but not a data frame!), then use the
#'    \code{data.frame} name rule to append a period followed by integers to
#'    the end of the name string.
#'
#'    Notes: if the supplied \code{pathways} object within your \code{pwyColl_ls}
#'    list has no names, then this pathway list will be named \code{path1},
#'    \code{path2}, \code{path3}, ...; if any of the pathways are missing names,
#'    then the missing pathways will be named \code{noName} followed by the
#'    index of the pathway. For example, if the 112th pathway in the
#'    \code{pathways} list has no name (but other pathways do), then this
#'    pathway will be named \code{noName112}. Furthermore, if any of the pathway
#'    names are duplicated, then the duplicates will have \code{.1}, \code{.2},
#'    \code{.3}, ... appended to the duplicate names until all pathway names are
#'    unique. Once all pathways have been verified to have unique names, then
#'    the pathway names are attached as attributes to the \code{TERMS} and
#'    \code{setsize} vectors (the \code{setsize} vector is calculated at object
#'    creation).
#'
#' @keywords internal
#'
#'
#' @examples
#'  # DO NOT CALL THIS FUNCTION DIRECTLY. CALL FROM WITHIN CreateOmics().
#'
#' \dontrun{
#'   data("colon_pathwayCollection")
#'   CheckPwyColl(colon_pathwayCollection)
#' }
#'
CheckPwyColl <- function(pwyColl_ls){
  # browser()

  ###  Class Check  ###
  if(!("pathwayCollection" %in% class(pwyColl_ls))){
    stop(
  "The pathwayCollection_ls object must be or extend class pathwayCollection.
To import a .gmt file into R as a pathwayCollection object, please use the
read_gmt() function. To create a pathwayCollection object directly, please use
the CreatePathwayCollection() function."
    )
  }

  ###  Pathway Names  ###
  # If there are no names, create them. If there are missing names, label them.
  #   If there are duplicated names (because R is stupid and allows duplicate
  #   element names in a list -- but not a data frame!), then use the data.frame
  #   name rule to append a period then integers to the end of the name string.
  if(is.null(names(pwyColl_ls$pathways))){

    pathNames <- paste0("path", seq_len(length(pwyColl_ls$pathways)))
    names(pwyColl_ls$pathways) <- pathNames

  } else if(anyNA(names(pwyColl_ls$pathways))){

    missingNm_idx <- which(is.na(names(pwyColl_ls$pathways)))
    names(pwyColl_ls$pathways)[missingNm_idx] <-
      paste0("noName", missingNm_idx)
    pathNames <- names(pwyColl_ls$pathways)

  } else {
    pathNames <- names(pwyColl_ls$pathways)
  }

  if(anyDuplicated(names(pwyColl_ls$pathways))){

    shortSet_df <- data.frame(
      lapply(pwyColl_ls$pathways, "length<-", 1)
    )
    pathNames <- names(shortSet_df)
    names(pwyColl_ls$pathways) <- pathNames

  }

  ###  Pathway Name Key  ###
  # Add Name Key to TERMS and setsize
  pwyColl_ls$setsize <- lengths(pwyColl_ls$pathways)
  names(pwyColl_ls$TERMS) <- pathNames
  names(pwyColl_ls$setsize) <- pathNames

  ###  Return  ###
  pwyColl_ls

}

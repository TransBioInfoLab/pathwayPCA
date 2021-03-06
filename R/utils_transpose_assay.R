#' Transpose an Assay (Data Frame)
#'
#' @description Transpose an object of class \code{data.frame} that contains
#'    assay measurements while preserving row (feature) and column (sample)
#'    names.
#'
#' @param assay_df A data frame with numeric values to transpose
#' @param omeNames Are the data feature names in the first column or in the row
#'    names of \code{df}? Defaults to the first column. If the feature names
#'    are in the row names, this function assumes that these names are accesible
#'    by the \code{\link{rownames}} function called on \code{df}.
#' @param stringsAsFactors Should columns containing string information be
#'    coerced to factors? Defaults to \code{FALSE}.
#'
#' @details This function is designed to transpose "tall" assay data frames
#'    (where genes or proteins are the rows and patient or tumour samples are
#'    the columns). This function also transposes the row (feature) names to
#'    column names and the column (sample) names to row names. Notice that all
#'    rows and columns (other than the feature name column, as applicable) are
#'    numeric.
#'
#'    Recall that data frames require that all elements of a single column to
#'    have the same \code{\link{class}}. Therefore, sample IDs of a "tall" data
#'    frame \strong{must} be stored as the column names rather than in the
#'    first row.
#'
#' @return The transposition of \code{df}, with row and column names preserved
#'    and reversed.
#'
#' @export
#'
#' @examples
#'    x_mat <- matrix(rnorm(5000), ncol = 20, nrow = 250)
#'    rownames(x_mat) <- paste0("gene_", 1:250)
#'    colnames(x_mat) <- paste0("sample_", 1:20)
#'    x_df <- as.data.frame(x_mat, row.names = rownames(x_mat))
#'
#'    TransposeAssay(x_df, omeNames = "rowNames")
#'
TransposeAssay <- function(assay_df,
                           omeNames = c("firstCol", "rowNames"),
                           stringsAsFactors = FALSE){

  omeNames <- match.arg(omeNames)

  if(omeNames == "firstCol"){

    featureNames_vec <- assay_df[, 1, drop = TRUE]
    sampleNames_vec <- colnames(assay_df)[-1]

    transpose_df <- as.data.frame(
      t(assay_df[, -1]),
      stringsAsFactors = stringsAsFactors
    )
    rownames(transpose_df) <- NULL

    colnames(transpose_df) <- featureNames_vec

    sampleNames_df <- data.frame(
      Sample = sampleNames_vec,
      stringsAsFactors = stringsAsFactors
    )
    transpose_df <- cbind(sampleNames_df, transpose_df)

  } else {

    featureNames_vec <- rownames(assay_df)
    sampleNames_vec <- colnames(assay_df)

    transpose_df <- as.data.frame(
      t(assay_df),
      stringsAsFactors = stringsAsFactors
    )

    colnames(transpose_df) <- featureNames_vec
    rownames(transpose_df) <- sampleNames_vec

    }

  class(transpose_df) <- class(assay_df)
  transpose_df

}

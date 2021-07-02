#' Standardize Matrix
#'
#' @param mat matrix
#'
#' @return matrix with same dimensions as mat
#' @export
#'
#' @examples
#' set.seed(1)
#' mat <- matrix(runif(16), 4, 4)
#' std_mat <- standardize_mat(mat)
standardize_mat <- function(mat){
  apply(mat, MARGIN = 2, function(x){
    (x - mean(x))/sd(x)
  })
}

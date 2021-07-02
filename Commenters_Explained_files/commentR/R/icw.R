#' Inverse Covariance Weighting
#'
#' @param mat matrix
#' @param reverse column numbers to reverse. Default is NULL.
#' @param standardize Boolean to standardize columns. Default is TRUE.
#'
#' @return
#' @export
#'
#' @examples
#' set.seed(1)
#' mat <- matrix(rnorm(100), ncol = 5)
#' icw(mat)
icw <- function(mat, reverse = NULL, standardize = TRUE){
  if(standardize){
    mat <- standardize_mat(mat)
  }
  
  if(!is.null(reverse)){
    mat[,reverse] <-  -1*mat[,reverse]
  }
  
  one_vec <- as.matrix(rep(1,ncol(mat)))
  cov_wts_mat <- cov.wt(mat, wt = rep(1, nrow(mat)))[[1]]
  
  weights <- solve(t(one_vec)%*%solve(cov_wts_mat)%*%one_vec)%*%t(one_vec)%*%solve(cov_wts_mat)
  index <- t(solve(t(one_vec)%*%solve(cov_wts_mat)%*%one_vec)%*%t(one_vec)%*%solve(cov_wts_mat)%*%t(mat))
  
  return(list(weights = weights, index = index))
}

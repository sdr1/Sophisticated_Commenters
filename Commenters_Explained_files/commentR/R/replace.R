#' Replace Colon in Start of Comments
#'
#' @param comment character vector of comments
#' @param n default = 100. checks the first n characters. Set to negative values 
#' to check the entire comment 
#' @param replace character to replace ':' with. Default is '.' 
#' @return
#' @export
#'
#' @examples
#' set.seed(1)
#' comms <- lapply(1:10, function(x){paste0(sample(c(LETTERS, ':'), size = 20, replace = TRUE), collapse = '')})
#' comms <- unlist(comms)
#' replace_colon(comms)
#' replace_colon(comms, n = 1)
#' replace_colon(comms, n = 0)
#' replace_colon(comms, n = 5)
replace_colon <- function(comment, n = 100, replace = '.'){
  if(missing(comment)){
    stop('Input `comment` missing in function `replace_colon`.')
  }
  
  if(!is.numeric(n)){
    stop('Input `n` in function `replace_colon` must be numeric.')
  }
  
  if(n < 0){
    stringr::str_replace_all(comment, ':', replace)
  } else if(n == 0){
    comment
  } else {
    comment_p1 <- stringr::str_sub(comment, end = n)
    comment_p2 <- stringr::str_sub(comment, start = n + 1)
    comment_p1 <- stringr::str_replace_all(comment_p1, ':', replace)
    stringr::str_c(comment_p1, comment_p2)
  }
}



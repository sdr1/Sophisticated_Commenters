#' Drop First Part of Comments
#'
#' @param comment character vector of comments
#' @param n default = 100. number of characters to drop.
#'
#' @return string vector
#' @export
#'
#' @examples
#' set.seed(1)
#' comms <- lapply(1:10, function(x){paste0(sample(LETTERS, size = 5, replace = TRUE), collapse = '')})
#' comms <- unlist(comms)
#' drop_first(comms, n = 2)
#' drop_first(comms, n = 6)
drop_first <- function(comment, n = 100){
  if(missing(comment)){
    stop('Input `comment` missing in function `drop_first`.')
  }
  
  stringr::str_sub(comment, start = n + 1)
}


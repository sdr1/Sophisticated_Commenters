#' Detect Comment Headers
#' 
#' Attempts to identify if a comment has a header by checking for certain phrases
#' at the start of a comment. Phrases and first n characters of a comment are 
#' converted to lower case.
#'
#' @param comment 
#' @param n default = 100. checks the first n characters. Set to negative values or 0 
#' to check the entire comment 
#' @param phrases character vector of phrases to check for. Default is c('name', 'date', 'email')
#'
#' @return Logical vector of length comment
#' @export
#'
#' @examples
#' comms <- c('Name: Chris R is fun', 'Magrittr pipe is better than base pipe.',
#' 'Date: 06/05/21 I love tibbles.')
#' detect_header(comms)
detect_header <- function(comment, n = 100, phrases = c('name', 'date', 'email')){
  if(missing(comment)){
    stop('Input `comment` missing in function `replace_colon`.')
  }
  
  if(!is.numeric(n)){
    stop('Input `n` in function `replace_colon` must be numeric.')
  }
  
  if(n < 1){
    stringr::str_detect(comment, phrases)
  } else {
    comment_p1 <- stringr::str_to_lower(stringr::str_sub(comment, end = n))
    checks <- lapply(seq_len(length(phrases)), function(x){    
      stringr::str_detect(comment_p1, stringr::str_to_lower(phrases[x]))
      })
    checks <- do.call('cbind', checks)
    apply(checks, 1, any)
  }
}
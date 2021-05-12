library(tidyverse)
library(dplyr)
library(rvest)
# Oxford Finance Dictionary 
# https://www.oxfordreference.com/view/10.1093/acref/9780199229741.001.0001/acref-9780199229741?btog=chap&hide=true&page=262&pageSize=20

# Get finance terms 

# Oxford 4th edition
# urls <- c("https://www.oxfordreference.com/view/10.1093/acref/9780199229741.001.0001/acref-9780199229741?btog=chap&hide=true&pageSize=20&skipEditions=true&sort=titlesort&source=%2F10.1093%2Facref%2F9780199229741.001.0001%2Facref-9780199229741",
# c(paste0("https://www.oxfordreference.com/view/10.1093/acref/9780199229741.001.0001/acref-9780199229741?btog=chap&hide=true&page=",
#          2:263, "&pageSize=20")))

urls <- c("https://www.oxfordreference.com/view/10.1093/acref/9780199664931.001.0001/acref-9780199664931?btog=chap&hide=true&pageSize=20&skipEditions=true&sort=titlesort&source=%2F10.1093%2Facref%2F9780199664931.001.0001%2Facref-9780199664931",
          c(paste0("https://www.oxfordreference.com/view/10.1093/acref/9780199664931.001.0001/acref-9780199664931?btog=chap&hide=true&page=",
                   2:263, "&pageSize=20")))

OED_Finance <- tibble()

i = 1
for(url in urls){
  
  cat(i, url, sep = "\n")
  
  i = i + 1
  
  raw_page_html <- url %>%
    xml2::read_html()
  
  terms <- raw_page_html %>%
    html_nodes(".itemTitle") %>%
    html_text() %>%
    tibble() %>%
    rename(terms = ".") %>%
    mutate(terms = gsub(pattern = "\\n|\\t", replacement = "", x = terms))
  
  OED_Finance <- dplyr::bind_rows(OED_Finance, terms)
  
  Sys.sleep(max(30, rnorm(n = 1, mean = 60, sd = 20)))
  
}

save(OED_Finance, file = "/Users/stevenrashin/Dropbox/Fake Comments/Data/OED_Finance_5thed.RData")
### Bluebooking Regex ###
library(tidyverse)
library(quanteda)
library(ggforce)
library(grid)
library(gridExtra)
library(DBI)
library(RSQLite)
library(magrittr)

setwd("/Users/stevenrashin/Documents/GitHub/Sophisticated_Commenters/")

master_location <- "/Users/stevenrashin/Dropbox/FINREG-RULEMAKE/attachments.sqlite"
con = dbConnect(SQLite(), dbname=master_location)
alltables = dbListTables(con)
alltables
myQuery <- dbSendQuery(con, "SELECT * FROM attachments")
attachments <- dbFetch(myQuery, n = -1)
attachments <- attachments %>% tibble()

#########################################
# Citations  Lawyers would use based on #
#########################################

# Bluebook style for US code, Supreme Court, and Appeals and District Courts
# https://guides.ll.georgetown.edu/c.php?g=261289&p=2339383

# A list of all legal citations
# https://gist.github.com/mlissner/dda7f6677b98b98f54522e271d486781

# Bluebook for CFR and Federal Register  
# https://www.law.cornell.edu/citation/2-400#:~:text=Principle%201%3A%20The%20core%20of,followed%20by%20a%20space%20%C2%ABe.g.%C2%BB

US_Code_Regex <- "\\d{1,2}\\s{0,1}[Uu]\\.{0,1}[Ss]\\.{0,1}[Cc]\\.{0,1}\\s{0,}\\§{0,1}\\s{0,}\\d{1,}(\\s{0,}\\(\\d{4}\\))?"
Supreme_Court_Cases <- "[A-z]{3,}(\\.)?\\s{1,}v\\.{0,1}\\s{1,}[A-z]{3,}(,)?\\s{1,}\\d{1,}\\s{1,}[Uu]\\.{0,1}\\s{0,}[Ss]\\.{0,1}"
Appeals_and_District_Court_Cases <- "[A-z]{3,}(\\.)?\\s{1,}v\\.{0,1}\\s{1,}[A-z]{3,}(,)?\\s{1,}\\d{1,}\\s{1,}[Ff]"
Code_of_Federal_Regulations <- "\\d{1,}\\s{0,}[Cc].{0,1}\\s{0,}[Ff].{0,1}\\s{0,}[Rr].{0,1}\\s{0,}\\§{0,1}\\s{0,}\\d{1,}" 
Federal_Register <- "\\d{1,}\\s{0,}Fed\\.{0,1}\\s{1,}Reg\\.{0,1}\\s{0,}\\d{1,}"

# Show Regex Works 

# US Code Regex - Permissible 
str_count(string =  "14 USC § 25, 14 USC 25, 14 U.S.C. 25, 14 USC 25 (2005), 
          14 U.SC 25, 14USC25", 
          pattern = US_Code_Regex)

# Supreme Court
str_count(string =  "Roe v. Wade, 410 U.S. 113, 164 (1973), 
          Roe v. Wade, 410 U.S. 113,
          Roe v Wade, 410 U.S. 113,
          Roe v Wade 410 U.S. 113,
          Roe v Wade 410 US 113",
          pattern = Supreme_Court_Cases)

str_count(string =  "Universal City Studios, Inc. v. Corley, 273 F.3d 429 (2d Cir. 2001),
          Universal City Studios, Inc. v. Corley, 273 F.3d 429,
          Universal City Studios, Inc. v. Corley, 273 F.d 429,
          Universal City Studios, Inc. v. Corley, 273 F.", 
          pattern = Appeals_and_District_Court_Cases)

str_count(string =  "20 C.F.R. § 404.260,
          20 C.F.R. § 404,
          20 CFR § 404.260
          20 CFR § 404", 
          pattern = Code_of_Federal_Regulations)

str_count(string =  "59 Fed. Reg. 4233,
          59 Fed. Reg. 4233", 
          pattern = Federal_Register)

# show random examples in practice
show_regex_works <- function(pattern, num_to_print){
  FR <- str_count(string = attachments$attachment_text, pattern = pattern)
  return(str_match_all(string = attachments$attachment_text[which(FR>0)], 
                pattern = pattern) %>%
    sample(num_to_print,replace = F))
}

show_regex_works(US_Code_Regex, 5)
show_regex_works(Supreme_Court_Cases, 5)
show_regex_works(Appeals_and_District_Court_Cases, 5)
show_regex_works(Code_of_Federal_Regulations, 5)
show_regex_works(Federal_Register, 5)

# Now do for all 

attachments %<>%
  mutate(
    US_Code = str_count(string = attachment_text,
                        pattern = US_Code_Regex),
    Supreme_Court_Cases = str_count(string = attachment_text,
                                    pattern = Supreme_Court_Cases),
    Appeals_and_District_Court_Cases = str_count(string = attachment_text,
                                                 pattern = Appeals_and_District_Court_Cases),
    Code_of_Federal_Regulations = str_count(string = attachment_text,
                                            pattern = Code_of_Federal_Regulations),
    Federal_Register_Total = str_count(string = attachment_text, 
                                        pattern = Federal_Register),
    Total_Legal_Citations = US_Code + Supreme_Court_Cases + 
      Appeals_and_District_Court_Cases + Code_of_Federal_Regulations +
      Federal_Register_Total
  ) 

#### Get stats for all citations

# Overall
DF_in_one_column <- attachments %>%
  select(-attachment_text, -attachment_number) %>%
  rename(
    `US Code` = US_Code,
    `Supreme Court Cases` = Supreme_Court_Cases,
    `Appeals and District Court Cases` = Appeals_and_District_Court_Cases,
    `Code of Federal Regulations` = Code_of_Federal_Regulations,
    `Federal Register` = Federal_Register_Total,
    `Total Legal Citations` = Total_Legal_Citations) %>%
  gather(Legal_Citation, val) %>% 
  mutate(val = as.numeric(val)) %>%
  filter(!is.na(val)) %>%
  group_by(Legal_Citation)
  
#' Show summary statistics for all technical features
library(kableExtra)
knitr::kable(DF_in_one_column %>%
               summarise(n = n(),
                         min = fivenum(val)[1],
                         Q1 = fivenum(val)[2],
                         median = fivenum(val)[3],
                         Q3 = fivenum(val)[4],
                         Q90 = quantile(val, 0.9, na.rm = T),
                         Q95 = quantile(val, 0.95, na.rm = T),
                         Q99 = quantile(val, 0.99, na.rm = T),
                         max = fivenum(val)[5])) %>%
  kable_styling(bootstrap_options = c("striped", "hover"))

DF_in_one_column %>%
  mutate(Legal_Citation = factor(Legal_Citation, levels = c("US Code",
                        "Supreme Court Cases","Appeals and District Court Cases",
                        "Code of Federal Regulations", "Federal Register",
                        "Total Legal Citations"))) %>%
  ggplot(aes(y=val, x=forcats::fct_rev(factor(Legal_Citation)))) + 
  geom_violin(position="dodge", alpha=0.5) +
  theme_minimal() +
  coord_flip(ylim = c(0, 250)) +
  labs(title = "Distribution of Bluebook Citations") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("Citation Type") + ylab("Count") +
  stat_summary(fun=median, geom="point", size=2, color="red") +
  stat_summary(fun=mean, geom="point", size=2, color ="blue")

## TO DO - BY AGENCY ##


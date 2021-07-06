---
title: "Bluebook Regex"
author: "Steven Rashin"
date: "July 02, 2021"
output:
  html_document:
    keep_md: TRUE
---



## Citation Sources

This file is based on three documents: Georgetown's Bluebook style for US code, Supreme Court, and Appeals and District Courts <https://guides.ll.georgetown.edu/c.php?g=261289&p=2339383>, Cornell's Bluebook guide for the CFR and the Federal Register <https://www.law.cornell.edu/citation/2-400#:~:text=Principle%201%3A%20The%20core%20of,followed%20by%20a%20space%20%C2%ABe.g.%C2%BB> and a Github for the Free Law Project <https://free.law/about/> which lists many regex ideas for legal citations <https://gist.github.com/mlissner/dda7f6677b98b98f54522e271d486781>


```r
US_Code_Regex <- "\\d{1,2}\\s{0,1}[Uu]\\.{0,1}[Ss]\\.{0,1}[Cc]\\.{0,1}\\s{0,}\\§{0,1}\\s{0,}\\d{1,}(\\s{0,}\\(\\d{4}\\))?"
Supreme_Court_Cases <- "[A-z]{3,}(\\.)?\\s{1,}v\\.{0,1}\\s{1,}[A-z]{3,}(,)?\\s{1,}\\d{1,}\\s{1,}[Uu]\\.{0,1}\\s{0,}[Ss]\\.{0,1}"
Appeals_and_District_Court_Cases <- "[A-z]{3,}(\\.)?\\s{1,}v\\.{0,1}\\s{1,}[A-z]{3,}(,)?\\s{1,}\\d{1,}\\s{1,}[Ff]"
Code_of_Federal_Regulations <- "\\d{1,}\\s{0,}[Cc].{0,1}\\s{0,}[Ff].{0,1}\\s{0,}[Rr].{0,1}\\s{0,}\\§{0,1}\\s{0,}\\d{1,}" 
Federal_Register <- "\\d{1,}\\s{0,}Fed\\.{0,1}\\s{1,}Reg\\.{0,1}\\s{0,}\\d{1,}"
```

Now we can show the Regex works on toy cites.


```r
# US Code Regex - Permissible 
str_count(string =  "14 USC § 25, 14 USC 25, 14 U.S.C. 25, 14 USC 25 (2005), 
          14 U.SC 25, 14USC25", 
          pattern = US_Code_Regex)
```

```
## [1] 6
```

```r
# Supreme Court
str_count(string =  "Roe v. Wade, 410 U.S. 113, 164 (1973), 
          Roe v. Wade, 410 U.S. 113,
          Roe v Wade, 410 U.S. 113,
          Roe v Wade 410 U.S. 113,
          Roe v Wade 410 US 113",
          pattern = Supreme_Court_Cases)
```

```
## [1] 5
```

```r
str_count(string =  "Universal City Studios, Inc. v. Corley, 273 F.3d 429 (2d Cir. 2001),
          Universal City Studios, Inc. v. Corley, 273 F.3d 429,
          Universal City Studios, Inc. v. Corley, 273 F.d 429,
          Universal City Studios, Inc. v. Corley, 273 F.", 
          pattern = Appeals_and_District_Court_Cases)
```

```
## [1] 4
```

```r
str_count(string =  "20 C.F.R. § 404.260,
          20 C.F.R. § 404,
          20 CFR § 404.260
          20 CFR § 404", 
          pattern = Code_of_Federal_Regulations)
```

```
## [1] 4
```

```r
str_count(string =  "59 Fed. Reg. 4233,
          59 Fed. Reg. 4233", 
          pattern = Federal_Register)
```

```
## [1] 2
```

Now we can show that the regular expressions work in practice on a random sample of five documents that have examples of the citation we care about.


```r
# show random examples in practice
show_regex_works <- function(pattern, num_to_print){
  FR <- str_count(string = attachments$attachment_text, pattern = pattern)
  sampled <- str_match_all(string = attachments$attachment_text[which(FR>0)], 
                pattern = pattern) %>%
    sample(num_to_print,replace = F)
  return(sampled)
}

show_regex_works(US_Code_Regex, 5)
```

```
## [[1]]
##      [,1]                [,2]
## [1,] "12 U.S.C.  § 2607" NA  
## [2,] "12 U.S.C.  § 2607" NA  
## [3,] "12 U.S.C.  § 2607" NA  
## 
## [[2]]
##      [,1]              [,2]
## [1,] "12 u.s.c. §5518" NA  
## 
## [[3]]
##      [,1]              [,2]
## [1,] "15 U.S.C. §1692" NA  
## 
## [[4]]
##      [,1]                [,2]
## [1,] "15 U.S.C. §\n1601" NA  
## 
## [[5]]
##      [,1]               [,2]
## [1,] "11 U.S.C  §362"   NA  
## [2,] "11 U.S.C. \n§108" NA
```

```r
show_regex_works(Supreme_Court_Cases, 5)
```

```
## [[1]]
##      [,1]                         [,2] [,3]
## [1,] "Inc. v. Cardegna, 546 U.S." "."  "," 
## 
## [[2]]
##      [,1]                                  [,2] [,3]
## [1,] "Hammer  v.  Dagenhart,\n247  U.S."   NA   "," 
## [2,] "Hammer v.  Dagenhart,  247  U.S."    NA   "," 
## [3,] "Katzenbach  v.  McClung,  379  U.S." NA   "," 
## [4,] "Terre v. Boraas,  416 U.S."          NA   "," 
## [5,] "Carolina v.  Baker, 485  U.S."       NA   "," 
## 
## [[3]]
##      [,1]                               [,2] [,3]
## [1,] "Corp. v. Zuccarini, 56 U.S."      "."  "," 
## [2,] "Inc.  v. \nSanfilippo,  46  U.S." "."  "," 
## [3,] "Inc. v. Gore, 517 U.S."           "."  "," 
## 
## [[4]]
##      [,1]                        [,2] [,3]
## [1,] "Inc.  v.  FCC,  535  U.S." "."  "," 
## 
## [[5]]
##      [,1]                              [,2] [,3]
## [1,] "Montclair v. Ramsdell, 107 U.S." NA   "," 
## [2,] "Hamdan v. \nRumsfeld, 548 U.S."  NA   "," 
## [3,] "Lindh v. Murphy, 521 U. S."      NA   ","
```

```r
show_regex_works(Appeals_and_District_Court_Cases, 5)
```

```
## [[1]]
##       [,1]                            [,2] [,3]
##  [1,] "States v. Zats, 298 F"         NA   "," 
##  [2,] "Chaudhry v. Gallerizzo, 174 F" NA   "," 
##  [3,] "Azar v. \nHayter, 874 F"       NA   "," 
##  [4,] "Chaudhry v. Gallerizzo, 174 F" NA   "," 
##  [5,] "Dikun v. Streich, 369 F"       NA   "," 
##  [6,] "Shimek v. Forbes, 374 F"       NA   "," 
##  [7,] "Bartlett v. Heibl, 128 F"      NA   "," 
##  [8,] "Avila v. Rubin, 84 F"          NA   "," 
##  [9,] "Nielsen v. Dickerson, 307 F"   NA   "," 
## [10,] "Clomon v. Jackson, 988 F"      NA   "," 
## [11,] "Clomon v. Jackson, 988 F"      NA   "," 
## [12,] "Taylor v. Quall, 471 F"        NA   "," 
## [13,] "Billsie v. Brooksbank, 525 F"  NA   "," 
## [14,] "Simmons v. Miller, 970 F"      NA   "," 
## [15,] "Shula v. Lawent, 359 F"        NA   "," 
## [16,] "Johnson v. Riddle, 305 F"      NA   "," 
## [17,] "Duffy v. Landberg, 215 F"      NA   "," 
## [18,] "Shula v. Lawent, 359 F"        NA   "," 
## [19,] "Inc. v. Sykes, 171 F"          "."  "," 
## [20,] "Clomon v. Jackson, 988 F"      NA   "," 
## [21,] "Johnson v. Riddle, 305 F"      NA   "," 
## 
## [[2]]
##      [,1]                       [,2] [,3]
## [1,] "Bernal v. Burnett, 793 F" NA   "," 
## 
## [[3]]
##      [,1]                         [,2] [,3]
## [1,] "Riethman v. Barry, 287 F"   NA   "," 
## [2,] "Shaumyan v. Sidetex, 900 F" NA   "," 
## 
## [[4]]
##      [,1]                         [,2] [,3]
## [1,] "Donvan v. Bierwirth, 680 F" NA   "," 
## 
## [[5]]
##      [,1]                      [,2] [,3]
## [1,] "Corp. v. Sargeant, 20 F" "."  ","
```

```r
show_regex_works(Code_of_Federal_Regulations, 5)
```

```
## [[1]]
##      [,1]           
## [1,] "12 CFR § 226" 
## [2,] "12 CFR § 1026"
## 
## [[2]]
##      [,1]            
## [1,] "12  CFR  §1"   
## [2,] "12 CFR  §160"  
## [3,] "12 CFR  §160"  
## [4,] "12 CFR   § 161"
## [5,] "26  CFR  §1"   
## 
## [[3]]
##      [,1]         
## [1,] "12 CFR 1003"
## 
## [[4]]
##      [,1]              
## [1,] "17C.F.R. § 230"  
## [2,] "17C.FJR. § 230"  
## [3,] "17 C.F.R.  § 230"
## 
## [[5]]
##      [,1]                
## [1,] "12 C.F.R. § \n1005"
## [2,] "12 C.F.R. § 1005"  
## [3,] "12 C.F.R. § 1005"  
## [4,] "12 CFR 1005"       
## [5,] "12 CFR 1005"       
## [6,] "12 CFR 1005"
```

```r
show_regex_works(Federal_Register, 5)
```

```
## [[1]]
##      [,1]                   
## [1,] "75 Fed. Reg. 84"      
## [2,] "76 Fed. Reg. 151"     
## [3,] "76  Fed.  Reg.  47948"
## 
## [[2]]
##      [,1]               
## [1,] "76 Fed. Reg. \n29"
## [2,] "49 Fed. Reg. 8595"
## [3,] "71 Fed. Reg. 39"  
## [4,] "49 Fed. Reg. 8595"
## 
## [[3]]
##      [,1]                  
## [1,] "76  Fed.  Reg. 68846"
## 
## [[4]]
##      [,1]                
## [1,] "77 Fed. Reg. 38422"
## [2,] "77 Fed. Reg. 38422"
## 
## [[5]]
##      [,1]                  
## [1,] "76 Fed. Reg. 8946"   
## [2,] "75 Fed. Reg. 60287"  
## [3,] "47 Fed. Reg. 11380"  
## [4,] "70 Fed. Reg. \n44722"
```


```r
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
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Legal_Citation </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> min </th>
   <th style="text-align:right;"> Q1 </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> Q3 </th>
   <th style="text-align:right;"> Q90 </th>
   <th style="text-align:right;"> Q95 </th>
   <th style="text-align:right;"> Q99 </th>
   <th style="text-align:right;"> max </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Appeals and District Court Cases </td>
   <td style="text-align:right;"> 88593 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 195 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Code of Federal Regulations </td>
   <td style="text-align:right;"> 88593 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 108 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Federal Register </td>
   <td style="text-align:right;"> 88593 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 145 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Supreme Court Cases </td>
   <td style="text-align:right;"> 88593 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 64 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Total Legal Citations </td>
   <td style="text-align:right;"> 88593 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 228 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> US Code </td>
   <td style="text-align:right;"> 88593 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 88 </td>
  </tr>
</tbody>
</table>

Now show a violin plot 


```r
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
```

![](Bluebook_Cites_files/figure-html/violin plot-1.png)<!-- -->


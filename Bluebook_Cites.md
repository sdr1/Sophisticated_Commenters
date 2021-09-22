---
title: "Bluebook Regex"
author: "Steven Rashin"
date: "September 22, 2021"
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
##      [,1]             [,2]
## [1,] "15 U.S.C. 1639" NA  
## 
## [[2]]
##      [,1]           [,2]
## [1,] "15 U.S.C. 78" NA  
## 
## [[3]]
##       [,1]                [,2]
##  [1,] "15 U.S.C. § 45"    NA  
##  [2,] "15\nU.S.C. § 1692" NA  
##  [3,] "15 U.S.C. § 1681"  NA  
##  [4,] "15 U.S.C. § 6801"  NA  
##  [5,] "15 U.S.C. § 16921" NA  
##  [6,] "15 U.S.C. § 1692"  NA  
##  [7,] "12 U.S.C. § 5518"  NA  
##  [8,] "12 U.S.C. § 5518"  NA  
##  [9,] "12 U.S.C. § 5518"  NA  
## [10,] "15\nU.S.C. § 1692" NA  
## 
## [[4]]
##      [,1]             [,2]
## [1,] "15 USC 1605"    NA  
## [2,] "15 USC 1601"    NA  
## [3,] "15 USC 1605"    NA  
## [4,] "15 U.S.C. 1605" NA  
## [5,] "15 U.S.C. 1605" NA  
## [6,] "12 U.S.C. 1841" NA  
## 
## [[5]]
##      [,1]               [,2]
## [1,] "12 U.S.C. § 2607" NA  
## [2,] "12 U.S.C. § 2607" NA  
## [3,] "15 U.S.C. § 1602" NA
```

```r
show_regex_works(Supreme_Court_Cases, 5)
```

```
## [[1]]
##      [,1]                             [,2] [,3]
## [1,] "Cos. v. Dobson, 513 U.S."       "."  "," 
## [2,] "Cos. v. Dobson, 513 U.S."       "."  "," 
## [3,] "Ala. v. Randolph, 531 U.S."     "."  "," 
## [4,] "Inc. v. Dukes, 564 U.S."        "."  "," 
## [5,] "Lybrand v. Livesay, 437 \nU.S." NA   "," 
## [6,] "Corp. v. Twombly, 550 U.S."     "."  "," 
## [7,] "LLC v. Concepcion, 563 U.S."    NA   "," 
## [8,] "Cos. v. Dobson, 513 U.S."       "."  "," 
## 
## [[2]]
##      [,1]                             [,2] [,3]
## [1,] "Pointer  v.  Texas,  380  U.S." NA   "," 
## [2,] "Pointer  v.  Texas,  380  U.S." NA   "," 
## 
## [[3]]
##      [,1]                             [,2] [,3]
## [1,] "Leocal v. Ashcroft, 543 U.S."   NA   "," 
## [2,] "Conservation v. EPA, 540 U.S."  NA   "," 
## [3,] "Inc.  v.  Andrews,  534  U.S."  "."  "," 
## [4,] "Inc.  v.  Wilander,  498  U.S." "."  "," 
## [5,] "Corp. v. Howe, 516 U.S."        "."  "," 
## 
## [[4]]
##      [,1]                        [,2] [,3]
## [1,] "Burnet v. Logan, 283 U.S." NA   "," 
## 
## [[5]]
##      [,1]                             [,2] [,3]
## [1,] "Mugler  v.  Kansas,  123  U.S." NA   "," 
## [2,] "States  v.  Lopez,  514  U.S."  NA   "," 
## [3,] "States  v. Lopez,  514 U.S."    NA   "," 
## [4,] "States  v.  Lopez,  514 U.S."   NA   ","
```

```r
show_regex_works(Appeals_and_District_Court_Cases, 5)
```

```
## [[1]]
##      [,1]                          [,2] [,3]
## [1,] "Zimmerman v.\nPuccio, 613 F" NA   "," 
## 
## [[2]]
##       [,1]                              [,2] [,3]
##  [1,] "Inc. v. EPA, 82 F"               "."  "," 
##  [2,] "Ohio v. \n \nEPA, 838 F"         NA   "," 
##  [3,] "Council v. Reilly, 983 F"        NA   "," 
##  [4,] "Corp. v. EPA, 938 F"             "."  "," 
##  [5,] "Children v. FCC, 712 F"          NA   "," 
##  [6,] "Council v. EPA, 824 \n \nF"      NA   "," 
##  [7,] "Trends  v.  Heckler,  756  F"    NA   "," 
##  [8,] "Ashton  v.  Pierce,  541 \nF"    NA   "," 
##  [9,] "York  v.  EPA,  852  F"          NA   "," 
## [10,] "Citizen v. Young, 831 F"         NA   "," 
## [11,] "UAW v. Dole, 919 F"              NA   "," 
## [12,] "Ohio  v.  EPA,  838  F"          NA   "," 
## [13,] "Mgmt.  v.  EPA,  976  F"         "."  "," 
## [14,] "Corp. v. EPA, 938 F"             "."  "," 
## [15,] "Inc.  v.  Kaplan,  792  F"       "."  "," 
## [16,] "Council v. EPA, 943 F"           NA   "," 
## [17,] "Inc.  v.  EPA,  966  F"          "."  "," 
## [18,] "States \n \nv. Desimone, 140 F"  NA   "," 
## [19,] "Kelley v. Selin, 42 \nF"         NA   "," 
## [20,] "Inc. v. \n \nSkinner, 970 F"     "."  "," 
## [21,] "Pew  v.  Cardarelli,  527  F"    NA   "," 
## [22,] "Club v. Ruckelshaus, 344 F"      NA   "," 
## [23,] "Institute v. EPA, 568 F"         NA   "," 
## [24,] "Inc. v. FPC, 412 F"              "."  "," 
## [25,] "Inc. v. EPA, 547 F"              "."  "," 
## [26,] "Texas  v. \n \nEPA, 499 F"       NA   "," 
## [27,] "Club  v. \nRuckelshaus,  344  F" NA   "," 
## [28,] "Council  v.  EPA,  489  F"       NA   "," 
## [29,] "Corp. v. EPA, 523 F"             "."  "," 
## [30,] "Corp.  v.  Train,  526 \nF"      "."  "," 
## [31,] "Inc. \nv. EPA, 578 F"            "."  "," 
## [32,] "Inc.  v.  EPA,  578  F"          "."  "," 
## [33,] "Inc.  v.  EPA,  578  F"          "."  "," 
## 
## [[3]]
##      [,1]                       [,2] [,3]
## [1,] "Bank  v.  Burke,  414  F" NA   "," 
## [2,] "Phipps v. FDIC, 417 F"    NA   "," 
## [3,] "OCC v. Spitzer, 396 F"    NA   "," 
## [4,] "Bank v. Burke, 414 F"     NA   "," 
## [5,] "Kelley  v.  EPA,  25  F"  NA   "," 
## 
## [[4]]
##      [,1]                         [,2] [,3]
## [1,] "lnst.  v.  EPA, 452 F"      "."  "," 
## [2,] "Auth. v.  EPA, 358 F"       "."  "," 
## [3,] "Institute v.  CFTC,  720 F" NA   "," 
## 
## [[5]]
##      [,1]                          [,2] [,3]
## [1,] "Assoc.  v.  Harris,  453  F" "."  "," 
## [2,] "Venture\nv.  Smith, 452  F"  NA   ","
```

```r
show_regex_works(Code_of_Federal_Regulations, 5)
```

```
## [[1]]
##      [,1]              
## [1,] "12 CFR 202"      
## [2,] "29 C.F.R. § 1610"
## 
## [[2]]
##      [,1]           
## [1,] "12 C.F.R. 360"
## 
## [[3]]
##      [,1]             
## [1,] "17 C.F.R. §270" 
## [2,] "17 C.F.R. § 270"
## 
## [[4]]
##      [,1]              
## [1,] "12 C.F.R. § 1005"
## [2,] "12 C.F.R. § 1005"
## 
## [[5]]
##      [,1]             
## [1,] "12 CFR § 1005"  
## [2,] "12 C.F.R. § 205"
## [3,] "12 CFR 7"
```

```r
show_regex_works(Federal_Register, 5)
```

```
## [[1]]
##      [,1]                
## [1,] "73 Fed. Reg. 80315"
## 
## [[2]]
##       [,1]                   
##  [1,] "58  Fed. \n \nReg. 62"
##  [2,] "58  Fed.  Reg.  63"   
##  [3,] "58 Fed. Reg. 3782"    
##  [4,] "58 Fed. Reg. 62"      
##  [5,] "58  Fed.  Reg.  3768" 
##  [6,] "58 Fed. Reg. \n13"    
##  [7,] "58 Fed. Reg. 63"      
##  [8,] "58 Fed. Reg. 63"      
##  [9,] "58  Fed.  Reg.  63"   
## [10,] "58 Fed. Reg. 63"      
## [11,] "58  Fed.  Reg. \n63"  
## [12,] "58  Fed.  Reg.  63"   
## [13,] "58  Fed.  Reg.  63"   
## [14,] "58  Fed.  Reg. \n63"  
## [15,] "58 Fed. Reg. 63"      
## [16,] "58 Fed. \nReg. 63"    
## [17,] "58 Fed. \nReg. 63"    
## [18,] "58  Fed.  Reg. \n63"  
## [19,] "58 Fed. Reg. 63"      
## [20,] "58  Fed.  Reg.  63"   
## [21,] "45  Fed.  Reg.  76"   
## [22,] "72 Fed. Reg. \n \n56" 
## [23,] "21 Fed. Reg. 356"     
## 
## [[3]]
##      [,1]                
## [1,] "75 Fed. Reg. 23328"
## 
## [[4]]
##      [,1]             
## [1,] "81 Fed. Reg. 37"
## [2,] "81 Fed. Reg. 37"
## [3,] "76 Fed. Reg. 21"
## 
## [[5]]
##      [,1]                   
## [1,] "76 Fed. Reg.  33"     
## [2,] "76 Fed. Reg.  33818"  
## [3,] "75  Fed.  Reg.  75162"
## [4,] "75  Fed. Reg. 75432"
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

bluebook <- attachments %>%
  select(-attachment_text,-attachment_number)

save(bluebook, file = "/Users/stevenrashin/Documents/GitHub/Sophisticated_Commenters/bluebook.RData")

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


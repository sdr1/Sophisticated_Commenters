library(DBI)
library(RSQLite)
library(tidyverse)
library(gridExtra)

master_location <- "/Users/stevenrashin/Dropbox/FINREG-RULEMAKE/attachments.sqlite"
con = dbConnect(SQLite(), dbname=master_location)
alltables = dbListTables(con)
alltables
myQuery <- dbSendQuery(con, "SELECT * FROM attachments")
attachments <- dbFetch(myQuery, n = -1)
attachments <- attachments %>% tibble()

# Header indicators
email <- detect_header(comment = attachments$attachment_text, n = 100, phrases = "@")

email_word <- detect_header(comment = attachments$attachment_text, n = 100, phrases = "email")

name <- detect_header(comment = attachments$attachment_text, n = 100, phrases = "name")

from <- detect_header(comment = attachments$attachment_text, n = 100, phrases = "from")

subject <- detect_header(comment = attachments$attachment_text, n = 100, phrases = "subject")

new_line <- detect_header(comment = attachments$attachment_text, n = 100, phrases = "\n")

#phone area code, year, zip
code_year_zip <- detect_header(comment = attachments$attachment_text, n = 100, phrases = "\\d{3,5}")

better_header_indicator <- bind_cols(id = attachments$comment_url,
          email = email,
          email_word = email_word,
          name = name,
          from = from,
          subject = subject,
          code_year_zip = code_year_zip,
          new_line = new_line,
          length = str_length(attachments$attachment_text)) %>%
  mutate(header_w_new_line = email | email_word | name | code_year_zip | new_line,
         header = email | email_word | name | code_year_zip )

better_header_indicator <- better_header_indicator %>%
  mutate(alt_id = 1:nrow(better_header_indicator))

no_new_line <- better_header_indicator %>%
  ggplot(aes(x = alt_id, y = length, color = header)) +
  geom_point() +
  geom_hline(yintercept = 100, linetype = 'dotted', color = 'green') +
  geom_hline(yintercept = 1447.5, linetype = 'dotted', color = 'purple') +
  scale_y_continuous(trans = scales::pseudo_log_trans(base = 10)) +
  theme_bw() +
  labs(x = 'Comment Number', y = 'Number of Characters') +
  ggtitle("No New Line")

new_line <- better_header_indicator %>%
  ggplot(aes(x = alt_id, y = length, color = header_w_new_line)) +
  geom_point() +
  geom_hline(yintercept = 100, linetype = 'dotted', color = 'green') +
  geom_hline(yintercept = 1447.5, linetype = 'dotted', color = 'purple') +
  scale_y_continuous(trans = scales::pseudo_log_trans(base = 10)) +
  theme_bw() +
  labs(x = 'Comment Number', y = 'Number of Characters') +
  ggtitle("New Line")

grid.arrange(no_new_line, new_line, ncol = 2)

better_header_indicator %>%
  filter(length > quantile(length, 0.99)) %>%
  View()

attachments %>%
  filter(comment_url == "https:/www.sec.gov/comments/S7-08-10/s70810-213.pdf") %>%
  select(attachment_text) %>%
  mutate(intro = stringr::str_sub(attachment_text, end = 100)) %>%
  pull()

comment_p1 <- stringr::str_to_lower(stringr::str_sub(comment, end = n))


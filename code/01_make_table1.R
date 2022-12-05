here::i_am("code/01_make_table1.R")

data <- read.csv(here::here("COVID-19_Vaccinations_in_the_United_States_Jurisdiction.csv"))
library(Hmisc)
library(pacman)
pacman::p_load(
  knitr,
  kableExtra,
  dplyr,
  lubridate,
  ggplot2,
  hrbrthemes
)

knitr::kable(summary(data[,5:8]),)



kableExtra::kbl(summary(data[,5:8]), caption = "Summary of 4 Tpyes of Vaccine",
    booktabs = T,
    centering = T,
    align = c("l", "c","c","c","c")) %>%
  row_spec(0, align = "c", bold = TRUE) %>%
  kable_classic(full_width = F, html_font = "Cambria") %>%
  kable_styling(latex_options=c("scale_down"))->summary_vaccine_table



df_table <- data[,c(1,3,5:8)] %>% filter(Location=="GA") %>%
  group_by(Date) %>% 
  arrange(desc(Distributed_Janssen),desc(Distributed_Moderna),desc(Distributed_Pfizer),desc(Distributed_Novavax))

knitr::kable(head(df_table),"simple",
             col.names = c('Date','Location','Janssen','Moderna', 'Pfizer', 'Novavax'),align = "lccccc", 
             caption = "Top 6 Vaccine Deliver Date")-> Top6_table
saveRDS(summary_vaccine_table, file = here::here("output/summary_vaccine_table.rds"))
saveRDS(Top6_table, file = here::here("output/Top6_table.rds"))

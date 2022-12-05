here::i_am("code/02_make_plot.R")

data <- read.csv(here::here("COVID-19_Vaccinations_in_the_United_States_Jurisdiction.csv"))

library(tidyverse)
library(lubridate)
library(scales)


colnames(data)[5:8] <- c("Janssen","Moderna","Pfizer","Novavax")
df_plot<-data[,c(1,3,5:8)] %>% 
  filter(Location=="GA") %>% 
  pivot_longer(c(Janssen,Moderna,Pfizer,Novavax), 
               names_to = "Type",
               values_to = "Num_deliver",
               values_drop_na = TRUE) %>% 
  filter(Num_deliver != 0) %>% 
  na.omit()

df_plot$Date<- as.Date(df_plot$Date, format="%m/%d/%Y")
df_plot$Date <- as.POSIXct(df_plot$Date)

ggplot(data=df_plot)+
  geom_line(aes(x=Date,y=Num_deliver,group=Type,color=Type))+
  scale_x_datetime(date_breaks = "60 days",labels = date_format("%Y-%m-%d"))+ 
  theme(axis.text.x = element_text(size=5, angle=0))+
  ggtitle("Date-Number of Covid-19 Vaccine Delivery Between March 2021- September 2022")+
  xlab("Date") + 
  ylab("Number of Covid-19 Vaccine Delivery")->Deliver_plot

ggsave(
  here::here("output/Deliver_plot.png"),
  plot = Deliver_plot,
  device = "png"
)

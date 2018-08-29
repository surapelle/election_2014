#load libraries and data

library(ggplot2)
library(sf)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)

options(device="X11")
X11.options(type="cairo")

shp_karlstad <- read_sf("data/valgeografi_valdistrikt_2018/alla_valdistrikt.shp") %>% 
  filter(NAMN_KOM=="Karlstad") %>% 
  select(VD,
         VD_NAMN,
         geometry)

ggplot(shp_karlstad)+
  geom_sf()

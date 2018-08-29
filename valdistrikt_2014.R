#ladda_bibliotek och data

library(ggplot2)
library(sf)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)

options(device="X11")
X11.options(type="cairo")

hela_landet <- read_sf("data/valgeografi_valdistrikt_2014/valgeografi_valdistrikt.shp")

valres_2014 <- read_csv2("data/2014_kommunval_per_valdistrikt.csv")

head(hela_landet)

#filter the shapefile to fit my region
shp_varmland <- hela_landet %>% 
  filter(str_detect(VD, "^17"))

# select the interesting columns valres_2014 and filter out my region

valres_2014 <- valres_2014 %>% 
  select(LÄN,
         KOM,
         VALDISTRIKT,
         LÄN_1,
         KOMMUN,
         VALDISTRIKT_1,
         `M proc`,
         `C proc`,
         `FP proc`,
         `KD proc`,
         `S proc`,
         `V proc`,
         `MP proc`,
         `SD proc`,
         VDT) 

kommun_varmland_2014 <- valres_2014 %>%
  filter(LÄN_1=="Värmlands län")

# join to a new dataset
map_varmland_2014 <- left_join(shp_varmland, kommun_varmland_2014, by=c("VD_NAMN"="VALDISTRIKT_1"))




ggplot(map_varmland_2014) +
  geom_sf()
 
#make wide data long

map_varmland_2014_long <- gather(map_varmland_2014, party, proc_of_votes, `M proc`:`SD proc`, factor_key = TRUE)

#filter out my region

kommunal_karta_2014_varmland <- kommunal_karta_2014_long %>% filter(LÄN_1=="Värmlands län")

#small multiple maps


ggplot(map_varmland_2014_long) +
  geom_sf(aes(fill=proc_of_votes)) +
  scale_fill_distiller(direction=1, name="% av rösterna") +
  facet_wrap(~party)
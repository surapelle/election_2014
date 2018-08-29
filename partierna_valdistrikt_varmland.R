#load libraries and data

library(ggplot2)
library(sf)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)

options(device="X11")
X11.options(type="cairo")

#load_data, results from the election:

valres_2014 <- read_csv2("https://data.val.se/val/val2014/statistik/2014_riksdagsval_per_valdistrikt.skv",
                         locale=locale("sv",encoding="ISO-8859-1"), quote ="")

#map as shapefile and filter it down to my region (region code starts with 17):
shp_varmland <- read_sf("data/valgeografi_valdistrikt_2014/valgeografi_valdistrikt.shp") %>% 
  filter(str_detect(VD, "^17"))

#filter the results_file to fit my region and select the interesting colums
valres_varmland_2014 <- valres_2014 %>% 
  select(LAN,
         KOM,
         VALDIST,
         RIKSDAGSVALKRETS,
         KOMMUN,
         Kommunvalkrets,
         Valdistrikt,
         `M proc`,
         `C proc`,
         `FP proc`,
         `KD proc`,
         `S proc`,
         `V proc`,
         `MP proc`,
         `SD proc`,
         VDT) %>% 
  filter(RIKSDAGSVALKRETS=="Värmlands län",
         VALDIST!="00" & VALDIST!="01" & VALDIST!="02") %>% 
  rename(Moderaterna=`M proc`,
         Centerpartiet=`C proc`,
         Liberalerna=`FP proc`,
         Kristdemokraterna=`KD proc`,
         Socialdemokraterna=`S proc`,
         Vänsterpartiet=`V proc`,
         Miljöpartiet=`MP proc`,
         Sverigedemokraterna=`SD proc`)

# join the two datasets
map_varmland_2014 <- left_join(shp_varmland, valres_varmland_2014, by=c("VD_NAMN"="Valdistrikt"))

# make wide dataset long, for visualization purposes

map_varmland_2014_long <- gather(map_varmland_2014, party, proc_of_votes, Moderaterna:Sverigedemokraterna, factor_key = TRUE)

#start visualising

ggplot(map_varmland_2014_long) +
  geom_sf(aes(fill=proc_of_votes), color="white", size=.1) +
  theme_void()+
  theme(panel.grid.major = element_line(colour="transparent"),
        legend.position = "bottom") +
  facet_wrap(~party, ncol=4) +
  scale_fill_distiller(palette="Oranges", direction=1, name="Percent of votes") +
  labs(title="How Värmland Votes: Party Support in the 2014 Riksdag election",
       caption="Source: Val.se")

ggsave("election_map_2014.pdf", width = 30, height = 20, units="cm")

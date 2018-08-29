library(readr)
library(dplyr)

candidates <- read_csv2("https://data.val.se/val/val2018/valsedlar/partier/kandidaturer.skv", 
                        locale=locale("sv",encoding="ISO-8859-1"), quote ="")


#byta format ??
candidates$ÅLDER_PÅ_VALDAGEN <- as.numeric(candidates$ÅLDER_PÅ_VALDAGEN)
candidates$ORDNING <- as.numeric(candidates$ORDNING)
candidates$KÖN <- as.factor(candidates$KÖN)
candidates$VALTYP <- as.character(candidates$VALTYP)

riksdagen <- candidates %>% 
  filter(VALTYP=="R")

ggplot(riksdagen,
       aes(y=ÅLDER_PÅ_VALDAGEN, x=ORDNING, color=KÖN))+
  geom_point()

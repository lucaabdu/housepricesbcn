library(tidyverse);
# library(Hmisc);
# library(XLConnect);
# library(directlabels);
# library(lubridate);
# library(officer) ;
# library(flextable);
# library(RJDBC);
# library(DBI)
# library(zoo)

# combinare tutti i file della cartella
# Put in your actual path where the text files are saved
mypath = "C:/Users/I0429207/OneDrive - Sanofi/Desktop/Luca Bassem/Varie/01_Case"

setwd(mypath)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#

# Trying to scrape data from the Web --------------------------------------

library(httr)
library(rvest)
library(plyr)
library(zoo)
url <- "https://opendata-ajuntament.barcelona.cat/data/es/dataset/est-mercat-immobiliari-compravenda-preu-total"

website <- GET(url)

years <- 4

link_list <- list ()
for(i in 0:(years-1)) {
          
          link_list[i+1] <- html_nodes(content(website), xpath = paste0('//*[@id="series-',i,'"]/div/li/div/ul/li[1]/a')) %>% html_attr("href")
}

bcn_house_prices <- lapply(link_list,read.csv) %>% do.call(rbind.fill,.) %>% mutate(Any = ifelse(is.na(Any), ï..Any, Any)) %>% 
     dplyr::select(-ï..Any) %>% 
     mutate(Date = as.Date(as.yearqtr(paste0(.$Trimestre,"-",.$Any), format = "%q-%Y")))

write.csv(bcn_house_prices, paste0('bcn_house_prices_last',years,'years.csv'))



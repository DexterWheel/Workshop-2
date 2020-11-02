library(tidyverse)

filebuoy <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=44025h2011.txt.gz&dir=data/historical/stdmet/"

readLines(file, n = 4)

#read_table expexts exactly one space in each column

buoy <- read_table(filebuoy, 
                        col_names = FALSE,
                        skip = 2,)

names <- scan(filebuoy, nlines = 1, what = character()) %>% str_remove("#")


units <- scan(filebuoy, skip = 1, nlines = 1, what = character()) %>% str_remove("#") %>% str_replace("/", "_per_")

n_u <- paste(names, units, sep = "_")

names(buoy) <-paste(names, units, sep = "_")
#or
buoy2 <- read_table(filebuoy, 
                   col_names = n_u,
                   skip = 2,)


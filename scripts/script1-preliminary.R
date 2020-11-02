library(tidyverse)

nums <- sample((1:100)/100, size = 10, replace = F)

tnums <- nums %>% sqrt() %>% log()

biomass_raw <- "data-raw/biomass.txt"

#read_table2() is a function from the tidyverse's readr package. 
#It works a lot like base R's read.table() but with some useful defaults 
#(e.g., is header assumed) and extra functionality (e.g.,it's faster).
biomass <- read_table2(biomass_raw)

view(biomass)

#These data are in "wide" format and can be converting to "long" format 
#using the tidyr package function pivot_longer().
#pivot_longer() collects the values from specified columns (cols) 
#into a single column (values_to) and creates a column to indicate the group (names_to).

#We want to gather the first 6 columns but the rep_tray column contents should be repeated.

biomass2 <- biomass %>% 
  pivot_longer(names_to = "spray", 
               values_to = "mass",
               cols = -rep_tray)

view (biomass2)

file <- "data-processed/biomass.txt"

write.table(biomass2, 
            file,
            quote = F,
            row.names = F)


#We sometimes have single columns which contain more than one type of encoded information.

#For example, a column might contain a full species name and you might want to separate the 
#genus and species names to perform a by-genus analysis.

#Another example arises when you read in multiple files with names that encode a date, 
#experiment or treatment. Typically, we add the file name to a column in the dataframe 
#before combining the dataframes for analysis and then split the name into columns for the date,
#experiment of treatment.



#Extract parts of rep_tray and put in new columns replicate_number, tray_id:
  
  biomass3 <- biomass2 %>% 
  extract(rep_tray, 
          c("replicate_number", "tray_id"),
          "([0-9]{1,2})\\_([a-z])")
  
# The patterns to save into columns are inside ( ).
# The pattern going into replicate_number, [0-9]{1,2}, means 1 or 2 numbers.
# The pattern going into tray_id, [a-z] means one lowercase letter.
# the bit between the two ( ), \_ is a pattern that matches what is in rep_tray but is not to be saved.
  
  view(biomass3)
  
  
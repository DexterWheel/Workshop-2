#The cells lines are Y101, Y102, Y201, Y202 and Y101.5 and there are three replicates for each cell line arranged in columns. 
#Also in the file are columns for:
  
#the protein accession
#the number of peptides used to identify the protein
#the number of unique peptides used to identify the protein
#a measure of confidence in that identification
#the maximum fold change between the mean abundances of two cell lines (i.e., highest mean / lowest mean)
#a p value for a comparison test between the highest mean and lowest mean
#a q value (corrected p value)
#a measure of the power of that test
#the cell line with the highest mean
#the cell line with the lowest mean
#the protein mass
#whether at least two peptides were detected for a protein.

library(tidyverse)

#define file name
filesol <- "data-raw/Y101_Y102_Y201_Y202_Y101-5.csv"
# skip =2 (skip first two lines)
sol <- read_csv(filesol, skip = 2) %>% 
  janitor::clean_names()

#:: notation gives you access to a package's functions without first using the library() command.



#This dataset includes bovine serum proteins from the medium on which the cells were grown which need to be filtered out.

#We also filter out proteins for which fewer than 2 peptides were detected since we can not be confident about their identity.
#This is common practice for such proteomic data.


#Keep rows of human proteins identified by more than one peptide:
  
sol2 <- sol %>% 
  filter(str_detect(description, "OS=Homo sapiens")) %>% 
  filter(x1pep == "x")
  
#str_detect(string, pattern) returns a logical vector according to whether 'pattern' is found in 'string'.
  
#Notice that we have applied filter() twice using the pipe.

#It would be useful to extract the genename from the description and put it in a column.


sol2$description[1]

one_description<- sol2$description[1]

str_extract(one_description, "GN=[^\\s]+")

#[ ] means some characters
#^ means 'not' when inside [ ]
#\s means white space
#the \ before is an escape character to indicate that the next character, \ should not be taken literally (because it's part of \s)
#+ means one or more

#So GN=[^\\s]+ means GN= followed by one or more characters that are not whitespace. 
#This means the pattern stops matching at the first white space after "GN=".


str_extract(one_description, "GN=[^\\s]+") %>% 
  str_replace("GN=", "")

#Creating a new column

#mutate() is the dplyr function that adds new variables and preserves existing ones. It takes name = value pairs of expressions where:
#name is the name for the new variable and
#value is the value it takes. This is usually an expression.

sol3 <- sol2 %>%
  mutate(genename =  str_extract(description,"GN=[^\\s]+") %>% 
           str_replace("GN=", ""))


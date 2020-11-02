library(tidyverse)

#define file name
file <- "data-raw/Human-development-index.csv"
# skip =2 (skip first two lines)
hdi <- read_csv(file) %>% 
  janitor::clean_names()

hdi2 <- hdi %>% pivot_longer(names_to = "year", 
               values_to = "hdi",
               cols = -country : -hdi_rank_2018)

hdi3 <- hdi2 %>% filter(is.na(hdi)== F)

#The tidyverse way of summarising data is to combine the group_by() function with the summarise() function. 
#For example, to get the mean index by country we would use:

hdi_summary <- hdi3 %>% group_by(country) %>% 
  summarise(mean_index = mean(hdi),
            n = length(hdi),)

#Add columns for the standard deviation and the standard error (S.E.=s.d.n√) 


hdi_summary <- hdi3 %>% group_by(country) %>% 
  summarise(mean_index = mean(hdi),
            n = length(hdi), sd = sd(hdi), se = sd/(sqrt(n)))

hdi_summary_low <- hdi_summary %>% 
  filter(rank(mean_index) < 11)

hdi_summary_low %>% 
  ggplot() +
  geom_point(aes(x = country,
                 y = mean_index)) +
  geom_errorbar(aes(x = country,
                    ymin = mean_index - se,
                    ymax = mean_index + se)) +
  scale_y_continuous(limits = c(0, 0.5),
                     expand = c(0, 0),
                     name = "HDI") +
  scale_x_discrete(expand = c(0, 0),
                   name = "") +
  theme_classic() +
  coord_flip()


#Build a pipeline that takes the hdi dataframe (the one with 6360 rows) through to the plot above, 
#without creating any intermediate data structures.



hdi %>% 
  pivot_longer(names_to = "year", values_to = "index",cols = -country : -hdi_rank_2018) %>% 
  filter(is.na(index)== F) %>% 
  group_by(country) %>%
  summarise(mean_index = mean(index),
            n = length(index), sd = sd(index), se = sd/(sqrt(n))) %>%
  ggplot() +
  geom_point(aes(x = country,
                 y = mean_index)) +
  geom_errorbar(aes(x = country,
                    ymin = mean_index - se,
                    ymax = mean_index + se)) +
  scale_y_continuous(limits = c(0, 0.5),
                     expand = c(0, 0),
                     name = "HDI") +
  scale_x_discrete(expand = c(0, 0),
                   name = "") +
  theme_classic() +
  coord_flip()


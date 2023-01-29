install.packages('ggrepel')
library(tidyverse)
library(ggrepel)
library(readxl)
roaddeaths2019 <- read_excel("Excel/TrafficDeathsProject/full2019data.xlsx", 
                             col_types = c("text", "text", "text", 
                                           "text", "numeric", "numeric", "numeric"))
View(roaddeaths2019)

data_rateOrdered <- roaddeaths2019
data_rateOrdered$country <- factor(data_rateOrdered$country,
                                            levels = data_rateOrdered$country[order(data_rateOrdered$trafficdeathrate, 
                                                                                    decreasing = FALSE)])

data_totalOrdered <- roaddeaths2019
data_totalOrdered$country <- factor(data_totalOrdered$country,
                                    levels = data_totalOrdered$country[order(data_totalOrdered$trafficdeaths,
                                                                             decreasing = FALSE)])

data_rateOrdered %>%
  filter(continent == 'North America' | continent == 'Europe' )  %>%
  filter(hdi_grp == 'Very High') %>%
  ggplot(aes(country, trafficdeathrate, fill = continent, alpha = hdi))+
  geom_bar(stat = 'identity')+
  coord_flip()+
  theme_minimal()+
  guides(alpha = 'none')+
  labs(x = NULL,
       y = 'Road deaths per 100,000 population (2019)',
       title = 'Road Death Rates by Country',
       subtitle = 'Darker is More Developed')

data_totalOrdered %>%
  filter(hdi_grp == 'Very High') %>%
  ggplot(aes(country, trafficdeaths, fill = continent))+
  geom_bar(stat = 'identity')+
  coord_flip()+
  theme_minimal()+
  guides(alpha = 'none')+
  labs(x = NULL,
       y = 'Total Road Deaths',
       title = 'Total Road Deaths of Very Highly Developed Countries (2019)')

roaddeaths2019 %>%
  filter(hdi_grp == 'Very High') %>%
  ggplot(aes(hdi, trafficdeathrate, color = continent, size = trafficdeaths))+
  geom_point()+
  #geom_smooth(method = lm,
              #se = F)+
  geom_text_repel(aes(label = country),
                  size = 3.5)+
  guides(size = 'none')+
  theme_classic()+
  labs(x = 'Human Development Index Rating (Higher is More Developed)',
       y = 'Road deaths per 100,000 population',
       title = 'Road Death Rate vs HDI (2019)',
       subtitle = 'Very Highly Developed Countries')

roaddeaths2019 %>%
  filter(continent == 'North America' | continent == 'Europe' ) %>%
  filter(hdi_grp == 'Very High') %>%
  ggplot(aes(hdi, trafficdeathrate, color = continent, size = trafficdeaths))+
  geom_point()+
  geom_text_repel(aes(label = country), 
                  size = 4)+
  guides(size = 'none')+
  theme_classic()+
  labs(x = 'Human Development Index Rating (Higher is More Developed)',
       y = 'Road Deaths per 100,000 Population',
       title = 'Road Death Rate vs HDI (2019)',
       subtitle = 'Bigger Dot = More Total Road Deaths')

roaddeaths2019 %>%
  filter(continent == 'North America' | continent == 'Europe') %>%
  filter(hdi_grp == 'Very High') %>%
  ggplot(aes(trafficdeathrate))+
  geom_boxplot()+
  facet_grid(vars(continent))+
  labs(x = 'Road Deaths per 100,000 Population',
       y = NULL,
       title = 'Road Death Rates of Very Highly Developed in Europe vs North America')

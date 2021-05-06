library(networkD3)
library(dplyr)
library(tidyr)


# df <- data.frame(PROD = c("A","A","A","A"), 
#                  REJECT = c("YES","YES","NO","NO"),
#                  ALT_PROD = c("A","B","C","D"), 
#                  VALUE = c(100,100,100,100))

df <- data.frame(site = replicate(7, "Golfo di Venezia"),
                 subEntity = c(NA, NA, NA, NA, "ECOSS Parameter", "ECOSS Parameter", "ECOSS Parameter"),
                 entityType = c("target species", "target species", "target species", 
                                "Habitat", 
                                "Declared parameters", "Declared parameters",
                                "Parameters not measured"),
                 entity = c("Species 1", "Species 2", "Species 3", 
                            "Habitat 1", 
                            "Parameter 1", "Parameter 2", 
                            "Parameter 3"),
                 VALUE = c(replicate(7, 100)))


links <-
  df %>% 
  as_tibble() %>% 
  mutate(row = row_number()) %>% 
  pivot_longer(cols = c(-row, -VALUE),
               names_to = 'column', values_to = 'source') %>% 
  mutate(column = match(column, names(df))) %>% 
  mutate(source = paste0(source, '__', column)) %>% 
  group_by(row) %>% 
  mutate(target = lead(source, order_by = column)) %>% 
  drop_na(target, source) %>% 
  group_by(source, target) %>% 
  summarise(value = sum(VALUE), .groups = 'drop')


nodes <- data.frame(name = unique(c(links$source, links$target)))

links$source <- match(links$source, nodes$name) - 1
links$target <- match(links$target, nodes$name) - 1

nodes$name <- sub('__[0-9]+$', '', nodes$name)


sankeyNetwork(Links = links, Nodes = nodes, Source = "source", 
              Target = "target", Value = "value", NodeID = "name")
View(df)

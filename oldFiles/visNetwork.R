library(tidyverse)


# example from http://www.sthda.com/english/articles/33-social-network-analysis/137-interactive-network-visualization-using-r/
# install.packages("visNetwork")
library("visNetwork")
library("navdata")
data("phone.call2")
nodes <- phone.call2$nodes
edges <- phone.call2$edges
# 
visNetwork(nodes, edges) %>%
  visLayout(randomSeed = 12)

# for ECOSS:
nodes1 <- tibble::tibble(
  id = as.character(c(1:4)),
  label = c(
    'Viški akvatorij', 
    'Tursiops truncatus (Montagu, 1821)',
    'temperature',
    'dissolved oxygen'
  ),
  group = c(
    'Site',
    'Specie',
    'Parameters measured',
    'Parameters measured'
  )
)

edges1 <- tibble::tibble(
  from = as.character(c(1,1,1)),
  to = as.character(c(2:4)),
  weight = c(2,2,2)
)

visNetwork(nodes1, edges1) %>%
  visLayout(
    randomSeed = 10
  ) %>% 
  visNodes(
    shadow = TRUE
  ) %>% 
  visEdges(color = list(color = "lightblue")) %>% 
  visGroups(groupname = "Site", shape = "icon", 
            icon = list(code = "f041", color = "black")) %>%
  visGroups(groupname = "Specie", shape = "icon", 
            icon = list(code = "f2da", color = "blue")) %>% 
  visGroups(groupname = "Parameters recommend", shape = "icon", 
            icon = list(code = "f10c", color = "red")) %>%
  visGroups(groupname = "Parameters measured", shape = "icon", 
            icon = list(code = "f05d", color = "green")) %>%
  addFontAwesome() %>% 
  visLegend() %>% 
  visPhysics(solver = "barnesHut") %>% 
  visExport()
  # visIgraphLayout() %>%
  # visOptions(manipulation = TRUE, nodesIdSelection = TRUE,
             # highlightNearest = list(enabled = T, degree = 2, hover = T))

nodes <- data.frame(id = 1:10, label = paste("Label", 1:10), 
                    group = sample(c("A", "B"), 10, replace = TRUE))

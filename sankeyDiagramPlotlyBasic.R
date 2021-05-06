library(plotly)

fig <- plot_ly(
  type = "sankey",
  orientation = "h",
  
  node = list(
    # label = c("A1", "A2", "B1", "B2", "C1", "C2"),
    # color = c("blue", "red", "blue", "blue", "blue", "blue"),
    label = c("Golfo di Venezia", "Water temperature", "Chlorophyll a", "Phytoplankton aboundance", "Transparency", "WFD - D5C4", "WFD - D5C2", "WFD - D7C1", "WFD - D8C4"),
    color = c("red", "green", "green", "green", "green", "blue", "blue", "blue", "blue"),
    pad = 15,
    thickness = 20,
    line = list(
      color = "black",
      width = 0.5
    )
  ),
  
  link = list(
    # source = c(0,1,0,2,3,3),
    # target = c(2,3,3,4,4,5),
    # value =  c(8,4,1,8,4,1)
    source = c(0,0,0,0,1,1,2,3,4,4,4),
    target = c(1,2,3,4,5,7,8,6,5,7,8),
    value =  c(4,3,3,8,2,2,3,3,2,3,3)
  )
)
fig <- fig %>% layout(
  title = "Basic Sankey Diagram",
  font = list(
    size = 10
  )
)

fig

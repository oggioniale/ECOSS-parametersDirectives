library(plotly)
library(rjson)

json_file <- "https://raw.githubusercontent.com/plotly/plotly.js/master/test/image/mocks/sankey_energy.json"
json_data <- fromJSON(paste(readLines(json_file), collapse=""))

fig <- plot_ly(
  type = "sankey",
  domain = list(
    x =  c(0,1),
    y =  c(0,1)
  ),
  orientation = "h",
  valueformat = ".0f",
  valuesuffix = "TWh",
  
  node = list(
    label = json_data$data[[1]]$node$label,
    color = json_data$data[[1]]$node$color,
    pad = 10,
    thickness = 15,
    line = list(
      color = "black",
      width = 0.5
    )
  ),
  
  link = list(
    source = json_data$data[[1]]$link$source,
    target = json_data$data[[1]]$link$target,
    value =  json_data$data[[1]]$link$value,
    label =  json_data$data[[1]]$link$label
  )
) 
fig <- fig %>% layout(
  title = "Energy forecast for 2050<br>Source: Department of Energy & Climate Change, Tom Counsell via <a href='https://bost.ocks.org/mike/sankey/'>Mike Bostock</a>",
  font = list(
    size = 10
  ),
  xaxis = list(showgrid = F, zeroline = F),
  yaxis = list(showgrid = F, zeroline = F)
)

fig

# Query ######
library('SPARQL')
library('dplyr')
fusekiEcoss <- "http://fuseki1.get-it.it/ecoss/query"

queryConserv <- "PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                 PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                 select * WHERE{
                   ?msfd_param_uri ecoss:contributesToEvaluate ?msfd_criteria_uri;
                   skos:prefLabel ?msfd_param_name .
                   ?msfd_criteria_uri skos:prefLabel ?msfd_criteria_name .
                 }"

contrib <- SPARQL::SPARQL(
  url = fusekiEcoss, 
  query = queryConserv
)$results %>% 
  as_tibble()

# Sankey #####
output$sankeyPlot1 <- plotly::renderPlotly(
  fig <- plotly::plot_ly(
    type = "sankey",
    orientation = "h",
    node = list(
      # label = c("A1", "A2", "B1", "B2", "C1", "C2"),
      # color = c("blue", "red", "blue", "blue", "blue", "blue"),
      label = c("Golfo di Venezia", "Water temperature", "Chlorophyll a", "Phytoplankton aboundance", "Transparency", "MSFD - D5C4", "MSFD - D5C2", "MSFD - D7C1", "MSFD - D8C4"),
      color = c("red", "green", "green", "green", "green", "blue", "blue", "blue", "blue"),
      # label = c("Golfo di Venezia", "target species", "Habitat", "Declared parameters", "Parameters not measured", "Species 1", "Species 2", "Species 3", "Habitat 1", "Parameter 1", "Parameter 2", "Parameter 3"),
      # color = c("red", "green", "green", "green", "green", "blue", "blue", "blue", "blue", "blue", "blue", "blue"),
      pad = 15,
      thickness = 20,
      line = list(
        color = "black",
        width = 0.5
      )
    ),
    link = list(
      source = c(0,0,0,2,3,3),
      target = c(2,3,3,4,4,5),
      value =  c(8,4,1,8,4,1)
      # gli elementi totali sono 8 da Golfo di Venezia a MSFD - D8C4. Ogni elemento in source viene codificato da 0 a 8.
      # in target si indica quale sia l'elemento di arrivo quindi la coppia source targhet indica da dove parte e dove arriva
      # il collegamento.
      # value invece indica il valore di ognuno degli elementi quindi l'elemento 0 ha un valore totale di 4+3+3+8 = 18
      # invece l'elemento 1 (water temperature) ha valore complessivo 2+2 = 4 perchè somma dei valori assegnati alla coppia
      # 1,5 e la coppia 1,7 
      # source = c(0,0,0,0,1,1,2,3,4,4),
      # target = c(1,2,3,4,5,7,8,6,5,7),
      # value =  c(4,3,3,3,2,2,3,3,2,3)
      # source = c(0, 0, 0, 0, 1, 1, 1, 2, 3, 3, 4),
      # target = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
      # value =  c(3, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1)
    )
  ) %>% plotly::layout(
    title = "Sites                                               Parameters                                              Directives",
    font = list(
      size = 12
    ),
    autosize = T
  )
)

# visNetwork #####
output$network <- renderVisNetwork({
  nodes <- tibble::tibble(
    id = 1:17,
    label = c(
      'Cres - Lošinj', 
      'Tursiups truncatus',
      replicate(12, 'Parameter1'),
      replicate(3, 'Parameter2')
    ),
    group = c(
      'Site',
      'Specie',
      replicate(12, 'Parameters recommend'),
      replicate(3, 'Parameters measured')
    )
  )
  
  edges <- tibble::tibble(
    from = replicate(16, 1),
    to = 2:17,
    weight = replicate(16, 2)
  )
  
  visNetwork::visNetwork(nodes, edges) %>%
    visNetwork::visLayout(
      randomSeed = 10
    ) %>% 
    visNetwork::visNodes(
      shadow = TRUE
    ) %>% 
    visNetwork::visEdges(color = list(color = "lightblue")) %>% 
    visNetwork::visGroups(groupname = "Site", shape = "icon", 
              icon = list(code = "f041", color = "black")) %>%
    visNetwork::visGroups(groupname = "Specie", shape = "icon", 
              icon = list(code = "f2da", color = "blue")) %>% 
    visNetwork::visGroups(groupname = "Parameters recommend", shape = "icon", 
              icon = list(code = "f10c", color = "red")) %>%
    visNetwork::visGroups(groupname = "Parameters measured", shape = "icon", 
              icon = list(code = "f05d", color = "green")) %>%
    visNetwork::addFontAwesome(name = "font-awesome-visNetwork") %>% 
    visNetwork::visLegend() %>% 
    visNetwork::visPhysics(solver = "barnesHut") %>% 
    visNetwork::visExport()
  # visIgraphLayout() %>%
  # visOptions(manipulation = TRUE, nodesIdSelection = TRUE,
  # highlightNearest = list(enabled = T, degree = 2, hover = T))
})







# site info box #####
output$siteInfoContrib <- renderUI({
  div(
    HTML(
      paste0(
        '<h3><b><a href="', siteUrl,'" target="_blank">', siteName, '</a></b></h3><br/>',
        '<p><b>Site Manager:</b> ', siteManager, '</p><br/>',
        '<p><b>Site Respondent:</b> ', siteRespondent, '</p>'
      )
    )
  )
})

# Chart #####
output$sankeyPlot <- plotly::renderPlotly(
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

# List of parameters #####
output$tblContrib <- DT::renderDataTable({
  dfContrib <- contrib %>% 
    dplyr::group_by(
      msfd_criteria_label1
    ) %>%
    summarise(`number of parameter(s) measured that contribute to the MSFD Criteria` = sum(numeroParametriMisurati_ENVTHES_InerentiIlParametroMSFD)) %>% 
    dplyr::select(
      `MSFD Criteria` = msfd_criteria_label1,
      `number of parameter(s) measured that contribute to the MSFD Criteria`
    ) 
  actionContrib <- DT::dataTableAjax(session, dfContrib, outputId = "tblContrib")
  
  DT::datatable(
    dfContrib,
    options = list(
      ajax = list(url = actionContrib),
      pageLength = 30,
      columnDefs = list(list(
        visible = FALSE
      )),
      ordering = FALSE
    ), 
    escape = FALSE,
    editable = FALSE
  )
})




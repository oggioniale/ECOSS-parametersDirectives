# site info box #####
output$siteInfoContrib <- renderUI({
  div(
    HTML(
      paste0(
        '<h3><b><a href="', siteUrl(),'" target="_blank">', siteName(), '</a></b></h3><br/>',
        '<p><b>Site Manager:</b> ', siteManager(), '</p><br/>',
        '<p><b>Site Respondent:</b> ', siteRespondent(), '</p>'
      )
    )
  )
})

# Chart #####
output$visNetworkPlot <- renderVisNetwork({
  nodes <- tibble::tibble(
    id = c(
      siteInfo()$site,
      unique(contrib()$msfd_Parameter),
      unique(contrib()$msfd_criteria)
    ),
    label = c(
      siteInfo()$site_name,
      unique(contrib()$msfd_Parameter_label),
      unique(sub('>', '', sub('<http://rdfdata.get-it.it/ecoss/msfd_', '', contrib()$msfd_criteria, fixed = TRUE), fixed = TRUE))
    ),
    title = c(
      siteInfo()$site_name,
      unique(contrib()$msfd_Parameter_label),
      unique(contrib()$msfd_criteria_label1)
    ),
    level = c(
      1,
      replicate(length(unique(contrib()$msfd_Parameter_label)), 2),
      replicate(length(unique(contrib()$msfd_criteria_label1)), 3)
    ),
    group = c(
      'Site',
      replicate(length(unique(contrib()$msfd_Parameter_label)), 'MSFD parameter measured'),
      replicate(length(unique(contrib()$msfd_criteria_label1)), 'Contributes to the MSFD Criteria')
    )
  ) %>%
    dplyr::filter(id != siteInfo()$site)
  
  relation1 <- tibble::tibble(
    from = replicate(length(unique(contrib()$msfd_Parameter)), siteInfo()$site),
    to = unique(contrib()$msfd_Parameter),
    weight = 2
  ) 
  
  relation2 <- contrib() %>% 
    dplyr::select(
      from = msfd_Parameter, 
      to = msfd_criteria,
      weight = numeroParametriMisurati_ENVTHES_InerentiIlParametroMSFD
    )
  
  edges <- rbind(
    relation1,
    relation2
  ) %>%
    dplyr::filter(from != siteInfo()$site)
  
  visNetwork(nodes, edges, height = 700) %>%
    visNodes(
      shadow = TRUE
    ) %>% 
    visHierarchicalLayout(direction = "UD", levelSeparation = 500) %>% 
    visEdges(color = list(color = "lightblue")) %>% 
    visGroups(groupname = "Site", shape = "icon", 
              icon = list(code = "f041", color = "black")) %>%
    visGroups(groupname = "MSFD parameter measured", shape = "icon", 
              icon = list(code = "f05d", color = "green")) %>%
    visGroups(groupname = "Contributes to the MSFD Criteria", shape = "icon", 
              icon = list(code = "f055", color = "blue")) %>%
    addFontAwesome(name = "font-awesome-visNetwork") %>% 
    visLegend() %>% 
    visPhysics(solver = "barnesHut") %>% 
    visExport()
  # visIgraphLayout() %>%
  # visOptions(manipulation = TRUE, nodesIdSelection = TRUE,
  # highlightNearest = list(enabled = T, degree = 2, hover = T))
})

# List of parameters #####
output$tblContrib <- DT::renderDataTable({
  dfContrib <- contrib() %>% 
    # dplyr::group_by(
    #   msfd_criteria_label1
    # ) %>%
    # summarise(`number of parameter(s) measured that contribute to the MSFD Criteria` = sum(numeroParametriMisurati_ENVTHES_InerentiIlParametroMSFD)) %>% 
    dplyr::mutate(
      `MSFD Parameters` = paste0('<a href="', sub('>', '', sub('<', '', msfd_Parameter)), '" target="_blank">', '<i class="fa fa-link" aria-hidden="true"></i> ', msfd_Parameter_label, '</a>'),
      `MSFD Criteria` = paste0('<a href="', sub('>', '', sub('<', '', msfd_criteria)), '" target="_blank">', '<i class="fa fa-link" aria-hidden="true"></i> ',
                               paste0(sub('>', '', sub('<http://rdfdata.get-it.it/ecoss/msfd_', '', msfd_criteria, fixed = TRUE), fixed = TRUE), ' - ', msfd_criteria_label1),
                               '</a>')#,
      # `number of parameter(s) measured that contribute to the MSFD Criteria`
    ) %>% 
    dplyr::select(`MSFD Parameters`, `MSFD Criteria`) %>% 
    dplyr::arrange(`MSFD Criteria`)
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




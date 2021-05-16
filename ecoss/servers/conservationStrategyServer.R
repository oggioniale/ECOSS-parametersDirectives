# site info box #####
output$siteInfoStrategy <- renderUI({
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
      replicate(12, 'Parameters recommend but not measured'),
      replicate(3, 'Parameters measured')
    )
  )
  
  edges <- tibble::tibble(
    from = replicate(16, 1),
    to = 2:17,
    weight = replicate(16, 2)
  )
  
  visNetwork(nodes, edges) %>%
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
    visGroups(groupname = "Parameters recommend but not measured", shape = "icon", 
              icon = list(code = "f10c", color = "red")) %>%
    visGroups(groupname = "Parameters measured", shape = "icon", 
              icon = list(code = "f05d", color = "green")) %>%
    addFontAwesome(name = "font-awesome-visNetwork") %>% 
    visLegend() %>% 
    visPhysics(solver = "barnesHut") %>% 
    visExport()
  # visIgraphLayout() %>%
  # visOptions(manipulation = TRUE, nodesIdSelection = TRUE,
  # highlightNearest = list(enabled = T, degree = 2, hover = T))
})

# Target Species tblStrategySpecies #####
speciesForSite <- c('')

output$tblStrategySpecies <- DT::renderDataTable({
  dfspecieInfo <- specieInfo %>% 
    # dplyr::filter(
    #   species_label %in% speciesForSite
    # ) %>%
    mutate(
      `Protected species` = paste('<a href="', sub('>', '', sub('<', '', species)), '" target="_blank">', '<i class="fa fa-link" aria-hidden="true"></i> ', species_label, '</a>', sep=""),
      `LSID PESI` = paste('<a href="', paste0('http://www.lsid.info/resolver/?lsid=', sub('>', '', sub('<', '', species_PESI))), '" target="_blank">', '<i class="fa fa-link" aria-hidden="true"></i> ', species_PESI, '</a>', sep="")
    ) %>% 
    dplyr::select(
      `Protected species`,
      `LSID PESI`
    )
  actionStrategySpecies <- DT::dataTableAjax(session, dfspecieInfo, outputId = "tblStrategySpecies")
  
  DT::datatable(
    dfspecieInfo,
    options = list(
      # ajax = list(url = actionStrategySpecies),
      pageLength = 30,
      columnDefs = list(list(
        visible = FALSE
      )),
      ordering = FALSE
    ), 
    escape = FALSE,
    # colnames = FALSE,
    editable = FALSE
  )
})

# Habitat tblStrategyHabitats #####
habitatForSite <- c('')

output$tblStrategyHabitats <- DT::renderDataTable({
  dfhabitatInfo <- habitatInfo %>% 
    # dplyr::filter(
    #   habitat_label %in% habitatForSite
    # ) %>%
    mutate(
      `Protected habitat` = paste('<a href="', sub('>', '', sub('<', '', habitat)), '" target="_blank">', '<i class="fa fa-link" aria-hidden="true"></i> ', habitat_label, '</a>', sep="")
    ) %>% 
    dplyr::select(
      `Protected habitat`,
      `Habitat description` = habitat_description
    )
  actionStrategyHabitats <- DT::dataTableAjax(session, dfhabitatInfo, outputId = "tblStrategyHabitats")
  
  DT::datatable(
    dfhabitatInfo,
    options = list(
      # ajax = list(url = actionStrategyHabitats),
      pageLength = 30,
      columnDefs = list(list(
        visible = FALSE
      )),
      ordering = FALSE
    ), 
    escape = FALSE,
    # colnames = FALSE,
    editable = FALSE
  )
})

# ECOSS Recommended Variables but not measured tblEcossParamRecom #####
output$tblEcossParamRecom <- DT::renderDataTable({
  dfVarsRecom <- allVarsECOSS %>% 
    dplyr::filter(
      is.na(isMeasured)
    ) %>%
    mutate(
      `ECOSS variable` = paste('<a href="', sub('>', '', sub('<', '', ecos_var_uri)), '" target="_blank">', '<i class="fa fa-link" aria-hidden="true"></i> ', ecos_var_label, '</a>', sep="")
    ) %>% 
    dplyr::select(
      `ECOSS variable`
    )
  actionVarsRecom <- DT::dataTableAjax(session, dfVarsRecom, outputId = "tblEcossParamRecom")
  
  DT::datatable(
    dfVarsRecom,
    options = list(
      # ajax = list(url = actionVarsRecom),
      pageLength = 30,
      columnDefs = list(list(
        visible = FALSE
      )),
      ordering = FALSE
    ), 
    escape = FALSE,
    # colnames = FALSE,
    editable = FALSE
  )
})

# ECOSS Recommended Variables that are measured tblParamMeasured #####
output$tblParamMeasured <- DT::renderDataTable({
  dfVarsMeasured <- allVarsECOSS %>% 
    dplyr::filter(
      isMeasured == TRUE
    ) %>%
    mutate(
      `ECOSS variable` = paste('<a href="', sub('>', '', sub('<', '', ecos_var_uri)), '" target="_blank">', '<i class="fa fa-link" aria-hidden="true"></i> ', ecos_var_label, '</a>', sep="")
    ) %>% 
    dplyr::select(
      `ECOSS variable`
    )
  actionVarsMeasured <- DT::dataTableAjax(session, dfVarsMeasured, outputId = "tblParamMeasured")
  
  DT::datatable(
    dfVarsMeasured,
    options = list(
      # ajax = list(url = actionVarsMeasured),
      pageLength = 30,
      columnDefs = list(list(
        visible = FALSE
      )),
      ordering = FALSE
    ), 
    escape = FALSE,
    # colnames = FALSE,
    editable = FALSE
  )
})


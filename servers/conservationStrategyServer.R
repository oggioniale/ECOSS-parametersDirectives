# site info box #####
output$siteInfoStrategy <- renderUI({
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

# visNetwork #####
output$network <- renderVisNetwork({
  nodes <- tibble::tibble(
    id = c(
      siteInfo()$site,
      specieInfo()$species,
      allVarsECOSSTrue()$ecos_var_uri,
      allVarsECOSSNa()$ecos_var_uri,
      habitatInfo()$habitat
    ),
    label = c(
      siteInfo()$site_name,
      specieInfo()$species_label,
      stringr::str_trunc(allVarsECOSSTrue()$ecos_var_label, 10, "right"),
      stringr::str_trunc(allVarsECOSSNa()$ecos_var_label, 10, "right"),
      habitatInfo()$habitat_label
    ),
    title = c(
      siteInfo()$site_name,
      specieInfo()$species_label,
      allVarsECOSSTrue()$ecos_var_label,
      allVarsECOSSNa()$ecos_var_label,
      habitatInfo()$habitat_label
    ),
    group = c(
      'Site',
      replicate(nrow(specieInfo()), 'Species'),
      replicate(nrow(allVarsECOSSTrue()), 'Measured variables'),
      replicate(nrow(allVarsECOSSNa()), 'Recommended variables'),
      replicate(nrow(habitatInfo()), 'Habitat')
    )
  )
  
  edges <- tibble::tibble(
    from = replicate((nrow(nodes)-1), nodes$id[1]),
    to = c(
      specieInfo()$species,
      allVarsECOSSTrue()$ecos_var_uri,
      allVarsECOSSNa()$ecos_var_uri,
      habitatInfo()$habitat
    ),
    weight = replicate((nrow(nodes)-1), 2)
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
    visGroups(groupname = "Species", shape = "icon", 
              icon = list(code = "f2da", color = "#FF9420")) %>% 
    visGroups(groupname = "Recommended variables", shape = "icon", 
              icon = list(code = "f10c", color = "#53DCE6")) %>%
    visGroups(groupname = "Measured variables", shape = "icon", 
              icon = list(code = "f05d", color = "#1F6FDE")) %>%
    visGroups(groupname = "Habitat", shape = "icon", 
              icon = list(code = "f06c", color = "#40C98C")) %>%
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
  dfspecieInfo <- specieInfo() %>% 
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
  dfhabitatInfo <- habitatInfo() %>% 
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
  dfVarsRecom <- allVarsECOSS() %>% 
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
  dfVarsMeasured <- allVarsECOSS() %>% 
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


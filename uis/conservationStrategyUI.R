tabItem(
  tabName = "conser",
  fluidRow(
    boxPlus(
      width = 12,
      title = "Site information",
      closable = FALSE,
      status = "info",
      solidHeader = FALSE,
      collapsible = TRUE,
      enable_sidebar = TRUE,
      sidebar_width = 25,
      sidebar_start_open = FALSE,
      sidebar_content = tagList(
        tags$p("..."),
        tags$p(tags$b("Press the gear for collaps this slidebar and start with the work."))
      ),
      column(12, htmlOutput("siteInfoStrategy")
      )
    ),
    boxPlus(
      width = 12,
      title = "Site name", 
      closable = FALSE, 
      status = "info", 
      solidHeader = FALSE, 
      collapsible = TRUE,
      enable_sidebar = TRUE,
      sidebar_width = 25,
      sidebar_start_open = FALSE,
      sidebar_content = tagList(
        tags$p("..."),
        tags$p(tags$b("Press the gear to collapse this sidebar and start with the work."))
      ),
      column(12, visNetwork::visNetworkOutput("network")
      )
    ),
    fluidRow(
      boxPlus(
        width = 6,
        title = "Target species", 
        closable = FALSE, 
        status = "info", 
        solidHeader = FALSE, 
        collapsible = TRUE,
        collapsed = TRUE,
        enable_sidebar = TRUE,
        sidebar_width = 25,
        sidebar_start_open = FALSE,
        sidebar_content = tagList(
          tags$p("..."),
          tags$p(tags$b("Press the gear to collapse this sidebar and start with the work."))
        ),
        column(12, DT::dataTableOutput('tblStrategySpecies')
        )
      ),
      boxPlus(
        width = 6,
        title = "Habitats", 
        closable = FALSE, 
        status = "info", 
        solidHeader = FALSE, 
        collapsible = TRUE,
        collapsed = TRUE,
        enable_sidebar = TRUE,
        sidebar_width = 25,
        sidebar_start_open = FALSE,
        sidebar_content = tagList(
          tags$p("..."),
          tags$p(tags$b("Press the gear to collapse this sidebar and start with the work."))
        ),
        column(12, DT::dataTableOutput('tblStrategyHabitats')
        )
      ),
      boxPlus(
        width = 6,
        title = "ECOSS variables (recommended but not measured)", 
        closable = FALSE, 
        status = "info", 
        solidHeader = FALSE, 
        collapsible = TRUE,
        enable_sidebar = TRUE,
        sidebar_width = 25,
        sidebar_start_open = FALSE,
        sidebar_content = tagList(
          tags$p("..."),
          tags$p(tags$b("Press the gear to collapse this sidebar and start with the work."))
        ),
        column(12, DT::dataTableOutput('tblEcossParamRecom')
        )
      ),
      boxPlus(
        width = 6,
        title = "ECOSS variables (measured)", 
        closable = FALSE, 
        status = "info", 
        solidHeader = FALSE, 
        collapsible = TRUE,
        enable_sidebar = TRUE,
        sidebar_width = 25,
        sidebar_start_open = FALSE,
        sidebar_content = tagList(
          tags$p("..."),
          tags$p(tags$b("Press the gear to collapse this sidebar and start with the work."))
        ),
        column(12, DT::dataTableOutput('tblParamMeasured')
        )
      )
    )
  )
)

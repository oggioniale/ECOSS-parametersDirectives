tabItem(
  tabName = "contrib",
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
      column(12, htmlOutput("siteInfoContrib")
      )
    ),
    boxPlus(
      width = 12,
      title = "", 
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
      column(12, visNetwork::visNetworkOutput("visNetworkPlot")
      )
    ),
    fluidRow(
      boxPlus(
        width = 12,
        title = "Parameters measured at the site that can contribute to the Marine Strategy Framework Directive (MSFD)", 
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
        column(12, DT::dataTableOutput('tblContrib')
        )
      )
    )
  )
)

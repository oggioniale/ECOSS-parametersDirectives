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
      sidebar_start_open = TRUE,
      sidebar_content = tagList(
        tags$p(
          'This box provides the general information as name of the site, institution managing the site and their addess.',
          'In the case of Natura 2000 sites the information are collected directly from triplestore of European Environmental Agency (EEA, e.g. ',
          tags$a("Cres - Lošinj", href="https://eunis.eea.europa.eu/sites/HR3000161", target="_blank"),
          '). For eLTER sites, ate the moment, only the title is visible. In both cases other information can be reached following the link, by cliking on the site name.'
        ),
        tags$p(tags$b("Press the i for collaps this slidebar and start with the work."))
      ),
      column(12, htmlOutput("siteInfoContrib")
      )
    ),
    boxPlus(
      width = 12,
      title = "Contribute to the Marine Strategy Framework Directive (MSFD)", 
      closable = FALSE, 
      status = "info", 
      solidHeader = FALSE, 
      collapsible = TRUE,
      enable_sidebar = TRUE,
      sidebar_width = 25,
      sidebar_start_open = FALSE,
      sidebar_content = tagList(
        tags$p(
          'This graph show the site contribute to the MSFD. The parameters listed with the green checked circle represent the parameters monitored in the site that
          match with those deemed necessary to contribute to the MSFD criteria. The dark blue are all the MSFD criteria to which the parameters can contribute. 
          The lines are meant to represent the connection between the parameters and the criteria.'
        ),
        tags$p(tags$b("Press the i for collaps this slidebar and start with the work."))
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
          tags$p(
            'The table reproduces the graph above. The parameters monitored and the MSFD criteria. 
            A link to the ECOSS thesaurus for parameters and MSFD criteria has provided.'
          ),
          tags$p(tags$b("Press the i for collaps this slidebar and start with the work."))
        ),
        column(12, DT::dataTableOutput('tblContrib')
        )
      )
    )
  )
)

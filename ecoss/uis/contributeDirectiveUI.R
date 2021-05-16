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
      column(12,
             introBox(
               htmlOutput("siteInfoContrib"),
               data.step = 1,
               data.intro = "In this dropdown menu you can select the SOS where you want to upload the observations and where is stored the station/sensor information."
             )
      )
    ),
    boxPlus(
      width = 6,
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
      column(12,
             introBox(
               plotly::plotlyOutput("sankeyPlot"),
               data.step = 1,
               data.intro = "In this dropdown menu you can select the SOS where you want to upload the observations and where is stored the station/sensor information."
             )
      )
    ),
    fluidRow(
      boxPlus(
        width = 6,
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
        column(12,
               DT::dataTableOutput('tblContrib')
        )
      )
    )
  )
)

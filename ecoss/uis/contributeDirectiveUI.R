tabItem(
  tabName = "contrib",
  fluidRow(
    boxPlus(
      width = 6,
      title = "Site Name", 
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
               # div(HTML("<h4><b>Site Name (EUNIS CODE)</b></h4>")),
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
               # div(HTML("<h4>Colums headers (modify the saparator or the quote for display the name of the colums)</h4>")),
               DT::dataTableOutput('tblContrib')
        )
      )
    )
  )
)

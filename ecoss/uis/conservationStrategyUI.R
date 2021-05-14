tabItem(
  tabName = "conser",
  fluidRow(
    boxPlus(
      width = 6,
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
        tags$p(tags$b("Press the gear for collaps this slidebar and start with the work."))
      ),
      column(12,
             introBox(
               # div(HTML("<h4><b>Site Name (EUNIS CODE)</b></h4>")),
               plotly::plotlyOutput("sankeyPlot1"),
               data.step = 1,
               data.intro = "In this dropdown menu you can select the SOS where you want to upload the observations and where is stored the station/sensor information."
             )
      )
    ),
    boxPlus(
      width = 6,
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
        tags$p(tags$b("Press the gear for collaps this slidebar and start with the work."))
      ),
      column(12,
             introBox(
               # div(HTML("<h4><b>Site Name (EUNIS CODE)</b></h4>")),
               visNetwork::visNetworkOutput("network"),
               data.step = 2,
               data.intro = "In this dropdown menu you can select the SOS where you want to upload the observations and where is stored the station/sensor information."
             )
      )
    ),
    fluidRow(
      boxPlus(
        width = 3,
        title = "Target species", 
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
        column(3#,
               # div(HTML("<h4>Colums headers (modify the saparator or the quote for display the name of the colums)</h4>")),
               # uiOutput("selectionParamsFixed")
        )
      ),
      boxPlus(
        width = 3,
        title = "Habitats", 
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
        column(3#,
               # div(HTML("<h4>Colums headers (modify the saparator or the quote for display the name of the colums)</h4>")),
               # uiOutput("selectionParamsFixed")
        )
      ),
      boxPlus(
        width = 3,
        title = "ECOSS parameters recommended", 
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
        column(3#,
               # div(HTML("<h4>Colums headers (modify the saparator or the quote for display the name of the colums)</h4>")),
               # uiOutput("selectionParamsFixed")
        )
      ),
      boxPlus(
        width = 3,
        title = "Parameters measured", 
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
        column(3#,
               # div(HTML("<h4>Colums headers (modify the saparator or the quote for display the name of the colums)</h4>")),
               # uiOutput("selectionParamsFixed")
        )
      )
    )
  )
)

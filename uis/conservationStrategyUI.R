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
      sidebar_start_open = TRUE,
      sidebar_content = tagList(
        tags$p(
            'This box provides general information such as the name of the site, the institution managing the site, and their address.',
            'In the case of Natura 2000 sites the information are collected directly from triple-store of European Environmental Agency (EEA, e.g. ',
            tags$a("Cres - Lošinj", href="https://eunis.eea.europa.eu/sites/HR3000161", target="_blank"),
            '). For eLTER sites, at the moment, only the title is visible. In both cases, other information can be reached following the link, by cliking on the site name.'
        ),
        tags$p(tags$b("Press the i to collapse this slidebar and to start working."))
      ),
      column(12, htmlOutput("siteInfoStrategy")
      )
    ),
    boxPlus(
      width = 12,
      title = "Contribute to the conservation", 
      closable = FALSE, 
      status = "info", 
      solidHeader = FALSE, 
      collapsible = TRUE,
      enable_sidebar = TRUE,
      sidebar_width = 25,
      sidebar_start_open = FALSE,
      sidebar_content = tagList(
        tags$p(
          'This graph shows the site contribution to the conservation strategy. Checked circles represent recommended variables currently monitored within the site, 
          while the light blue symbols represent the variables that are not measured yet. Target species protected in the site are represented by the orange icons.
          Finally, also the protected habitats are shown.' 
        ),
        tags$p('Both, target species and habitat list, on demand from European Environmental Agency (EEA) Linked Data repository are collected.'),
        tags$p(tags$b("Press the i to collapse this sidebar and start with the work."))
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
        sidebar_start_open = TRUE,
        sidebar_content = tagList(
          tags$p(
            'In this table target species are listed. They are retrieved from the European Environmental Agency (EEA) Linked Data repository.
            Links to EEA and to unique LSID (',
            tags$a("Life Science Identifiers", href="http://www.lsid.info/", target="_blank"),
            ') represented as a Uniform Resource Name (URN) for all species are provided.'
          ),
          tags$p(tags$b("Press the i to collapse this sidebar and start with the work."))
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
        sidebar_start_open = TRUE,
        sidebar_content = tagList(
          tags$p(
            'In this table protected habitats are listed. They are retrieved from the European Environmental Agency (EEA) Linked Data repository.
            Links to EEA for all habitats are provided.'
          ),
          tags$p(tags$b("Press the i to collapse this sidebar and start with the work."))
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
        sidebar_start_open = TRUE,
        sidebar_content = tagList(
          tags$p(
            'The variables', tags$b('not measured'), 'and indicated by ECOSS as fundamental for assessing the state of 
            conservation of the specific target species/habitat are listed here.
            Links to ECOSS thesaurus for all variables are provided.'
          ),
          tags$p(tags$b("Press the i to collapse this sidebar and start with the work."))
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
        sidebar_start_open = TRUE,
        sidebar_content = tagList(
          tags$p(
            'The variables', tags$b('measured'), 'and indicated by ECOSS as fundamental for assessing the state of 
            conservation of the specific target species/habitat are listed here.
            '
          ),
          tags$p(tags$b("Press the i to collapse this sidebar and start with the work."))
        ),
        column(12, DT::dataTableOutput('tblParamMeasured')
        )
      )
    )
  )
)

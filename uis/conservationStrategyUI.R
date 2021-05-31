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
            'This box provides the general information as name of the site, institution managing the site and their addess.',
            'In the case of Natura 2000 sites the information are collected directly from triplestore of European Environmental Agency (EEA, e.g. ',
            tags$a("Cres - Lošinj", href="https://eunis.eea.europa.eu/sites/HR3000161", target="_blank"),
            '). For eLTER sites, ate the moment, only the title is visible. In both cases other information can be reached following the link, by cliking on the site name.'
        ),
        tags$p(tags$b("Press the i for collaps this slidebar and start with the work."))
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
      sidebar_start_open = TRUE,
      sidebar_content = tagList(
        tags$p(
          'This graph show the site contribute to the conservarion strategy. The checked circle represent the recommended variables monitored in the site, 
          while the light blue symbol represent the variable not measured. The target species protected in the site are represented by the organge icon.
          Finally also the protected habitats is/are show.' 
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
            'In this table the target species is/are listed as returned by the European Environmental Agency (EEA) Linked Data repository.
            A link to the EEA and the unique LSID (',
            tags$a("Life Science Identifiers", href="http://www.lsid.info/", target="_blank"),
            ') represented as a Uniform Resource Name (URN) for all species has provided.'
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
            'In this table the protected habitats is/are listed as returned by the European Environmental Agency (EEA) Linked Data repository.
            A link to the EEA for all habitats has provided.'
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
            A link to the ECOSS thesaurus for all variables has provided.'
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

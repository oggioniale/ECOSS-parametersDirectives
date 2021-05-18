#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(leaflet)
library(shinycssloaders)
library(leaflet.extras)
library(shinyjs)
library(SPARQL)

###
# UI
###
ui <- fluidPage(
  useShinyjs(),
  # App title ----
  titlePanel("SPARQL Fuseki query for ECOSS"),
  
  fluidRow(
    column(12,
           sidebarPanel(
             # Input: procedure URL
             selectInput('site', 'ECOSS Sites', choices = list(
               'eLTER sites' = c(
                 `Delta del Po e Costa Romagnola` = 'https://deims.org/6869436a-80f4-4c6d-954b-a730b348d7ce',
                 `Golfo di Trieste` = 'https://deims.org/96969205-cfdf-41d8-979f-ff881ea8dc8b',
                 `Golfo di Venezia` = 'https://deims.org/758087d7-231f-4f07-bd7e-6922e0c283fd',
                 `Transetto Senigallia-Susak` = 'https://deims.org/be8971c2-c708-4d6e-a4c7-f49fcf1623c1'
               ),
               'N2K sites' = c(
                 `Cres - Lošinj`  = 'HR3000161',#= 'https://deims.org/2e6014fe-8f3b-4127-8ab1-405ae1303281',
                 `Delta del Po`  = 'IT3270023',#= 'https://deims.org/1eb7d806-7534-4c29-95d2-2db5d1bad362',
                 `Delta del Po: tratto terminale e delta veneto`  = 'IT3270017',#= 'https://deims.org/6b96c97f-cc81-41fd-bc18-3105d2ee112a',
                 `Malostonski zaljev`  = 'HR4000015',#= 'https://deims.org/8b7b96c3-7656-43b3-8c60-3598b91c1a92',
                 `Tegnùe di Chioggia`  = 'IT3250047',#= 'https://deims.org/988c738d-9240-4d54-99c2-0ca0116c9196',
                 `Trezze San Pietro e Bardelli` = 'IT3330009',#= 'https://deims.org/61837250-789c-4c0e-8e9e-85a06b07bbaa',
                 `Viški akvatorij`  = 'HR3000469'#= 'https://deims.org/32f7c197-a371-4a31-93a5-a419f102e18d'
               )
             ), selectize = FALSE),
             # textInput('projWebSite', 'Web site*'),
             actionButton("sendQ", "Send Query")
           ),
           mainPanel(
             tags$head(HTML(
               "<link rel='stylesheet' href='css/codemirror.css'>"
             )),
             tags$head(HTML(
               "<script src='js/codemirror.js'></script>"
             )),
             tags$head(HTML(
               "<script src='js/matchbrackets.js'></script>"
             )),
             tags$head(HTML(
               "<script src='js/sparql.js'></script>"
             )),
             uiOutput("selected_var")
           )
    )
  )
)

# Define server logic to read selected file ----
server <- function(input, output, session) {
  
  # Set up preliminaries and define query
  # Define the fuseki GET-IT endpoint
  endpoint <- "http://fuseki1.get-it.it/ecoss/query"
  
  # SPARQL package to submit query and save results
  observeEvent(input$sendQ, {
    SPARQL(url = endpoint, 
           query = queryContentSPARQL(),
           ns = c(
             'foaf',  '<http://xmlns.com/foaf/0.1/>',
             'rdfs', 'http://www.w3.org/2000/01/rdf-schema#',
             'rdf', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
             'eunisspeciesschema', '<http://eunis.eea.europa.eu/rdf/species-schema.rdf#>',
             'eunissitesschema', '<http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>',
             'eunishabitatsschema': '<http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#>',
             'eunisspecies', '<http://eunis.eea.europa.eu/species/>',
             'eunishabitats', '<http://eunis.eea.europa.eu/habitats/>',
             'eunissites', '<http://eunis.eea.europa.eu/sites/>'
           ),
           curl_args=list(
             # 'userpwd'=paste('admin',':','pswxxxx',sep=''),
             style = "post"
           )
    )
  })
  
  composeQuery <- function (site){
    return(paste0(
      "
      PREFIX foaf:  <http://xmlns.com/foaf/0.1/>
      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
      PREFIX eunisspeciesschema: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
      PREFIX eunissitesschema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
      PREFIX eunishabitatsschema: <http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#>
      PREFIX eunisspecies: <http://eunis.eea.europa.eu/species/>
      PREFIX eunishabitats: <http://eunis.eea.europa.eu/habitats/>
      PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
      SELECT ?habitats
      WHERE{
      BIND(<http://eunis.eea.europa.eu/sites/",
        site,
        "> as ?site)
        SERVICE <https://semantic.eea.europa.eu/sparql>{
          ?site eunissitesschema:hasHabitatType ?habitats.
        }
      }",
      # {
      # <http://rdfdata.get-it.it/directory/projects/",
      # gsub(" ", "_", projName),
      # "> a foaf:Project;
      # foaf:name  '",
      # projName,
      # "';
      # foaf:homepage <",
      # projWebSite,
      # "> .}",
      sep = ""
    ))
  }
  
  queryContentSPARQL <- reactive(
    gsub(
      "\n",
      "",
      composeQuery(input$site)
    )
  )
  
  queryContentUI <- reactive(
    composeQuery(input$site)
  )
  
  output$selected_var <- renderUI({
    tags$form(
      tags$textarea(
        id = "code",
        name = "code",
        queryContentUI()
      ),
      tags$script(HTML(
        "var editorXML = CodeMirror.fromTextArea(document.getElementById(\"code\"), {
        mode: \"application/sparql-query\",
        matchBrackets: true,
        lineNumbers: true,
        smartindent: true,
        extraKeys: {\"Ctrl-Space\": \"autocomplete\"}
        });
        editorXML.setSize(\"100%\",\"100%\");"
      ))
    )
  })
  
  observe({
    toggleState("sendQ",
                condition = (input$site != "") # & input$projWebSite != "")
    )
  })
  
}
# Run the app ----
shinyApp(ui, server)
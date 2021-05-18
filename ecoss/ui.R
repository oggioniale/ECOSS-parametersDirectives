###
# Library
###
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(DT)
library(shinycssloaders)
library(shinyalert)
require(visNetwork)
library(rintrojs)
library('SPARQL')
library('dplyr')
# library(shinyjs)

###
# UI
###
shinyUI(
  fluidPage(
    useShinyalert(),
    # useShinyjs(),
    tags$head(tags$style(HTML('#network,#visNetworkPlot{height:700px !important;}'))),
    dashboardPagePlus(
      skin = "blue",
      collapse_sidebar = FALSE,
      dashboardHeaderPlus(
        title = tagList(
          tags$span(class = "logo-lg", "ECOSS - Tools")#, 
          # tags$img(src = "http://www.get-it.it/assets/img/loghi/lter_leaf.jpg")
        ), 
        # fixed = FALSE,
        # enable_rightsidebar = TRUE,
        # rightSidebarIcon = "gears",
        tags$li(class ="dropdown"#, 
                # tags$a(
                #   href="https://ecoads.eu/",
                #   tags$img(src="https://ecoads.eu/media/images/ECOSS_rgb.max-165x165.jpg"),
                #   style="margin:0;padding-top:2px;padding-bottom:2px;padding-left:10px;padding-right:10px;",
                #   target="_blank"
                # )
        )#,
        # tags$li(class = "dropdown",
        #         actionButton("help", "Give me an overview", style="margin-right: 10px; margin-top: 8px; color: #fff; background-color: #0069D9; border-color: #0069D9")
        # )
      ),
      dashboardSidebar(
        collapsed = TRUE,
        sidebarMenu(
          menuItem("Directive contribution", tabName = "contrib", icon = icon("gavel", lib = "font-awesome"))
          ,
          menuItem("Conservation strategy", tabName = "conser", icon = icon("kiwi-bird", lib = "font-awesome"))
        )
      ),
      dashboardBody(
        tags$head(
          tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css")
        ),
        tabItems(
          source("uis/contributeDirectiveUI.R", local = TRUE)$value
          ,
          source("uis/conservationStrategyUI.R", local = TRUE)$value
        )
      )
    )
  )
)

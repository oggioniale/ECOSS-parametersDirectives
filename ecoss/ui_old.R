#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("ECOSS - Project"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            # a select input
            selectInput('sites', 'ECOSS Sites', choices = list(
                'eLTER sites' = c(
                    `Golfo di Venezia` = 'https://deims.org/758087d7-231f-4f07-bd7e-6922e0c283fd',
                    `Golfo di Trieste` = 'https://deims.org/96969205-cfdf-41d8-979f-ff881ea8dc8b',
                    `Delta del Po e Costa Romagnola` = 'https://deims.org/6869436a-80f4-4c6d-954b-a730b348d7ce',
                    `Transetto Senigallia-Susak` = 'https://deims.org/be8971c2-c708-4d6e-a4c7-f49fcf1623c1'
                ),
                'N2K sites' = c(
                    `Trezze San Pietro e Bardelli` = 'https://deims.org/61837250-789c-4c0e-8e9e-85a06b07bbaa',
                    `Tegnùe di Chioggia` = 'https://deims.org/988c738d-9240-4d54-99c2-0ca0116c9196',
                    `Delta del Po: tratto terminale e delta veneto` = 'https://deims.org/6b96c97f-cc81-41fd-bc18-3105d2ee112a',
                    `Delta del Po` = 'https://deims.org/1eb7d806-7534-4c29-95d2-2db5d1bad362',
                    `Cres - Lošinj` = 'https://deims.org/2e6014fe-8f3b-4127-8ab1-405ae1303281',
                    `Viški akvatorij` = 'https://deims.org/32f7c197-a371-4a31-93a5-a419f102e18d',
                    `Malostonski zaljev` = 'https://deims.org/8b7b96c3-7656-43b3-8c60-3598b91c1a92'
                )
            ), selectize = FALSE),
            
            selectInput('directives', 'Directives', choices = list(
                `Marine Strategy Framework Directive - MSFD` = 'MSFD',
                `Water Framework Directive - WFD` = 'WFD',
                `Habitat Directive - HD` = 'HD',
                `Bird Directive - BD` = 'BD'
            ), selectize = FALSE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotly::plotlyOutput("sankeyPlot")
        )
    )
))

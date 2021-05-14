###
# Sources
###
# source("functions.R", local = TRUE)$value

###
# Server
###
shinyServer(function(input, output, session) {
  
  output$testo <- renderText({
      queryString <- parseQueryString(session$clientData$url_search)
      siteId <- queryString$site
      siteId
  })
  
  # Server fixed station
  source("servers/contributeDirectiveServer.R", local = TRUE)$value
  
  # Server profile
  source("servers/conservationStrategyServer.R", local = TRUE)$value
  
})
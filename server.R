###
# Sources #####
###
# source("functions.R", local = TRUE)$value

###
# Server #####
###
shinyServer(function(input, output, session) {
  
  # ALERT ######
  # Show a simple modal
  shinyalert::shinyalert(
    title = "Information about the use of the ECOAds Tools",
    text = "<p>Here we provide 2 different examples of interction with the tools, we propose two use cases in order to verify the interaction and facilities of the tools.</p>
        </br>
        <p>The first use case is thinking for policy maker or reaserchers that want to assess the contribution of a monitoring site (e.g. eLTER) to the Marine Strategy Framework Directive (MSFD).</p>
        </br>
        <p>The second use case is aimed at managers of Natura 2000 site that want to assess the contribution, of the site, to the species or habitat conservation strategy in order to implement and/or build a Management Plan.</p>",
    closeOnEsc = TRUE,
    closeOnClickOutside = FALSE,
    html = TRUE,
    type = "info",
    showConfirmButton = TRUE,
    confirmButtonText = "I know the use cases and I want to work on tools.",
    confirmButtonCol = "#AEDEF4",
    showCancelButton = TRUE,
    cancelButtonText = "I want to have more information on how the two use cases can be solved with the tools developed in the ECOSS project.",
    timer = 0,
    imageUrl = "",
    animation = TRUE,
    callbackJS = "function(x) { if (x !== true) { window.open('https://ecoads.eu/static/toolsDoc/', '_blank'); } }"
  )
  
  output$testo <- renderText({
    # deimsId()
    id = n2kId()
    return(id)
  })
  
  startTab <- reactive({
    stab<-"contrib"
    queryString <- parseQueryString(session$clientData$url_search)
    if(!is.null(queryString$tab) && queryString$tab=="conservation"){
      stab <- "conser"
    }
    return(stab)
  })
  
  #output$prova<-renderText({startTab()})
  
  observeEvent(startTab(),{
    warning("observeEvent(startTab()): ",startTab())
    updateTabItems(session,"maintabmenu",startTab())
  })
  
  deimsId <- reactive({
    siteId = defaultDeimsId
    queryString <- parseQueryString(session$clientData$url_search)
    if (!is.null(queryString$siteid)) {
      siteId = siteId <- queryString$siteid
    }
    return(siteId)
  })
  
  n2kId <- reactive({
    n2kId <- dt_sites %>% 
      dplyr::filter(siteCodeDEIMS == deimsId()) %>%
      dplyr::select(siteCodeN2K) %>% 
      dplyr::pull()
    # if (is.na(n2kId)) {
    #   n2kId = defaultN2kId
    # }
    return(n2kId)
  })
  
  # for Queries ######
  fusekiEcoss <- "http://fuseki1.get-it.it/ecoss/query"
  
  queryConserv <- reactive({
    q = paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                   PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                   PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
                   PREFIX eunissiteswebpages: <https://eunis.eea.europa.eu/sites/>
                   PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                   PREFIX eunisspecies: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
                   PREFIX ssn: <https://www.w3.org/TR/vocab-ssn/#>
                   PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    
                   # dato un sito, restituisco elenco di tutti i parametri MSDF che hanno corrispondenza con degli envthes parameters che il sito, su DEIMS, dichiara di osservare. Riporto il numero di tali envthes parameters.
                   select ?msfd_Parameter (str(?msfd_Parameter_label1) as ?msfd_Parameter_label) ?msfd_criteria (str(sample(?msfd_criteria_label)) as ?msfd_criteria_label1) (count(?envthesparam) as ?numeroParametriMisurati_ENVTHES_InerentiIlParametroMSFD)
                   where {
                     bind(<https://deims.org/",
               deimsId(),
               "> as ?site)
                     ?site ecoss:observes ?envthesparam .
                     #SERVICE <http://vocabs.ceh.ac.uk/edg/tbl/sparql>{
                     # 	GRAPH <urn:x-evn-master:EnvThes>{
                     #   	?envthesparam skos:prefLabel ?envthesparam_label .
                     #	}
                     # 	FILTER(LANG(?envthesparam_label)='en')
                     #	}  
                     ?ecos_var skos:closeMatch|skos:exactMatch ?envthesparam .
                     ?ecos_var a ecoss:ecoss_Variable ;
                       skos:prefLabel ?ecos_var_label .
                     ?ecos_var skos:closeMatch|skos:exactMatch|skos:relatedMatch ?msfd_Parameter .
                     ?msfd_Parameter a ecoss:msfd_Parameter ;
                       skos:prefLabel ?msfd_Parameter_label1 .
                     ?msfd_Parameter ecoss:contributesToEvaluate ?msfd_criteria .
                       ?msfd_criteria skos:prefLabel ?msfd_criteria_label .
                   }
                   group by ?msfd_Parameter ?msfd_Parameter_label1 ?msfd_criteria")
    return(q)
    })
  
  contrib <- reactive({SPARQL::SPARQL(
    curl_args = list(.encoding="UTF-8"),
    url = fusekiEcoss, 
    query = queryConserv()
  )$results %>% 
    as_tibble()})
  
  
  # query for site info #####
  querySite <- reactive({
    if (!is.na(n2kId())) {
      q = paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                 PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                 PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
                 PREFIX eunissiteswebpages: <https://eunis.eea.europa.eu/sites/>
                 PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                 PREFIX eunissitesSchema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
                 PREFIX eunisspecies: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
                 PREFIX ssn: <https://www.w3.org/TR/vocab-ssn/#>
                 PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                 # query per info aggiuntive del sito (sostituire l'uri in 'bind')
                 select distinct ?site ?site_name ?site_manager ?site_respondent where{
                   bind(<http://eunis.eea.europa.eu/sites/",
                 n2kId(),
                 "> as ?site)
                   #?any ecoss:recommendedForSite ?site .
                   service <https://semantic.eea.europa.eu/sparql>{      
                     ?site eunissitesSchema:name ?site_name .
                     optional{?site eunissitesSchema:respondent ?site_respondent .}
                     optional{?site eunissitesSchema:manager ?site_manager .}     
                   }
                 }")
      return(q)
    } else {
      q = paste0("select distinct ?site ?site_name ?site_manager ?site_respondent where{
                  bind(<http://deims.org/", deimsId(),"> as ?site)
                  bind('",dt_sites %>% filter(siteCodeDEIMS == deimsId()) %>% pull(name),"' as ?site_name)
                  bind('' as ?site_manager)
                  bind('' as ?site_respondent)}")
    }
    return(q)
  })
  
  siteInfo <- reactive({
    # table structure granted in this case by querySite()
    SPARQL::SPARQL(
    curl_args = list(.encoding="UTF-8"),
    url = fusekiEcoss, 
    query = querySite()
  )$results %>% 
    as_tibble()
  })
  
  # query for specie info #####
  querySpecie <- reactive({
  q = paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                 PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                 PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
                 PREFIX eunissiteswebpages: <https://eunis.eea.europa.eu/sites/>
                 PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                 PREFIX eunissitesSchema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
                 PREFIX eunisspecies: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
                 PREFIX ssn: <https://www.w3.org/TR/vocab-ssn/#>
                 PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                 # query per info aggiuntive del sito (sostituire l'uri in 'bind')
                 select distinct ?site ?species ?species_label ?species_PESI where{
                   bind(<http://eunis.eea.europa.eu/sites/",
                   n2kId(), "> as ?site)
                   #?any ecoss:recommendedForSite ?site .
                   service <https://semantic.eea.europa.eu/sparql>{      
                     ?site eunissitesSchema:hasSpecies ?species .
                     ?species <http://www.w3.org/2000/01/rdf-schema#label> ?species_label .
                     optional{?species  eunisspecies:sameSynonymPESI ?species_PESI .}
                   }
                 }")
  return(q)
  })
  
  specieInfo <- reactive({
    tbl_structure<-tibble::tribble(~site ,~species ,~species_label ,~species_PESI ,~isEcoss)
    
    res <- SPARQL::SPARQL(
      curl_args = list(.encoding="UTF-8"),
      url = fusekiEcoss, 
      query = querySpecie()
    )$results %>% as_tibble()
    
    if(nrow(res)>0)
      return(res %>% dplyr::inner_join(spEcoss %>% dplyr::mutate(isEcoss = TRUE)))
    else
      return(tbl_structure)
    
  })
  
  # query for habitat info #####
  queryHabitat <- reactive({
    q = paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                   PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                   PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
                   PREFIX eunissiteswebpages: <https://eunis.eea.europa.eu/sites/>
                   PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                   PREFIX eunissitesSchema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
                   PREFIX eunisspecies: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
                   PREFIX ssn: <https://www.w3.org/TR/vocab-ssn/#>
                   PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                   select distinct ?site ?habitat ?habitat_label ?habitat_description where{
                     bind(<http://eunis.eea.europa.eu/sites/",
               n2kId(), "> as ?site)
                     #?any ecoss:recommendedForSite ?site .
                     service <https://semantic.eea.europa.eu/sparql>{      
                       ?site eunissitesSchema:hasHabitatType ?habitat .
                       ?habitat <http://www.w3.org/2000/01/rdf-schema#label> ?habitat_label .
                       optional{?habitat <http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#description> ?habitat_description .}
                     }
                  }")
    return(q)
  })
  
  habitatInfo <- reactive({
    tbl_structure <-
      tibble::tribble( ~ site, ~ habitat, ~ habitat_label, ~ habitat_description)
    
    res <- SPARQL::SPARQL(
      curl_args = list(.encoding = "UTF-8"),
      url = fusekiEcoss,
      query = queryHabitat()
    )$results %>%
      as_tibble()
    
    if (nrow(res) > 0)
      return(res %>% dplyr::inner_join(habEcoss %>% dplyr::mutate(isEcoss = TRUE)))
    else
      return(tbl_structure)
  })
  
  # query for extract ECOSS recommended variables for the site ######
  queryConservEcoss <- reactive({
    q = paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                        PREFIX eunissitesSchema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
                        PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                          
                          ##(NOTA: non ci sono raccomandazioni di variabili ecoss per siti deims, ma solo per siti n2k)
                          # Dato un sito n2k restituisco 
                          #  1. tutte le variabili ecoss raccomandate per il sito
                          select ?n2k_site_uri ?ecos_var_label ?ecos_var_uri
                        where {
                          bind(eunissites:",
               n2kId(), " as ?n2k_site_uri) #CRES-LOSINI
                          #service <https://semantic.eea.europa.eu/sparql>{      
                          #  ?site eunissitesSchema:name ?site_name .    
                          #}
                          #?ecos_var skos:closeMatch|skos:exactMatch ?envthesparam .
                          ?ecos_var_uri a ecoss:ecoss_Variable ;
                          ecoss:recommendedForSite ?n2k_site_uri;
                          skos:prefLabel ?ecos_var_label .
                        }")
    return(q)
  })
  
  allVarsRecom <- reactive({
    tbl_structure<-tibble::tribble(~n2k_site_uri, ~ecos_var_label, ~ecos_var_uri)
    
    res <- SPARQL::SPARQL(
      curl_args = list(.encoding = "UTF-8"),
      url = fusekiEcoss,
      query = queryConservEcoss()
    )$results %>%
      as_tibble()
    
    if (nrow(res) > 0)
      return(res)
    else
      return(tbl_structure)
  })
  
  # query for extract ECOSS recommended variables measured in the site #####
  queryConservEcossMeasured <- reactive({
    q = paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                                PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                                PREFIX eunissitesSchema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
                                PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                                
                                ##(NOTA: non ci sono raccomandazioni di variabili ecoss per siti deims, ma solo per siti n2k: il deims_id di questa query va creato in R via lookup n2k_id->deims_id)
                                # Dato un sito n2k restituisco 
                                #  2. tutte le variabili ecoss raccomandate per il sito che effettivamente il sito dichiara di osservare.
                                select ?n2k_site_uri ?deims_site_uri ?ecos_var_label ?ecos_var_uri ?envthesMatch ?envthesMatch_label
                                where {
                                bind(eunissites:",
                                n2kId(),
                                " as ?n2k_site_uri)
                                bind(<https://deims.org/",
                                deimsId(),
                                "> as ?deims_site_uri) #questa corrispondenza va costruita a mano (ossia: in R) finché non la inseriamo in triple.
                                bind('TBD' as ?envthesMatch_label) # not useful at the moment
                                #service <https://semantic.eea.europa.eu/sparql>{      
                                #  ?site eunissitesSchema:name ?site_name .    
                                #}
                                #?ecos_var skos:closeMatch|skos:exactMatch ?envthesparam .
                                ?ecos_var_uri a ecoss:ecoss_Variable ;
                                ecoss:recommendedForSite ?n2k_site_uri;
                                skos:prefLabel ?ecos_var_label ;
                                skos:exactMatch|skos:closeMatch|skos:narrowMatch|skos:relatedMatch|skos:broadMatch ?envthesMatch .
                                #SERVICE <http://vocabs.ceh.ac.uk/edg/tbl/sparql>{
                                #  GRAPH <urn:x-evn-master:EnvThes>{
                                #    ?envthesMatch skos:prefLabel ?envthesMatch_label .
                                #  }
                                #  FILTER(LANG(?envthesMatch_label)='en')
                                #}  
                                ?deims_site_uri ecoss:observes ?envthesMatch
                              }")
    return(q)
  })
  
  allVarsMeasured <- reactive({
    
    tbl_structure<-tibble::tribble(
      ~n2k_site_uri, ~deims_site_uri, ~ecos_var_label,~ecos_var_uri,~envthesMatch,~envthesMatch_label)
    
    contents<-
      SPARQL::SPARQL(
        curl_args = list(.encoding="UTF-8"),
        url = fusekiEcoss, 
        query = queryConservEcossMeasured()
        )$results %>% 
      as_tibble()
    
    res<-rbind(tbl_structure,contents)
    
    })
    
  
  allVarsECOSS <- reactive({
    allVarsRecom() %>%
    dplyr::left_join(
      allVarsMeasured() %>% 
        dplyr::mutate(isMeasured = TRUE) %>% 
        dplyr::select(-ecos_var_label, -deims_site_uri, -envthesMatch, -envthesMatch_label)
      ) %>% 
    unique()})

  # some global info #####
  siteName <- reactive({siteInfo()$site_name})
  siteManager <- reactive({siteInfo()$site_manager})
  siteRespondent <- reactive({siteInfo()$site_respondent})
  siteUrl <- reactive({sub('>', '', sub('<', '', siteInfo()$site))})
  
  allVarsECOSSTrue <- reactive({allVarsECOSS() %>% 
    dplyr::filter(isMeasured == TRUE) %>% 
    unique()})
  
  allVarsECOSSNa <- reactive({allVarsECOSS() %>% 
    dplyr::filter(is.na(isMeasured)) %>% 
    unique()})
  
  
  # Server fixed station #####
  source("servers/contributeDirectiveServer.R", local = TRUE)$value
  
  # Server profile #####
  source("servers/conservationStrategyServer.R", local = TRUE)$value
  
})
###
# Sources #####
###
# source("functions.R", local = TRUE)$value

###
# Server #####
###
shinyServer(function(input, output, session) {
  
  output$testo <- renderText({
      queryString <- parseQueryString(session$clientData$url_search)
      siteId <- queryString$site
      siteId
  })
  
  # for Queries ######
  library('SPARQL')
  library('dplyr')
  fusekiEcoss <- "http://fuseki1.get-it.it/ecoss/query"
  
  # to be define!!!! #####
  queryConserv <- "PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                   PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                   PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
                   PREFIX eunissiteswebpages: <https://eunis.eea.europa.eu/sites/>
                   PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                   PREFIX eunisspecies: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
                   PREFIX ssn: <https://www.w3.org/TR/vocab-ssn/#>
                   PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    
                   # dato un sito, restituisco elenco di tutti i parametri MSDF che hanno corrispondenza con degli envthes parameters che il sito, su DEIMS, dichiara di osservare. Riporto il numero di tali envthes parameters.
                   select ?msfd_Parameter_label ?msfd_criteria (sample(?msfd_criteria_label) as ?msfd_criteria_label1) (count(?envthesparam_label) as ?numeroParametriMisurati_ENVTHES_InerentiIlParametroMSFD)
                   where {
                     bind(<https://deims.org/2e6014fe-8f3b-4127-8ab1-405ae1303281> as ?site)
                     ?site ecoss:observes ?envthesparam .
                     SERVICE <http://vocabs.ceh.ac.uk/edg/tbl/sparql>{
                       	GRAPH <urn:x-evn-master:EnvThes>{
                         	?envthesparam skos:prefLabel ?envthesparam_label .
                       	}
                       	FILTER(LANG(?envthesparam_label)='en')
                     	}  
                     ?ecos_var skos:closeMatch|skos:exactMatch ?envthesparam .
                     ?ecos_var a ecoss:ecoss_Variable ;
                       skos:prefLabel ?ecos_var_label .
                     ?ecos_var skos:closeMatch|skos:exactMatch|skos:relatedMatch ?msfd_Parameter .
                     ?msfd_Parameter a ecoss:msfd_Parameter ;
                       skos:prefLabel ?msfd_Parameter_label .
                     ?msfd_Parameter ecoss:contributesToEvaluate ?msfd_criteria .
                       ?msfd_criteria skos:prefLabel ?msfd_criteria_label .
                   }
                   group by ?msfd_Parameter_label ?msfd_criteria"
  
  contrib <- SPARQL::SPARQL(
    url = fusekiEcoss, 
    query = queryConserv
  )$results %>% 
    as_tibble()
  
  
  # query for site info #####
  querySite <-  "PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
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
                   bind(<http://eunis.eea.europa.eu/sites/IT3330009> as ?site)
                   #?any ecoss:recommendedForSite ?site .
                   service <https://semantic.eea.europa.eu/sparql>{      
                     ?site eunissitesSchema:name ?site_name .
                     optional{?site eunissitesSchema:respondent ?site_respondent .}
                     optional{?site eunissitesSchema:manager ?site_manager .}     
                   }
                 }"
  
  siteInfo <- SPARQL::SPARQL(
    url = fusekiEcoss, 
    query = querySite
  )$results %>% 
    as_tibble()
  
  # query for specie info #####
  querySpecie <- "PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
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
                   bind(<http://eunis.eea.europa.eu/sites/IT3330009> as ?site)
                   #?any ecoss:recommendedForSite ?site .
                   service <https://semantic.eea.europa.eu/sparql>{      
                     ?site eunissitesSchema:hasSpecies ?species .
                     ?species <http://www.w3.org/2000/01/rdf-schema#label> ?species_label .
                     optional{?species  eunisspecies:sameSynonymPESI ?species_PESI .}
                   }
                 }"
  
  specieInfo <- SPARQL::SPARQL(
    url = fusekiEcoss, 
    query = querySpecie
  )$results %>% 
    as_tibble()
  
  # query for habitat info #####
  queryHabitat <- "PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                   PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                   PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
                   PREFIX eunissiteswebpages: <https://eunis.eea.europa.eu/sites/>
                   PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                   PREFIX eunissitesSchema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
                   PREFIX eunisspecies: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
                   PREFIX ssn: <https://www.w3.org/TR/vocab-ssn/#>
                   PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                   select distinct ?site ?habitat ?habitat_label ?habitat_description where{
                     bind(<http://eunis.eea.europa.eu/sites/IT3330009> as ?site)
                     #?any ecoss:recommendedForSite ?site .
                     service <https://semantic.eea.europa.eu/sparql>{      
                       ?site eunissitesSchema:hasHabitatType ?habitat .
                       ?habitat <http://www.w3.org/2000/01/rdf-schema#label> ?habitat_label .
                       optional{?habitat <http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#description> ?habitat_description .}
                     }
                  }"
  
  habitatInfo <- SPARQL::SPARQL(
    url = fusekiEcoss, 
    query = queryHabitat
  )$results %>% 
    as_tibble()
  
  # query for extract ECOSS recommended variables for the site ######
  queryConservEcoss <- "PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                        PREFIX eunissitesSchema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
                        PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                          
                          ##(NOTA: non ci sono raccomandazioni di variabili ecoss per siti deims, ma solo per siti n2k)
                          # Dato un sito n2k restituisco 
                          #  1. tutte le variabili ecoss raccomandate per il sito
                          select ?n2k_site_uri ?ecos_var_label ?ecos_var_uri
                        where {
                          bind(eunissites:HR3000161 as ?n2k_site_uri) #CRES-LOSINI
                          #service <https://semantic.eea.europa.eu/sparql>{      
                          #  ?site eunissitesSchema:name ?site_name .    
                          #}
                          #?ecos_var skos:closeMatch|skos:exactMatch ?envthesparam .
                          ?ecos_var_uri a ecoss:ecoss_Variable ;
                          ecoss:recommendedForSite ?n2k_site_uri;
                          skos:prefLabel ?ecos_var_label .
                        }"
  
  allVarsRecom <- SPARQL::SPARQL(
    url = fusekiEcoss, 
    query = queryConservEcoss
  )$results %>% 
    as_tibble()
  
  # query for extract ECOSS recommended variables measured in the site #####
  queryConservEcossMeasured <- "PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                                PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                                PREFIX eunissitesSchema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
                                PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                                
                                ##(NOTA: non ci sono raccomandazioni di variabili ecoss per siti deims, ma solo per siti n2k: il deims_id di questa query va creato in R via lookup n2k_id->deims_id)
                                # Dato un sito n2k restituisco 
                                #  2. tutte le variabili ecoss raccomandate per il sito che effettivamente il sito dichiara di osservare.
                                select ?n2k_site_uri ?deims_site_uri ?ecos_var_label ?ecos_var_uri ?envthesMatch ?envthesMatch_label
                                where {
                                bind(eunissites:HR3000161 as ?n2k_site_uri) #CRES-LOSINI
                                bind(<https://deims.org/2e6014fe-8f3b-4127-8ab1-405ae1303281> as ?deims_site_uri) #questa corrispondenza va costruita a mano (ossia: in R) finché non la inseriamo in triple.
                                #service <https://semantic.eea.europa.eu/sparql>{      
                                #  ?site eunissitesSchema:name ?site_name .    
                                #}
                                #?ecos_var skos:closeMatch|skos:exactMatch ?envthesparam .
                                ?ecos_var_uri a ecoss:ecoss_Variable ;
                                ecoss:recommendedForSite ?n2k_site_uri;
                                skos:prefLabel ?ecos_var_label ;
                                skos:exactMatch|skos:closeMatch ?envthesMatch .
                                SERVICE <http://vocabs.ceh.ac.uk/edg/tbl/sparql>{
                                  GRAPH <urn:x-evn-master:EnvThes>{
                                    ?envthesMatch skos:prefLabel ?envthesMatch_label .
                                  }
                                  FILTER(LANG(?envthesMatch_label)='en')
                                }  
                                ?deims_site_uri ecoss:observes ?envthesMatch
                              }"
  
  allVarsMeasured <- SPARQL::SPARQL(
    url = fusekiEcoss, 
    query = queryConservEcossMeasured
  )$results %>% 
    as_tibble()

  # some global info #####
  siteName <- siteInfo$site_name
  siteManager <- siteInfo$site_manager
  siteRespondent <- siteInfo$site_respondent
  siteUrl <- sub('>', '', sub('<', '', siteInfo$site))
  
  # Server fixed station #####
  source("servers/contributeDirectiveServer.R", local = TRUE)$value
  
  # Server profile #####
  source("servers/conservationStrategyServer.R", local = TRUE)$value
  
})
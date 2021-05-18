deimsId <- '6869436a-80f4-4c6d-954b-a730b348d7ce'
n2kId <- ''

fusekiEcoss <- "http://fuseki1.get-it.it/ecoss/query"
queryConserv <- paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                   PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                   PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
                   PREFIX eunissiteswebpages: <https://eunis.eea.europa.eu/sites/>
                   PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                   PREFIX eunisspecies: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
                   PREFIX ssn: <https://www.w3.org/TR/vocab-ssn/#>
                   PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    
                   # dato un sito, restituisco elenco di tutti i parametri MSDF che hanno corrispondenza con degli envthes parameters che il sito, su DEIMS, dichiara di osservare. Riporto il numero di tali envthes parameters.
                   select ?msfd_Parameter ?msfd_Parameter_label ?msfd_criteria (sample(?msfd_criteria_label) as ?msfd_criteria_label1) (count(?envthesparam_label) as ?numeroParametriMisurati_ENVTHES_InerentiIlParametroMSFD)
                   where {
                     bind(<https://deims.org/",
             deimsId,
             "> as ?site)
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
                   group by ?msfd_Parameter ?msfd_Parameter_label ?msfd_criteria
             ")

contrib <- SPARQL::SPARQL(
  curl_args = list(.encoding="UTF-8"),
  url = fusekiEcoss, 
  query = queryConserv
)$results %>% 
    tibble::as_tibble()

# query for site info #####
querySite <- paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
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
                    n2kId,
                    "> as ?site)
                   #?any ecoss:recommendedForSite ?site .
                   service <https://semantic.eea.europa.eu/sparql>{      
                     ?site eunissitesSchema:name ?site_name .
                     optional{?site eunissitesSchema:respondent ?site_respondent .}
                     optional{?site eunissitesSchema:manager ?site_manager .}     
                   }
                 }")

querySite <- paste0("select distinct ?site ?site_name ?site_manager ?site_respondent where{
                  bind(<http://deims.org/",deimsId,"> as ?site)
                  bind('",dt_sites %>% filter(siteCodeDEIMS==deimsId) %>% pull(name),"' as ?site_name)
                  bind('' as ?site_manager)
                  bind('' as ?site_respondent)}")

siteInfo <- SPARQL::SPARQL(
  curl_args = list(.encoding="UTF-8"),
  url = fusekiEcoss, 
  query = querySite
)$results %>% 
  as_tibble()

# some global info #####
siteName <- siteInfo$site_name
siteManager <- siteInfo$site_manager
siteRespondent <- siteInfo$site_respondent
siteUrl <- sub('>', '', sub('<', '', siteInfo$site))

nodes <- tibble::tibble(
  id = c(
    siteInfo$site,
    unique(contrib$msfd_Parameter),
    unique(contrib$msfd_criteria)
  ),
  label = c(
    siteInfo$site_name,
    unique(contrib$msfd_Parameter_label),
    unique(contrib$msfd_criteria_label1)
  ),
  level = c(
    1,
    replicate(length(unique(contrib$msfd_Parameter_label)), 2),
    replicate(length(unique(contrib$msfd_criteria_label1)), 3)
  ),
  group = c(
    'Site',
    replicate(length(unique(contrib$msfd_Parameter_label)), 'MSFD parameter'),
    replicate(length(unique(contrib$msfd_criteria_label1)), 'MSFD Criteria')
  )
) %>%
  dplyr::filter(id != siteInfo$site)

relation1 <- tibble::tibble(
  from = replicate(length(unique(contrib$msfd_Parameter)), siteInfo$site),
  to = unique(contrib$msfd_Parameter),
  weight = 2
) 

relation2 <- contrib %>% 
  dplyr::select(
    from = msfd_Parameter, 
    to = msfd_criteria,
    weight = numeroParametriMisurati_ENVTHES_InerentiIlParametroMSFD
  )

edges <- rbind(
  relation1,
  relation2
) %>%
  dplyr::filter(from != siteInfo$site)

visNetwork(nodes, edges) %>%
  visNodes(
    shadow = TRUE
  ) %>% 
  visHierarchicalLayout(direction = "LR", levelSeparation = 500) %>% 
  visEdges(color = list(color = "lightblue")) %>% 
  visGroups(groupname = "Site", shape = "icon", 
            icon = list(code = "f041", color = "black")) %>%
  visGroups(groupname = "MSFD parameter", shape = "icon", 
            icon = list(code = "f10c", color = "lightblue")) %>%
  visGroups(groupname = "MSFD Criteria", shape = "icon", 
            icon = list(code = "f10c", color = "blue")) %>%
  addFontAwesome() %>% 
  visLegend() %>% 
  visPhysics(solver = "barnesHut") %>% 
  visExport()
# visIgraphLayout() %>%
# visOptions(manipulation = TRUE, nodesIdSelection = TRUE,
# highlightNearest = list(enabled = T, degree = 2, hover = T))











# query for specie info #####
querySpecie <- paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
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
             n2kId, "> as ?site)
                   #?any ecoss:recommendedForSite ?site .
                   service <https://semantic.eea.europa.eu/sparql>{      
                     ?site eunissitesSchema:hasSpecies ?species .
                     ?species <http://www.w3.org/2000/01/rdf-schema#label> ?species_label .
                     optional{?species  eunisspecies:sameSynonymPESI ?species_PESI .}
                   }
                 }")

specieInfo <- SPARQL::SPARQL(
  curl_args = list(.encoding="UTF-8"),
  url = fusekiEcoss, 
  query = querySpecie
)$results %>% 
    as_tibble() %>% 
  dplyr::inner_join(spEcoss %>% dplyr::mutate(isEcoss = TRUE))

# query for habitat info #####
queryHabitat <- paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
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
             n2kId, "> as ?site)
                     #?any ecoss:recommendedForSite ?site .
                     service <https://semantic.eea.europa.eu/sparql>{      
                       ?site eunissitesSchema:hasHabitatType ?habitat .
                       ?habitat <http://www.w3.org/2000/01/rdf-schema#label> ?habitat_label .
                       optional{?habitat <http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#description> ?habitat_description .}
                     }
                  }")

habitatInfo <- SPARQL::SPARQL(
  curl_args = list(.encoding="UTF-8"),
  url = fusekiEcoss, 
  query = queryHabitat
)$results %>% 
    as_tibble() %>% 
  dplyr::inner_join(habEcoss %>% dplyr::mutate(isEcoss = TRUE))


# query for extract ECOSS recommended variables for the site ######
queryConservEcoss <- paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                        PREFIX eunissitesSchema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
                        PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                          
                          ##(NOTA: non ci sono raccomandazioni di variabili ecoss per siti deims, ma solo per siti n2k)
                          # Dato un sito n2k restituisco 
                          #  1. tutte le variabili ecoss raccomandate per il sito
                          select ?n2k_site_uri ?ecos_var_label ?ecos_var_uri
                        where {
                          bind(eunissites:",
             n2kId, " as ?n2k_site_uri) #CRES-LOSINI
                          #service <https://semantic.eea.europa.eu/sparql>{      
                          #  ?site eunissitesSchema:name ?site_name .    
                          #}
                          #?ecos_var skos:closeMatch|skos:exactMatch ?envthesparam .
                          ?ecos_var_uri a ecoss:ecoss_Variable ;
                          ecoss:recommendedForSite ?n2k_site_uri;
                          skos:prefLabel ?ecos_var_label .
                        }")

allVarsRecom <- SPARQL::SPARQL(
  curl_args = list(.encoding="UTF-8"),
  url = fusekiEcoss, 
  query = queryConservEcoss
)$results %>% 
    as_tibble()

# query for extract ECOSS recommended variables measured in the site #####
queryConservEcossMeasured <- paste0("PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
                                PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                                PREFIX eunissitesSchema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
                                PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>
                                
                                ##(NOTA: non ci sono raccomandazioni di variabili ecoss per siti deims, ma solo per siti n2k: il deims_id di questa query va creato in R via lookup n2k_id->deims_id)
                                # Dato un sito n2k restituisco 
                                #  2. tutte le variabili ecoss raccomandate per il sito che effettivamente il sito dichiara di osservare.
                                select ?n2k_site_uri ?deims_site_uri ?ecos_var_label ?ecos_var_uri ?envthesMatch ?envthesMatch_label
                                where {
                                bind(eunissites:",
             n2kId,
             " as ?n2k_site_uri)
                                bind(<https://deims.org/",
             deimsId,
             "> as ?deims_site_uri) #questa corrispondenza va costruita a mano (ossia: in R) finché non la inseriamo in triple.
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
                              }")

allVarsMeasured <- SPARQL::SPARQL(
  curl_args = list(.encoding="UTF-8"),
  url = fusekiEcoss, 
  query = queryConservEcossMeasured
)$results %>% 
    as_tibble()

allVarsECOSS <- allVarsRecom %>%
    dplyr::left_join(
      allVarsMeasured %>% 
        dplyr::mutate(isMeasured = TRUE) %>% 
        dplyr::select(-ecos_var_label, -deims_site_uri, -envthesMatch, -envthesMatch_label)
    ) %>% 
    unique()

allVarsECOSSTrue <- allVarsECOSS %>% 
  dplyr::filter(isMeasured == TRUE) %>% 
  unique()

allVarsECOSSNa <- allVarsECOSS %>% 
  dplyr::filter(is.na(isMeasured)) %>% 
  unique()

nodes <- tibble::tibble(
  id = c(
    siteInfo$site,
    specieInfo$species,
    allVarsECOSSTrue$ecos_var_uri,
    allVarsECOSSNa$ecos_var_uri
  ),
  label = c(
    siteInfo$site_name,
    specieInfo$species_label,
    allVarsECOSSTrue$ecos_var_label,
    allVarsECOSSNa$ecos_var_label
  ),
  group = c(
    'Site',
    replicate(nrow(specieInfo), 'Specie'),
    replicate(nrow(allVarsECOSSTrue), 'Parameters measured'),
    replicate(nrow(allVarsECOSSNa), 'Parameters recommend')
  )
)

edges <- tibble::tibble(
  from = replicate((nrow(nodes)-1), nodes$id[1]),
  to = c(
    specieInfo$species,
    allVarsECOSSTrue$ecos_var_uri,
    allVarsECOSSNa$ecos_var_uri),
  weight = replicate((nrow(nodes)-1), 2)
)

visNetwork(nodes, edges) %>%
  visLayout(
    randomSeed = 10
  ) %>% 
  visNodes(
    shadow = TRUE
  ) %>% 
  visEdges(color = list(color = "lightblue")) %>% 
  visGroups(groupname = "Site", shape = "icon", 
            icon = list(code = "f041", color = "black")) %>%
  visGroups(groupname = "Specie", shape = "icon", 
            icon = list(code = "f2da", color = "blue")) %>% 
  visGroups(groupname = "Parameters recommend", shape = "icon", 
            icon = list(code = "f10c", color = "red")) %>%
  visGroups(groupname = "Parameters measured", shape = "icon", 
            icon = list(code = "f05d", color = "green")) %>%
  addFontAwesome() %>% 
  visLegend() %>% 
  visPhysics(solver = "barnesHut") %>% 
  visExport()
# visIgraphLayout() %>%
# visOptions(manipulation = TRUE, nodesIdSelection = TRUE,
# highlightNearest = list(enabled = T, degree = 2, hover = T))




require(SPARQL)
require(tibble)
require(dplyr)

#site <- 'IT3270023'

db_ecoss<-function(sparqlEndpoint){
  self<-list()
  # constants
  {
    endpoint <- sparqlEndpoint
    
    GENERAL_prefix <- 'PREFIX foaf:  <http://xmlns.com/foaf/0.1/>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX eunisspeciesschema: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
    PREFIX eunissitesschema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
    PREFIX eunishabitatsschema: <http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#>
    PREFIX eunisspecies: <http://eunis.eea.europa.eu/species/>
    PREFIX eunishabitats: <http://eunis.eea.europa.eu/habitats/>
    PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>'
    
    # SET this list with structures of the form:
    #     - prefix (it is the prefix of namespaces of the response to the query)
    #     - q: the sparql query
    dataSources<-list(
      m2m_sites_habitats = list(
        prefix = c('eunishabitatsschema', '<http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#>'),
        q = "SELECT ?site ?habitats
        WHERE{
        BIND(<http://eunis.eea.europa.eu/sites/$SITECODE$> as ?site)
        SERVICE <https://semantic.eea.europa.eu/sparql>{
        ?site eunissitesschema:hasHabitatType ?habitats.
        }
        }"),
      m2m_sites_species = list(
        prefix = c('eunishabitatsschema', '<http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#>'),
        q = "PREFIX eunishabitats: <http://eunis.eea.europa.eu/habitats/>
    SELECT ?site ?species
    WHERE{
    BIND(<http://eunis.eea.europa.eu/sites/$SITECODE$> as ?site)
    SERVICE <https://semantic.eea.europa.eu/sparql>{
    ?site eunissitesschema:hasSpecies ?species.
    }
    }")
    )
  }
  
  # internal functions
  {
    composeQuery <- function (siteCode, q) {
      return(gsub("$SITECODE$", siteCode, gsub("\n", "", paste(GENERAL_prefix, q)), fixed = T))
    }
  }
  # instance variables (internal)
  {
    dt_sites = 
      tibble::tribble(
        ~name, ~siteCodeN2K, ~siteCodeDEIMS, ~eLTERNetwork, ~N2KNetwork,
        "Delta del Po e Costa Romagnola", NA, "6869436a-80f4-4c6d-954b-a730b348d7ce", TRUE, FALSE,
        "Golfo di Trieste", NA, "96969205-cfdf-41d8-979f-ff881ea8dc8b", TRUE, FALSE,
        "Golfo di Venezia", NA, "758087d7-231f-4f07-bd7e-6922e0c283fd", TRUE, FALSE,
        "Transetto Senigallia-Susak", NA, "be8971c2-c708-4d6e-a4c7-f49fcf1623c1", TRUE, FALSE,
        "Cres - Lošinj",  "HR3000161", "2e6014fe-8f3b-4127-8ab1-405ae1303281", FALSE, TRUE,
        "Delta del Po",  "IT3270023", "1eb7d806-7534-4c29-95d2-2db5d1bad362", FALSE, TRUE,
        "Delta del Po: tratto terminale e delta veneto",  "IT3270017", "6b96c97f-cc81-41fd-bc18-3105d2ee112a", FALSE, TRUE,
        "Malostonski zaljev",  "HR4000015", "8b7b96c3-7656-43b3-8c60-3598b91c1a92", FALSE, TRUE,
        "Tegnùe di Chioggia",  "IT3250047", "988c738d-9240-4d54-99c2-0ca0116c9196", FALSE, TRUE,
        "Trezze San Pietro e Bardelli",  "IT3330009", "61837250-789c-4c0e-8e9e-85a06b07bbaa", FALSE, TRUE,
        "Viški akvatorij",  "HR3000469", "32f7c197-a371-4a31-93a5-a419f102e18d", FALSE, TRUE
      )
    
    dt_species=NULL
    dt_habitats=NULL
    dt_observables=NULL
    dt_directives=NULL
    
    m2m_sites_species=NULL
    m2m_sites_habitats=NULL
    m2m_sites_observables=NULL
    m2m_observables_directives=NULL
  }
  
  init<-function(){
    
    tryCatch({
      res<-list()
      # PUT CODE TO INIT entities here
      entities <- names(dataSources)
      sites <- dt_sites %>%  filter(N2KNetwork) %>% select(siteCodeN2K) %>% as.data.frame()
      for (n in entities) {
        #n<-'m2m_site_habitats'
        res[[n]]<-NULL
        for(s in sites$siteCodeN2K){
          #s<-sites[3,1]
          x <- dataSources[[n]]
          query <- composeQuery(siteCode = s, q = x$q)
          ns <- x$prefix
          
          if(is.null(res[[n]])){
            res[[n]]<-as_tibble((SPARQL::SPARQL(url = endpoint, 
                                                               query = query,
                                                               ns = ns)$results))
          }
          else{
            res[[n]]<-
              res[[n]] %>% bind_rows(as_tibble((SPARQL::SPARQL(url = endpoint, 
                                                                              query = query,
                                                                              ns = ns)$results)
              ))
          }
        }
      }
      #print(res)
      
      m2m_sites_species<<-res[["m2m_sites_species"]]
      m2m_sites_habitats<<-res[["m2m_sites_habitats"]]
      rm(res)
    },
    error=function(e){
      warning(e)
    },
    finally=function(){
      message("DB object initialized")
    })
    
  } 
  init()
  
  # export variables
  {
    self$dt_sites<-function(){dt_sites}
    self$m2m_sites_species<-function(){m2m_sites_species}
    self$m2m_sites_habitats<-function(){m2m_sites_habitats}
  } 
  
  return(self)
}

# example usage
if(FALSE){
  db<-db_ecoss("http://fuseki1.get-it.it/ecoss/query")
  
  db$dt_sites()
  db$m2m_sites_species()
  db$m2m_sites_habitats()
}


if(FALSE){
# jqEndpoint <- 'https://deims.org/api/sites/2e6014fe-8f3b-4127-8ab1-405ae1303281'
# jq <- '.[0]|
#         {site_uri:"\(.id.prefix)\(.id.suffix)", site_title:.title, param: .attributes.focusDesignScale.parameters[]} |
#         [.site_uri, .site_title, .param.uri, .param.label] |
#         "<\(.[0])> ecoss:observes <\(.[2])> ."'
}
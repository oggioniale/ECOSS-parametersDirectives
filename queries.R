require(SPARQL)
site <- 'IT3270023'
endpoint <- "http://fuseki1.get-it.it/ecoss/query"

jqEndopoint <- 'https://deims.org/api/sites/2e6014fe-8f3b-4127-8ab1-405ae1303281'
jq <- '.[0]|{site_uri:"\(.id.prefix)\(.id.suffix)", site_title:.title, param: .attributes.focusDesignScale.parameters[]} |
  [.site_uri, .site_title, .param.uri, .param.label] |
  "<\(.[0])> ecoss:observes <\(.[2])> ."'

prefix <- 'PREFIX foaf:  <http://xmlns.com/foaf/0.1/>
      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
      PREFIX eunisspeciesschema: <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
      PREFIX eunissitesschema: <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
      PREFIX eunishabitatsschema: <http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#>
      PREFIX eunisspecies: <http://eunis.eea.europa.eu/species/>
      PREFIX eunishabitats: <http://eunis.eea.europa.eu/habitats/>
      PREFIX eunissites: <http://eunis.eea.europa.eu/sites/>'

dataSources <- list(
  habitats = list(
    prefix = c('eunishabitatsschema', '<http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#>'),
    q = "SELECT ?habitats
      WHERE{
        BIND(<http://eunis.eea.europa.eu/sites/$SITECODE$> as ?site)
        SERVICE <https://semantic.eea.europa.eu/sparql>{
          ?site eunissitesschema:hasHabitatType ?habitats.
        }
      }"),
  species = list(
    prefix = c('eunishabitatsschema', '<http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#>'),
    q = "PREFIX eunishabitats: <http://eunis.eea.europa.eu/habitats/>
      SELECT ?species
      WHERE{
        BIND(<http://eunis.eea.europa.eu/sites/$SITECODE$> as ?site)
        SERVICE <https://semantic.eea.europa.eu/sparql>{
          ?site eunissitesschema:hasSpecies ?species.
        }
      }")
)


composeQuery <- function (siteCode, q) {
  return(gsub("$SITECODE$", siteCode, gsub("\n", "", paste(prefix, q)), fixed = T))
}
entities <- names(dataSources)
results <- list()
# n='habitats'
for (n in entities) {
  x <- dataSources[[n]]
  query <- composeQuery(siteCode = site, q = x$q)
  ns <- x$prefix
  results[[n]] <- SPARQL::SPARQL(url = endpoint, 
                                  query = query,
                                  ns = ns
  )$results
}



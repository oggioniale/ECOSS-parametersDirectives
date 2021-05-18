PREFIX ecoss: <http://rdfdata.get-it.it/ecoss/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core>

# selezionare sito lter ecoss:observes ?param e sua label
# ?param ecoss:contributes_to ?dir
select * WHERE{
  ?msfd_param_uri ecoss:contributesToEvaluate ?msfd_criteria_uri;
  skos:prefLabel ?msfd_param_name .
  ?msfd_criteria_uri skos:prefLabel ?msfd_criteria_name .
}
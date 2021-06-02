
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ECOSS Tools <img src='figures/ECOSSlogo_165x165.jpg' align="right" height="75" />

<!-- badges: start -->

<!-- other badges https://github.com/GuangchuangYu/badger -->

[![](https://img.shields.io/github/languages/code-size/oggioniale/ECOSS-parametersDirectives.svg)](https://github.com/oggioniale/ECOSS-parametersDirectives)
[![](https://img.shields.io/github/last-commit/oggioniale/ECOSS-parametersDirectives.svg)](https://github.com/oggioniale/ECOSS-parametersDirectives/commits/master)
<!-- [![](https://img.shields.io/badge/doi-10.1111/2041--210X.12628-blue.svg)](https://doi.org/10.1111/2041-210X.12628) -->
<!-- badges: end -->

*ECOSS Tools* are part of the implementation work done in the framework
of the [Interreg Italy-Croatia project
ECOSS](https://www.italy-croatia.eu/) WP5 - Design and implementation of
data infrastructure.

*ECOSS Tools* aims at providing interactive applications to respond to
the needs of the sites involved in the [ECOlogical observing system in
the Adriatic Sea (ECOAdS)](https://ecoads.eu) for what concerns
conservation strategies and the contribution to the main EU directives.
The ECOSS Tools provide graphical representations of monitoring
activities at the sites, leveraging the information collected by the
ECOSS project by means of their integration with other information
sources already available in internet.

ECOAdS includes two types of sites: Long Term Ecological Research (LTER)
and Natura 2000 (N2K) sites, belonging to the [LTER
network](https://www.lter-europe.net/lter-europe) and the Natura 2000
network\](<https://ec.europa.eu/environment/nature/natura2000/awards/natura-2000-network/index_en.htm>),
respectively.

*ECOSS Tools* allow to:

1.  Evaluate the LTER-and-N2K sites’ contribution to the Marine Strategy
    Framework Directive (MSFD) monitoring activities (**Directive
    contribution**);

2.  Evaluate the N2K sites’ contribution to the conservation of the
    specific target species and habitats included in the site
    (**Conservation strategy**).

*ECOSS Tools* can be reached starting from the ECOAdS portal, directly
from the map on the HomePage, by accessing each sites page (e.g. [Cres -
Lošinj
page](https://ecoads.eu/site/2e6014fe-8f3b-4127-8ab1-405ae1303281/))
trough the “Tools” section.

The **site contribution** tab contains the tool for the assessment of
the site contribution of the site to MSFD. Within this tool it is
possible to visualize the measured parameters and their relation with
MSFD criteria elements. The **conservation strategy** tab contains the
tool showing the contribution of the N2K site to the conservation of
target species and habitats.

The site contribution is evaluated by the number of observed parameters,
corresponding to the parameters suitable for assessing a MSFD criteria.
The conservation strategy contribution is evaluated by comparing the
number of ecological, oceanographic, and pressure variables measured at
the site with the variables indicated by ECOSS as fundamental for
assessing the state of conservation of the specific target
species/habitat.

During the ECOSS project, great effort was devoted both to identify the
parameters to be monitored in order to accomplish the MSFD criteria
needs and to recognize the variables that better contribute to
conservation strategies. The results of this work are delivered in the
following documents and publications:

  - Gianni et al. (2020)
  - Manea et al. (2020)

<!-- about the icons https://github.com/ikatyang/emoji-cheat-sheet -->

## :notebook\_with\_decorative\_cover: Citation

To cite *ECOSS Tools* please use:

…

## :movie\_camera: Video tutorial

<div class="vembedr">
<div>
<iframe src="https://www.youtube.com/embed/" width="533" height="300" frameborder="0" allowfullscreen=""></iframe>
</div>
</div>

## :chart\_with\_downwards\_trend: Data exploited by the *ECOSS Tools*

*ECOSS Tools* let the visualization of

### List of exploited Thesauri, RDF schemas, and ontologies with corresponding URIs.

  - ECOSS task ontology (with instances):
    <http://rdfdata.get-it.it/ecoss/> It is an rdf schema for several
    entities depicted in the tools. The schema provides classes for
    e.g. ECOSS monitoring variables (Ecologic, Oceanographic and
    Pressure variables identified by the ECOSS project with the aim to
    establish a reference for the monitoring tasks of the project
    sites); Marine Strategy Framework Directive (MSFD) parameters (these
    are atomic observable properties that ECOSS project extracted from
    MSFD documentation); EnvThes Parameters declared by the project
    sites within LTER Europe DEIMS platform; etc. The ECOSS task
    ontology models several relations among its entities so that it is
    possible to make semantic queries in order to investigate, for each
    site, its contribution to the MSFD directive given its actual
    monitoring status (represented by its current metadata provided by
    site managers in DEIMS).
  - EnvThes thesaurus: <http://vocabs.lter-europe.net/EnvThes/>
    Thesaurus for long term ecological research, monitoring,
    experiments. It is the controlled vocabulary of the LTER-Europe
    community. It is based on Simple Knowloedge Organization System
    (SKOS) ontology. EnvThes is exploited by LTER Europe infrastructure,
    and in particular by DEIMS-SDR site metadata catalogue, as the basis
    for semantic interoperability. It is coordinated by Umweltbundesamt
    GmbH, Austria.
  - EEA Eunis Habitat Types schema:
    <http://eunis.eea.europa.eu/rdf/habitats-schema.rdf#> European
    Environment Agency RDF schema for information about the EUNIS
    habitat classification and the EU Habitats Directive Annex I habitat
    types
  - EEA Eunis Sites schema:
    <http://eunis.eea.europa.eu/rdf/sites-schema.rdf#>
  - EEA Eunis Sites (instances): <https://eunis.eea.europa.eu/sites>
    European Environment Agency information encoded in RDF (schema and
    instances) about protected and other designated sites relevant for
    fauna, flora and habitat protection in Europe
  - EEA Eunis Species schema:
    <http://eunis.eea.europa.eu/rdf/species-schema.rdf#>
  - EEA Eunis Species (instances): <http://eunis.eea.europa.eu/species/>
    European Environmental Agencies information about species in Europe,
    particularly species mentioned in legal texts.

### List of SPARQL endpoints.

Third-party SPARQL Endpoints. These are the services to which the *ECOSS
Tools* direct its semantic queries in real-time when you are using the
Apps

  - European Environmental Agency SPARQL endpoint
    <https://semantic.eea.europa.eu/sparql>
  - CEH semantic web editor SPARQL endpoint (it provides access to the
    EnvThes thesaurus): <http://vocabs.ceh.ac.uk/edg/tbl/sparql>

## :writing\_hand: Authors

Alessandro Oggioni <http://www.cnr.it/people/alessandro.oggioni>

Paolo Tagliolato <https://orcid.org/0000-0002-0261-313X>

## :office: Contributing organizations

<a href="http://www.irea.cnr.it/en/"><img src="figures/irea_logo.png" height="40" align="left" /></a><br/>
<br/>

## :books: References

<div id="refs" class="references hanging-indent">

<div id="ref-Gianni2020">

Gianni, Fabrizio, V. Bandelj, Bruno Cataletto, Elisabetta Manea,
Caterina Bergami, Lucia Bongiorni, Alessandro Oggioni, et al. 2020.
“D3.3.1 Report on the Key Oceanographic Processes and Performance
Indicators for Natura 2000 Marine Sites.” ECOSS Project Deleverable
D3.3.1.
<https://www.italy-croatia.eu/documents/289585/0/D3.3.1+Report+on+the+key+oceanographic+processes+and+performance+indicators+for+Natura+2000+marine+sites.pdf/15526fcf-4de2-e6d6-7a9c-f56ca2155cfa?t=1608182937105>.

</div>

<div id="ref-Manea2020">

Manea, Elisabetta, Lucia Bongiorni, Caterina Bergami, and Alessandra
Pugnetti. 2020. “Challenges for Marine Ecological Observatories to
Promote Effective Gms of Natura 2000 Network the Case Study of Ecoads in
the Adriatic Sea.” In, pp. 23–39.
<https://doi.org/10.26383/978-88-8080-402-4>.

</div>

</div>

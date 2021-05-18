library(dplyr)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(DT)
library(shinycssloaders)
library(shinyalert)
require(visNetwork)
library(rintrojs)
library(SPARQL)

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

defaultDeimsId <- '2e6014fe-8f3b-4127-8ab1-405ae1303281'
defaultN2kId <- 'HR3000161'

habEcoss <- tibble(
  site = c('<http://eunis.eea.europa.eu/sites/IT3330009>'),
  habitat = '<http://eunis.eea.europa.eu/habitats/10009>'
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/IT3250047>'),
    habitat = '<http://eunis.eea.europa.eu/habitats/10009>'
  )
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/IT3270023>'),
    habitat = '<http://eunis.eea.europa.eu/habitats/10004>'
  )
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/IT3270017>'),
    habitat = '<http://eunis.eea.europa.eu/habitats/10004>'
  )
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/HR4000015>'),
    habitat = c('<http://eunis.eea.europa.eu/habitats/10004>', '<http://eunis.eea.europa.eu/habitats/10009>')
  )
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/HR3000161>'),
    habitat = ''
  )
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/HR3000469>'),
    habitat = ''
  )
)

spEcoss <- tibble(
  site = c('<http://eunis.eea.europa.eu/sites/IT3330009>'),
  species = c('<http://eunis.eea.europa.eu/species/409>', '<http://eunis.eea.europa.eu/species/1113>', '<http://eunis.eea.europa.eu/species/1198>', '<http://eunis.eea.europa.eu/species/9947>',
              '<http://eunis.eea.europa.eu/species/641>', '<http://eunis.eea.europa.eu/species/1567>', '<http://eunis.eea.europa.eu/species/291>')
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/IT3250047>'),
    species = c('<http://eunis.eea.europa.eu/species/409>', '<http://eunis.eea.europa.eu/species/1113>', '<http://eunis.eea.europa.eu/species/1198>', '<http://eunis.eea.europa.eu/species/9947>',
                '<http://eunis.eea.europa.eu/species/641>', '<http://eunis.eea.europa.eu/species/1567>', '<http://eunis.eea.europa.eu/species/291>')
  )
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/IT3270023>'),
    species = c('<http://eunis.eea.europa.eu/species/394>', '<http://eunis.eea.europa.eu/species/569>', '<http://eunis.eea.europa.eu/species/1279>', '<http://eunis.eea.europa.eu/species/1282>', 
                '<http://eunis.eea.europa.eu/species/1284>', '<http://eunis.eea.europa.eu/species/316012>', '<http://eunis.eea.europa.eu/species/1280>', '<http://eunis.eea.europa.eu/species/1115>', 
                '<http://eunis.eea.europa.eu/species/1109>', '<http://eunis.eea.europa.eu/species/1113>', '<http://eunis.eea.europa.eu/species/1198>', '<http://eunis.eea.europa.eu/species/409>',
                '<http://eunis.eea.europa.eu/species/193880>', '<http://eunis.eea.europa.eu/species/193879>', '<http://eunis.eea.europa.eu/species/193847>')
  )
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/IT3270017>'),
    species = c('<http://eunis.eea.europa.eu/species/394>', '<http://eunis.eea.europa.eu/species/569>', '<http://eunis.eea.europa.eu/species/1279>', '<http://eunis.eea.europa.eu/species/1282>', 
                '<http://eunis.eea.europa.eu/species/1284>', '<http://eunis.eea.europa.eu/species/316012>', '<http://eunis.eea.europa.eu/species/1280>', '<http://eunis.eea.europa.eu/species/1115>', 
                '<http://eunis.eea.europa.eu/species/1109>', '<http://eunis.eea.europa.eu/species/1113>', '<http://eunis.eea.europa.eu/species/1198>', '<http://eunis.eea.europa.eu/species/409>',
                '<http://eunis.eea.europa.eu/species/193880>', '<http://eunis.eea.europa.eu/species/193879>', '<http://eunis.eea.europa.eu/species/193847>')
  )
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/HR4000015>'),
    species = c('<http://eunis.eea.europa.eu/species/193847>', '<http://eunis.eea.europa.eu/species/193873>', '<http://eunis.eea.europa.eu/species/65549>', '<http://eunis.eea.europa.eu/species/291>',
                '<http://eunis.eea.europa.eu/species/409>')
  )
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/HR3000161>'),
    species = c('<http://eunis.eea.europa.eu/species/1567>')
  )
) %>% rbind(
  tibble(
    site = c('<http://eunis.eea.europa.eu/sites/HR3000469>'),
    species = c('<http://eunis.eea.europa.eu/species/1567>')
  )
)

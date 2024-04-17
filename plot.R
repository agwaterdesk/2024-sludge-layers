setwd(dirname(rstudioapi::getActiveDocumentContext()[['path']]))

library(tidyverse)
library(googlesheets4)
library(leaflet)

sewersheds <- read_sf("../../data/maps/mo_sewersheds.json")
echo <- read_sf("../../data/ECHO Biosolids Facilities/all-facilities.json")
ppl_presumptive <- read_sheet("https://docs.google.com/spreadsheets/d/1kzvexNOxzgG4MnkmnmACaFaPnwwxI2bSwdvZW4IvhAA/edit#gid=1247315222", sheet="PFAS Project Lab - by state")


leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = filter(echo, CWPState == "MO"),
                   color = 'blue',
                   radius = 1,
                   group = "ECHO"
                   ) %>%
  addCircleMarkers(data = filter(
    ppl_presumptive, State == "Missouri"),
                   ~Longitude,
                   ~Latitude,
                   radius = 1,
                   color = 'red',
                   popup = ~Site.Name,
                   group = "PFAS Project Lab - Presumptive"
                   ) %>%
  addLayersControl(
    overlayGroups = c("ECHO", "PFAS Project Lab"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  addGeoJSON(geojson = sewersheds, color = "#444444", weight = 1, fillColor = "#888888", fillOpacity = 0.5)


library(ggthemes)


ggplot() +
  geom_sf(data=sewersheds) +
  theme_map()

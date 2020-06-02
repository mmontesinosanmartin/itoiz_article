###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs, lakes,
# or floods
###############################################################################
# Militino, A.F., Montesino-SanMartin, Pérez-Goya, U.,M., Ugarte, M.D.
# Public University of Navarre
# License: Availability of material under 
# [CC-BY-SA](https://creativecommons.org/licenses/by-sa/2.0/).

###############################################################################
# RGISTOOLS INSTALATION
###############################################################################

# Install devtools
# install.packages(devtools)

# Load devtools
# library(devtools)

# Install RGISTools from github
# install_github("spatialstatisticsupna/RGISTools", ref = "RS_journal")

library(RGISTools)

###############################################################################
# REGION OF INTEREST
###############################################################################

# Working directory
setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path)))
wdir <- "./Imgs"

roi.bbox <- st_bbox(c(xmin = -1.40,
                      xmax = -1.30,
                      ymin = 42.79,
                      ymax = 42.88),
                    crs = 4326)
roi.sf <- st_sf(st_as_sfc(roi.bbox))

###############################################################################
# AUXILIARY DATA
###############################################################################

# Read auxiliary datasets:
# alimetry.itoiz: terrain elevation of the water reservoir basin
# obs.itoiz: time-series of water level measurements
load(url("https://raw.githubusercontent.com/mmontesinosanmartin/itoiz_article/master/Data/auxiliary_data_new.RData"))


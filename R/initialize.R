###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs, lakes,
# or floods
###############################################################################
# Pérez-Goya, U., Montesino-SanMartin, M., Militino, A.F., Ugarte, M.D.
# Public University of Navarre
# License: Availability of material under 
# [CC-BY-SA](https://creativecommons.org/licenses/by-sa/2.0/).

# Replace "D:/example" with the path to your own working directory
wdir <- "D:/example"

# Install the package and load it into R
# install.packages("RGISTools")
library(RGISTools)

###############################################################################
# REGION OF INTEREST
###############################################################################

roi.bbox <- st_bbox(c(xmin = -1.40,
                      xmax = -1.30,
                      ymin = 42.79,
                      ymax = 42.88),
                    crs = 4326)
roi.sf <- st_as_sfc(st_as_sf(roi.sfc))

###############################################################################
# AUXILIARY DATA
###############################################################################

# Data available at:
load(url("https://raw.githubusercontent.com/mmontesinosanmartin/itoiz_article/master/Data/auxiliary_data_new.RData"))

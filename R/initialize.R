###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs, lakes,
# or floods
###############################################################################
# Pérez-Goya, U., Montesino-SanMartin, M., Militino, A.F., Ugarte, M.D.
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
install_github("spatialstatisticsupna/RGISTools")

library(RGISTools)

###############################################################################
# REGION OF INTEREST
###############################################################################

# Replace "D:/example" with the path to own working directory
wdir <- "D:/example"

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


###############################################################################
# FIGURE - ITOIZ RESERVOIR
###############################################################################
library("rworldmap")
library("rworldxtra")
library("tmap")
library("grid")
# Shaded elevation
shade.itoiz <- hillShade(slope = terrain(altimetry.itoiz, "slope"),
                         aspect = terrain(altimetry.itoiz, "aspect"))
# Contour map of the basin
contour.itoiz <- rasterToContour(altimetry.itoiz)

# Map of the basin
map.itoiz <- tm_shape(altimetry.itoiz, title = "Z") + 
  tm_raster(n = 10) +
  tm_grid(lines = FALSE, n.x = 3, n.y = 3, labels.size = 1.2) +
  tm_layout(aes.palette = list(seq = "-Blues"),
            legend.position = c(0.8,0.09)) +
  tm_shape(shade.itoiz) +
  tm_raster(palette = "Greys", alpha = 0.25, legend.show = FALSE) +
  tm_shape(contour.itoiz) + 
  tm_lines(lwd = 0.1, alpha = 0.25) + 
  tm_compass(position = c("center", "top")) +
  tm_scale_bar(position = c("right", "bottom"))

# Map of Spain
wrld <- as(getMap(resolution = "high"), "sf")
World <- st_transform(wrld, crs = 4326)
sp_bbx <- st_bbox(c(
  xmin = -11.156167,
  ymin = 34.39191,
  xmax = 5.063713,
  ymax = 46.59120 
), crs = 4326)

map.spain <- tm_shape(World, bbox = sp_bbx) + 
  tm_polygons() +
  tm_shape(ex.navarre) +
  tm_polygons(col = "red")

# Map of Navarre
map.navarre <- tm_shape(ex.navarre) +
  tm_polygons() +
  tm_shape(roi.sf) +
  tm_polygons(col = "red")

# Print both maps together
map.itoiz
print(map.spain, vp = viewport(x = 0.37, y = 0.87, width = 0.2, height = 0.2))
print(map.navarre, vp = viewport(x = 0.71, y = 0.87, width = 0.2, height = 0.2))


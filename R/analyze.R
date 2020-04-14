###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs, lakes,
# or floods
###############################################################################
# Pérez-Goya, U., Montesino-SanMartin, M., Militino, A.F., Ugarte, M.D.
# Public University of Navarre
# License: Availability of material under 
# [CC-BY-SA](https://creativecommons.org/licenses/by-sa/2.0/).

###############################################################################
# LOAD NDWI
###############################################################################

# Load
imgs.ndwi <- list(
  stack(list.files(file.path(wdir.ls8,"NDWI"), full.names = TRUE)),
  stack(list.files(file.path(wdir.sn2,"NDWI"), full.names = TRUE)))

# Identify
names(imgs.ndwi[[1]]) <- paste0(names(imgs.ndwi[[1]]), "_LS8")
names(imgs.ndwi[[2]]) <- paste0(gsub("10m", "SN2", names(imgs.ndwi[[2]])))

# Combine
imgs.ndwi[[2]] <- projectRaster(imgs.ndwi[[2]], imgs.ndwi[[1]])
imgs.ndwi <- stack(imgs.ndwi)
imgs.ndwi <- imgs.ndwi[[order(names(imgs.ndwi))]]

###############################################################################
# FIGURE - NDWI IMAGES
###############################################################################

# Show
genPlotGIS(imgs.ndwi[[1:8]],
           zlim = c(-1,1),
           tm.raster.r.palette = "BrBG",
           tm.graticules.labels.size = 1.3,
           tm.graticules.n.x = 2,
           tm.graticules.n.y = 2,
           tm.graticules.labels.rot = c(0,90),
           panel.label.size = 1)

###############################################################################
# ANALYZE
###############################################################################
# install.packages("igraph")
library(igraph)

t.st <- Sys.time()

# Detect shoreline
shorelns <- lapply(as.list(imgs.ndwi),
                   function(r){
                     water <- raster::rasterToPolygons(clump(r > -0.1),
                                                       dissolve = TRUE)
                     shores <- st_union(sf::st_as_sfc(water))
                     bodies <- st_cast(shores, "POLYGON")
                     areas  <- st_area(bodies)
                     st_sf(
                       st_cast(
                         bodies[which(areas == max(areas))],
                         "MULTILINESTRING"))})

# Shoreline height
shorelns.z <- stack(lapply(shorelns,
                           function(x, map.z){
                              mask(map.z, x)},
                            altimetry.itoiz))

level.est <- cellStats(shorelns.z, 'median')


# Save
no.imgs <- nlayers(imgs.ndwi)
results <- data.frame("sat" = character(no.imgs),
                      "date" = structure(integer(no.imgs), class = "Date"),
                      "obs" = double(no.imgs),
                      "est" = double(no.imgs),
                      stringsAsFactors = FALSE)
results$sat <- ifelse(grepl("LS8", names(imgs.ndwi)), "LS8", "SN2")
results$date <- genGetDates(names(imgs.ndwi))
results$obs <-  merge(obs.itoiz,results)$level.masl
results$est <- level.est


# Show
par(mfrow = c(1,1))
plot(results$date, results$est, type = "l", lty = 2, xlab = "Dates",
     ylab = "Level (m.a.s.l.)")
lines(results$date, results$obs, type = "l",lwd = 2, ylim = c(555, 590))
points(results$date, results$est, pch = 19, col = as.factor(results$sat))
legend("top", lty = c(1, 2, NA, NA), lwd = c(2, 1, NA, NA), 
       pch = c(NA, NA, 19, 19), c("Obs", "DF","LS8", "SN2"),
       col = c(1, 1, 1, 2), bty = "n", cex = 0.7)
abline(h = seq(550,590, 2), lty = 2, col = "grey")


###############################################################################
# EVALUATE
###############################################################################
# Error
error <- results$obs - results$est
ls8.i <- which(results[,"sat"] == "LS8")
sn2.i <- which(results[,"sat"] == "SN2")

# MAEs
mean(abs(error), na.rm = TRUE)
# [1] 1.274928
mean(abs(error)[ls8.i], na.rm = TRUE)
# [1] 3.048029
mean(abs(error)[sn2.i], na.rm = TRUE)
# [1] 0.8527607

# RMSEs
sqrt(mean(error^2, na.rm = T))
# [1] 1.847081
sqrt(mean(error[ls8.i]^2, na.rm =T))
# [1] 3.602834
sqrt(mean(error[sn2.i]^2, na.rm =T))
# [1] 1.064634

# Correlation
cor(results$est, results$obs)
# [1] 0.9727589
cor(results$est[ls8.i], results$obs[ls8.i])
# [1] 0.9484461
cor(results$est[sn2.i], results$obs[sn2.i])
# [1] 0.991136


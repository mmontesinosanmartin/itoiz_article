###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs, lakes,
# or floods
###############################################################################
# Militino, A.F., Montesino-SanMartin, Pérez-Goya, U.,M., Ugarte, M.D.
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
                     thrsh <- ifelse(grepl("LS8",names(r)), -0.16, -0.10)
                     water <- rasterToPolygons(clump(r > thrsh),dissolve = TRUE)
                     shors <- st_union(st_as_sfc(water))
                     bodis <- st_cast(shors, "POLYGON")
                     areas <- st_area(bodis)
                     st_sf(st_cast(bodis[which.max(areas)],"MULTILINESTRING"), crs = crs(r))
                     }
                   )

# Shoreline height
shorelns.z <- lapply(shorelns,
                     function(pol, altimetry.itoiz){
                       line <- as(as(pol, "Spatial"), "SpatialLines")
                       cell <- cellFromLine(altimetry.itoiz, line)[[1]]
                       elvs <- getValues(altimetry.itoiz)[cell]
                       dnst <- density(elvs, kernel = "epanechnikov", na.rm = T)
                       dnst$x[which.max(dnst$y)]
                     }, altimetry.itoiz)
level.est <- unlist(shorelns.z)

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

###############################################################################
# FIGURE - WATER LEVEL
###############################################################################

# Show
png(filename = "water_level_itoiz.png", width = 400, height = 400)
par(mfrow = c(1,1))
plot(results$date, results$obs,
     type = "l",lwd = 2, ylim = c(557, 585),
     xlab = "Dates",
     ylab = "Level (m.a.s.l.)")
points(results$date, results$est, pch = 19, col = c("green", "red")[as.factor(results$sat)])
abline(h = seq(550,590, 2), lty = 2, col = "grey")
legend("top", lty = c(1, 2, NA, NA), lwd = c(2, 1, NA, NA), 
       pch = c(NA, NA, 19, 19), c("Obs", "Est","LS8", "SN2"),
       col = c(1, 1, 3, 2), bty = "n")
def.off()

###############################################################################
# EVALUATE
###############################################################################
# Error
error <- results$obs - results$est
ls8.i <- which(results[,"sat"] == "LS8")
sn2.i <- which(results[,"sat"] == "SN2")

# Correlation
cor(results$est, results$obs)
# [1] 0.993631
cor(results$est[ls8.i], results$obs[ls8.i])
# [1] 0.9986789
cor(results$est[sn2.i], results$obs[sn2.i])
# [1] 0.991136

# MAEs
mean(abs(error), na.rm = TRUE)
# [1] 0.6141669
mean(abs(error)[ls8.i], na.rm = TRUE)
# [1] 0.9778734
mean(abs(error)[sn2.i], na.rm = TRUE)
# [1] 0.5275701

# MAPEs
mean(abs(error/results$obs), na.rm = TRUE) * 100
# [1] 0.1074258
mean(abs(error/results$obs)[ls8.i], na.rm = TRUE) * 100
# [1] 0.1701685
mean(abs(error/results$obs)[sn2.i], na.rm = TRUE) * 100
# [1] 0.09248711

# RMSEs
sqrt(mean(error^2, na.rm = T))
# [1] 0.8597601
sqrt(mean(error[ls8.i]^2, na.rm =T))
# [1] 1.261116
sqrt(mean(error[sn2.i]^2, na.rm =T))
# [1] 0.7324715




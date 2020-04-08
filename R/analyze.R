###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs, lakes,
# or floods
###############################################################################
# Pérez-Goya, U., Montesino-SanMartin, M., Militino, A.F., Ugarte, M.D.
# Public University of Navarre
# License: Availability of material under 
# [CC-BY-SA](https://creativecommons.org/licenses/by-sa/2.0/).

###################################################
### ANALYSIS
###################################################
t.st <- Sys.time()

################################################### Altimetry
map.z <- raster::projectRaster(altimetry.itoiz,
                               crs = st_crs(imgs.ndwi)$proj4string,
                               method = "bilinear")


################################################### Detect
shorelns <- lapply(as.list(imgs.ndwi),
                   function(r){
                     water <- raster::rasterToPolygons(clump(r > -0.1),
                                                       dissolve = TRUE)
                     shores <- sf::st_union(sf::st_as_sfc(water))
                     bodies <- sf::st_cast(shores, "POLYGON")
                     areas  <- sf::st_area(bodies)
                     sf::st_sf(
                       sf::st_cast(
                         bodies[which(areas == max(areas))],
                         "MULTILINESTRING"))})
shorelns.z <- raster::stack(lapply(shorelns,
                                   function(x, map.z){
                                     mask(map.z, x)},
                                   map.z))
level.est <- cellStats(shorelns.z, 'median')


################################################### Save
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


################################################### Show
par(mfrow = c(1,1))
plot(results$date, results$est, type = "l", lty = 2, xlab = "Dates",
     ylab = "Level (m.a.s.l.)")
lines(results$date, results$obs, type = "l",lwd = 2, ylim = c(555, 590))
points(results$date, results$est, pch = 19, col = as.factor(results$sat))
legend("top", lty = c(1, 2, NA, NA), lwd = c(2, 1, NA, NA), 
       pch = c(NA, NA, 19, 19), c("Obs", "DF","LS8", "SN2"),
       col = c(1, 1, 1, 2), bty = "n", cex = 0.7)
abline(h = seq(550,590, 2), lty = 2, col = "grey")


###################################################
### EVALUATION
###################################################
error <- results$obs - results$est
mean(abs(error), na.rm = TRUE)
# [1] 1.35971
mean(abs(error)[results[,"sat"] == "LS8"], na.rm = TRUE)
# [1] 2.880557
mean(abs(error)[results[,"sat"] == "SN2"], na.rm = TRUE)
# [1] 0.8527607
cor(results$est, results$obs)
# [1] 0.9740032

t.ana <- Sys.time() - t.st
print(t.ana)
# Time difference of 11.75622 mins

t.all <- Sys.time() - t.st.all
print(t.all)
# Time difference of 2.621552 hours
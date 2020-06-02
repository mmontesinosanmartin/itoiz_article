###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs and lakes
###############################################################################
# Militino, A.F., Montesino-SanMartin, Pérez-Goya, U.,M., Ugarte, M.D.
# Public University of Navarre
# License: Availability of material under 
# [CC-BY-SA](https://creativecommons.org/licenses/by-sa/2.0/).

###############################################################################
# MOSAIC
###############################################################################
t.st <- Sys.time()

# Landsat - 8
wdir.ls8.untar <- file.path(wdir.ls8, "untar")
t.st.ls8 <- Sys.time()
lsMosaic(src = wdir.ls8.untar,
         region = roi.sf,
         out.name = "ls8_itoiz",
         gutils = TRUE,
         AppRoot = wdir.ls8)
t.mos.ls8 <- Sys.time() - t.st.ls8
print(t.mos.ls8)
# Time difference of 1.535575 mins

# Sentinel-2
wdir.sn2.unzip <- file.path(wdir.sn2, "unzip")
t.st.sn2 <- Sys.time()
senMosaic(src = wdir.sn2.unzip,
          region = roi.sf,
          out.name = "sn2_itoiz",
          gutils = TRUE,
          AppRoot = wdir.sn2)
t.mos.sn2 <- Sys.time() - t.st.sn2
print(t.mos.sn2)
# Time difference of 11.78283 mins

t.mos <- Sys.time() - t.st
print(t.mos)
# Time difference of 13.31863 mins

# Remove the original files to free memory space in the disk
# unlink(wdir.ls8.untar, recursive = TRUE)
# unlink(wdir.sn2.unzip, recursive = TRUE)

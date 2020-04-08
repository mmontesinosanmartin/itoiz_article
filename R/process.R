###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs, lakes,
# or floods
###############################################################################
# Pérez-Goya, U., Montesino-SanMartin, M., Militino, A.F., Ugarte, M.D.
# Public University of Navarre
# License: Availability of material under 
# [CC-BY-SA](https://creativecommons.org/licenses/by-sa/2.0/).

###################################################
### CLOUD MASK DERIVATION
###################################################
t.st <- Sys.time()

# Landsat - 8
wdir.ls8.mosaic <- file.path(wdir.ls8, "ls8_itoiz")
t.st.ls8 <- Sys.time()
lsCloudMask(src = wdir.ls8.mosaic,
            out.name = "ls8_cldmask",
            AppRoot = wdir.ls8)
t.cld.ls8 <- Sys.time() - t.st.ls8
print(t.cld.ls8)
# Time difference of 4.559622 secs

# Results available at:
# https://unavarra-my.sharepoint.com/:u:/g/personal/manuel_montesino_unavarra_es/EchN_K1FuWFFmCnL5x0TpX0BJFljFeHpcoiBvWFoTH7Krw?e=RfeoPU

# Sentinel-2
wdir.sn2.mosaic <- file.path(wdir.sn2, "sn2_itoiz")
t.st.sn2 <- Sys.time()
senCloudMask(src = wdir.sn2.mosaic,
             out.name = "sn2_cldmask",
             AppRoot = wdir.sn2)

t.cld.sn2 <- Sys.time() - t.st.sn2
print(t.cld.sn2)
# Time difference of 19.56744 secs

# Results available at:
# https://unavarra-my.sharepoint.com/:u:/g/personal/manuel_montesino_unavarra_es/EXEPbXAzWfxLiHGok73kJoIB0aLhhb71_QDR_B1Jb7jSoA?e=IROOpz

t.cld <- Sys.time() - t.st
print(t.cld)
# Time difference of 24.13828 secs

################################################### Load
wdir.ls8.cld <- file.path(wdir.ls8, "ls8_cldmask")
wdir.sn2.cld <- file.path(wdir.sn2, "sn2_cldmask")
wdir.all.cld <- list(wdir.ls8.cld, wdir.sn2.cld)
files.cld.msk <- lapply(wdir.all.cld, list.files, full.names = TRUE)
imgs.cld.msk <- lapply(files.cld.msk, raster::stack)
names(imgs.cld.msk) <- c("ls8", "sn2")

################################################### Clear-sky
cld.coverage <- lapply(imgs.cld.msk,
                       function(x){colSums(is.na(getValues(x)))/ncell(x)})
names(cld.coverage) <- c("ls8", "sn2")
ls8.clr.dates <- genGetDates(names(imgs.cld.msk$ls8))[cld.coverage$ls8 < 0.30]
sn2.clr.dates <- genGetDates(names(imgs.cld.msk$sn2))[cld.coverage$sn2 < 0.001]

###################################################
### INDEX COMPUTATION
###################################################
t.st <- Sys.time()

# Landsat - 8
wdir.ls8.mosaic <- file.path(wdir.ls8, "ls8_itoiz")
t.st.ls8 <- Sys.time()
ls8FolderToVar(src = wdir.ls8.mosaic,
               fun = varNDWI,
               dates = ls8.clr.dates,
               AppRoot = wdir.ls8)
t.var.ls8 <- Sys.time() - t.st.ls8
print(t.var.ls8)
# Time difference of 0.6910241 secs

# Results available at:
# https://unavarra-my.sharepoint.com/:u:/g/personal/manuel_montesino_unavarra_es/EVTOxTv9GtFHtsVf8ch80PsBAGm16HBuEASzsZJbxeecEg?e=U6ZrsP

# Sentinel-2
wdir.sn2.mosaic <- file.path(wdir.sn2, "sn2_itoiz")
t.st.sn2 <- Sys.time()
senFolderToVar(src = wdir.sn2.mosaic,
               fun = varNDWI,
               dates = sn2.clr.dates,
               AppRoot = wdir.sn2)
t.var.sn2 <- Sys.time() - t.st.sn2
print(t.var.sn2)
# Time difference of 1.63415 secs

# Results available at:
# https://unavarra-my.sharepoint.com/:u:/g/personal/manuel_montesino_unavarra_es/EbZzHvxB-m1On5MjnVhZp1cB5py3HvLn7Xw5o-gWaZfsdQ?e=YBk2zS

t.var <- Sys.time() - t.st
print(t.var)
# Time difference of 2.338322 secs

################################################### Load
imgs.ndwi <- list(
  stack(list.files(file.path(wdir.ls8,"NDWI"), full.names = TRUE)),
  stack(list.files(file.path(wdir.sn2,"NDWI"), full.names = TRUE)))
names(imgs.ndwi[[1]]) <- paste0(names(imgs.ndwi[[1]]), "_LS8")
names(imgs.ndwi[[2]]) <- paste0(gsub("10m", "SN2", names(imgs.ndwi[[2]])))


################################################### Combine
imgs.ndwi[[2]] <- raster::projectRaster(imgs.ndwi[[2]], imgs.ndwi[[1]])
imgs.ndwi <- raster::stack(imgs.ndwi)
imgs.ndwi <- imgs.ndwi[[order(names(imgs.ndwi))]]


################################################### Show
genPlotGIS(imgs.ndwi[[1:8]],
           zlim = c(-1,1),
           tm.raster.r.palette = "BrBG",
           tm.graticules.labels.size = 1.3,
           tm.graticules.n.x = 2,
           tm.graticules.n.y = 2,
           tm.graticules.labels.rot = c(0,90),
           panel.label.size = 1)

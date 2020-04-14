###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs, lakes,
# or floods
###############################################################################
# Militino, A.F., Montesino-SanMartin, Pérez-Goya, U.,M., Ugarte, M.D.
# Public University of Navarre
# License: Availability of material under 
# [CC-BY-SA](https://creativecommons.org/licenses/by-sa/2.0/).

setwd(dirname(parent.frame(2)$ofile))
wdir.ls8 <- file.path(wdir, "Landsat8")
wdir.sn2 <- file.path(wdir, "Sentinel2")

###############################################################################
# CLOUD MASK DERIVATION
###############################################################################
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

# Sentinel-2
wdir.sn2.mosaic <- file.path(wdir.sn2, "sn2_itoiz")
t.st.sn2 <- Sys.time()
senCloudMask(src = wdir.sn2.mosaic,
             out.name = "sn2_cldmask",
             AppRoot = wdir.sn2)

t.cld.sn2 <- Sys.time() - t.st.sn2
print(t.cld.sn2)
# Time difference of 19.56744 secs

t.cld <- Sys.time() - t.st
print(t.cld)
# Time difference of 24.13828 secs

###############################################################################
# CLOUD MASK ANALYSIS
###############################################################################

# Load
wdir.ls8.cld <- file.path(wdir.ls8, "ls8_cldmask")
wdir.sn2.cld <- file.path(wdir.sn2, "sn2_cldmask")
wdir.all.cld <- list(wdir.ls8.cld, wdir.sn2.cld)
files.cld.msk <- lapply(wdir.all.cld, list.files, full.names = TRUE)
imgs.cld.msk <- lapply(files.cld.msk, stack)
names(imgs.cld.msk) <- c("ls8", "sn2")

# Cloud coverage
cld.coverage <- lapply(imgs.cld.msk,
                       function(x){
                         colSums(is.na(getValues(x)))/ncell(x)
                         })
names(cld.coverage) <- c("ls8", "sn2")

# Clear-sky
ls8.clr.imgs  <- which(cld.coverage$ls8 < 0.20)
sn2.clr.imgs  <- which(cld.coverage$sn2 < 0.001)
ls8.clr.dates <- genGetDates(names(imgs.cld.msk$ls8))[ls8.clr.imgs]
sn2.clr.dates <- genGetDates(names(imgs.cld.msk$sn2))[sn2.clr.imgs]

###############################################################################
# INDEX COMPUTATION
###############################################################################
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

t.var <- Sys.time() - t.st
print(t.var)
# Time difference of 2.338322 secs

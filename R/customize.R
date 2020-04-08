###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs, lakes,
# or floods
###############################################################################
# Pérez-Goya, U., Montesino-SanMartin, M., Militino, A.F., Ugarte, M.D.
# Public University of Navarre
# License: Availability of material under 
# [CC-BY-SA](https://creativecommons.org/licenses/by-sa/2.0/).

###################################################
### MOSAIC
###################################################
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


# Results available at:
# https://unavarra-my.sharepoint.com/:u:/g/personal/manuel_montesino_unavarra_es/EUybRkrcu_dKrh45xlAAsmIB4aN6pGWOBB9J6YhRJBVm-w?e=5MOOIs

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

# Results available at:
# https://unavarra-my.sharepoint.com/:u:/g/personal/manuel_montesino_unavarra_es/EXEPbXAzWfxLiHGok73kJoIB0aLhhb71_QDR_B1Jb7jSoA?e=Su4Nxw

t.mos <- Sys.time() - t.st
print(t.mos)
# Time difference of 13.31863 mins

################################################### Remove
# unlink(wdir.ls8.untar, recursive = TRUE)
# unlink(wdir.sn2.unzip, recursive = TRUE)

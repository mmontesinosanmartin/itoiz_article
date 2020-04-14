###############################################################################
# R Code: Using RGISTools to estimate the water levels in reservoirs, lakes,
# or floods
###############################################################################
# Pérez-Goya, U., Montesino-SanMartin, M., Militino, A.F., Ugarte, M.D.
# Public University of Navarre
# License: Availability of material under 
# [CC-BY-SA](https://creativecommons.org/licenses/by-sa/2.0/).

###############################################################################
# SEARCH
###############################################################################

t.st <- Sys.time()

# Landsat - 8
t.st.ls8 <- Sys.time()
sres.ls8 <- lsSearch(product = "LANDSAT_8_C1",
                     dates = as.Date("2018-07-01") + seq(0, 304, 1),
                     region = roi.sf,
                     cloudCover = c(0,80),
                     username = "rgistools_test01", #"USERNAME",
                     password = "RGISTools_test01") #"PASSWORD")
t.srch.ls8 <- Sys.time() - t.st.ls8
print(t.srch.ls8)
# Time difference of 4.031832 secs

# Sentinel-2
t.st.sn2 <- Sys.time()
sres.sn2 <- senSearch(platform = "Sentinel-2",
                      product = "S2MSI2A",
                      dates = as.Date("2018-07-01") + seq(0, 304, 1),
                      region = roi.sf,
                      cloudCover = c(0,80),
                      username = "rgistools_test01", #"USERNAME",
                      password = "RGISTools_test01") #"PASSWORD")
t.srch.sn2 <- Sys.time() - t.st.sn2
print(t.srch.sn2)
# Time difference of 1.917993 secs

t.srch <- Sys.time() - t.st
print(t.srch)
# Time difference of 5.950826 secs

###############################################################################
# DOWNLOAD
###############################################################################

t.st <- Sys.time()

# Landsat - 8
wdir.ls8 <- file.path(wdir, "Landsat8")
t.st.ls8 <- Sys.time()
lsDownload(searchres = sres.ls8,
           lvl = 2,
           untar = TRUE,
           bFilter = list("band3", "band5", "pixel_qa"),
           username = "rgistools_test01", #"USERNAME",
           password = "RGISTools_test01", #"PASSWORD",
           l2rqname = "RQ001",
           AppRoot = wdir)
t.dwn.ls8 <- Sys.time() - t.st.ls8
print(t.dwn.ls8)
# Time difference of 1.742629 hours

# Sentinel-2
wdir.sn2 <- file.path(wdir, "Sentinel2")
t.st.sn2 <- Sys.time()
senDownload(searchres = sres.sn2,
            unzip = TRUE,
            bFilter = list("B03_10m", "B08_10m", "CLDPRB_20m"),
            username = "rgistools_test01", #"USERNAME",
            password = "RGISTools_test01", #"PASSWORD",
            AppRoot = wdir.sn2)
t.dwn.sn2 <- Sys.time() - t.st.sn2
print(t.dwn.sn2)
# Time difference of 26.72983 mins

t.dwn <- Sys.time() - t.st
print(t.dwn)
# Time difference of 2.188137 hours
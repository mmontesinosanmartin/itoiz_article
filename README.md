# Supplementary materials: Using RGISTools to estimate the water levels in reservoirs, lakes, or floods

This repository provides the data-sets and R codes to reproduce the analysis in the paper: 
_"Using RGISTools to estimate the water levels in reservoirs and lakes"_
(Militino et al., 2020a). We encourage downloading and unzipping the entire repository.

## Table of contents

 - [Package installation](#Package-installation)
 - [Auxiliary data-sets](#Auxiliary-data-sets)
 - [R code](#R-code)
 - [Imagery](#Imagery)
 - [References](#References)

# Package installation

Install `RGISTools`  (Pérez-Goya et al., 2020b) version 1.0.1 running the
following commands in your `R` console:

```{r}
# Install devtools
install.packages(devtools)

# Load devtools
library(devtools)

# Install RGISTools from github
install_github("spatialstatisticsupna/RGISTools")
```

Find the manual [here](https://cran.r-project.org/web/packages/RGISTools/RGISTools.pdf).

# Auxiliary data-sets 

Datasets are available 
[here](https://github.com/mmontesinosanmartin/itoiz_article/tree/master/Data).
The `.RData` file provides the following information:

 - Topographic map of the basin of the reservoir (`altimetry.itoiz`): A
 `raster` of the terrain's elevation in meters above sea level (m.a.s.l.). The
 `raster` has a resolution of 
 ![formula](https://render.githubusercontent.com/render/math?math=10%20%5Ctimes%2010%5C%2Cm%5E%7B2%7D)
 and uses the EPSG 4326 coordinate reference system. This data results from
 the rasterization and interpolation of the contour maps available at IDENA's
 website (IDENA, 2020).
 
 - Water level observations (`obs.itoiz`): A `data.frame` with the daily
 measurements of the water levels in meters above sea level (m.a.s.l.)
 taken at the dam wall between `2018-01-01` and `2019-09-01` (CH Ebro, 2020).

# R code

To reproduce the analysis, sign up for the web services of 
[SciHub](https://scihub.copernicus.eu/dhus/#/self-registration) and
[EarthExplorer](https://ers.cr.usgs.gov/register/). 
Then, replace the strings `"USERNAME"` and `"PASSWORD"` with your
own credentials in the `R` code.

> __Note to reviewers__: _We facilitate a temporary username and password to speed up the revieweing process. The credentials are already placed in the appropriate code chunks._

With the following `R` code files, you can:

 1. [Initialize](https://github.com/mmontesinosanmartin/itoiz_article/blob/master/R/initialize.R)
 the study defining the region of interest and loading the auxiliary data-sets.  
 2. [Download](https://github.com/mmontesinosanmartin/itoiz_article/blob/master/R/download.R) 
 surface reflectance imagery from Landsat-8 and Sentinel-2.  
 3. [Customize](https://github.com/mmontesinosanmartin/itoiz_article/blob/master/R/customize.R) 
 the satellite imagery by cropping the region of interest.  
 4. [Process](https://github.com/mmontesinosanmartin/itoiz_article/blob/master/R/process.R) 
 the bands to compute the Normalize Difference Water Index (NDWI)(McFeeters, 1996).  
 5. [Analyze](https://github.com/mmontesinosanmartin/itoiz_article/blob/master/R/analyze.R)
 the NDWI to detect the water body and estimate the water levels.  

# Imagery

Steps 2 and 3 require 117 GB of memory space and 3 hours to run (depending
on the internet connection speed). The data volumes and running times drop
considerably in steps 4 and 5 (246MB and XX minutes). Therefore, we provide
the satellite imagery resulting from step 3
[here](https://github.com/mmontesinosanmartin/itoiz_article/blob/master/Imgs)
to jump from step 1 to 4, and skip 2-3. The folders `.Img/Landsat8/ls8_itoiz`
and `.Img/Sentinel2/sn2_itoiz` provide the customized series of Landsat-8 and
Sentinel-2 secenes respectively.

To run the shortcut (1, 4, and 5) make sure to follow the instructions below:

 1. Download the repository clicking on `Clone or download` > `download zip`.
 2. Unzip the repository in the desired computer location.
 3. Open the scripts `initialize.R`, `customize.R`, and `analyze.R`.
 4. Run the srcipts in the same order.
 
# References

[CH Ebro (2020), _On-demand data-sets_. Automates Hydrological Information System. Online; accessed 9. Oct. 2019. http://www.saihebro.com/saihebro/](http://www.saihebro.com/saihebro/)

[IDENA (2020), _Web access to geographic information of Navarre_. Government of Navarre. Online; accessed 9. Oct. 2019.https://idena.navarra.es/Portal/](https://idena.navarra.es/Portal/)

[McFeeters, S. K. (1996). _The use of the Normalized Difference Water Index (NDWI) in the delineation of open water features_. International journal of remote sensing, __17(7)__, 1425-1432.](https://doi.org/10.1080/01431169608948714)

[Pérez-Goya, U., Montesino-SanMartin, M., Militino, A.F., Ugarte, M.D. (2020a). _RGISTools: Handling Multiplatform Satellite Images_. R package version 1.0.0. https://CRAN.R-project.org/package=RGISTools](https://CRAN.R-project.org/package=RGISTools)

Pérez-Goya, U., Montesino-SanMartin, M., Militino, A.F., Ugarte, M.D. (2020b). _Using RGISTools to estimate the water levels in reservoirs and lakes_. Remote Sensing (_submitted_)
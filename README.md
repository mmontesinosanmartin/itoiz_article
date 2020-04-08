# Supplementary materials: Using RGISTools to estimate the water levels in reservoirs, lakes, or floods

This repository provides the auxiliary data-sets and R code to reproduce the
analysis in the paper: 
_"Using RGISTools to estimate the water levels in reservoirs, lakes, or floods"_
(Pérez-Goya et al., 2020)

## Table of contents

 - [Package installation](## Package installation)
 - [Auxiliary data-sets](## Auxiliary data-sets)
 - [R code](## R-code)
 - [References](## References)

## Package installation

Install the package \texttt{RGISTools} (v1.0.0) (Pérez-Goya et al., 2020)
running the following command in your \texttt{R} console:

```{r}
install.packages("RGISTools")
```

Find the manual [here](https://cran.r-project.org/web/packages/RGISTools/RGISTools.pdf).

## Auxiliary data-sets 

 - Topographic map of the basin of the reservoir (IDENA, 2019).
 - [Water level measurements]() (CH Ebro, 2019)

## R code

To reproduce the analysis, sign up for the web services of 
[SciHub](https://scihub.copernicus.eu/dhus/#/self-registration) and
[EarthData](https://urs.earthdata.nasa.gov/users/new). 
Then, replace the strings \texttt{"USERNAME"} and \texttt{"PASSWORD"} with your
own credentials in the \texttt{R} code :

 1. [Initialize](https://github.com/mmontesinosanmartin/itoiz_article/R/initialize.R)
 the analysis defining the region of interest and loading the auxiliary data-sets  
 2. [Download](https://github.com/mmontesinosanmartin/itoiz_article/R/download.R) 
 surface reflectance imagery from Landsat-8 and Sentinel-2  
 3. [Customize](https://github.com/mmontesinosanmartin/itoiz_article/R/customize.R) 
 the satellite imagery by cropping the region of interest  
 4. [Process](https://github.com/mmontesinosanmartin/itoiz_article/R/process.R) 
 the bands to compute the Normalize Difference Water Index (NDWI)(McFeeters, 1996)  
 5. [Analyze](https://github.com/mmontesinosanmartin/itoiz_article/R/analyze.R)
 the NDWI to detect the water body and estimate the water levels  

## References

[CH Ebro (2019), _On-demand data-sets_. Automates Hydrological Information System. Online; accessed 9. Oct. 2019. http://www.saihebro.com/saihebro/](http://www.saihebro.com/saihebro/)

[McFeeters, S. K. (1996). _The use of the Normalized Difference Water Index (NDWI) in the delineation of open water features_. International journal of remote sensing, __17(7)__, 1425-1432.](https://doi.org/10.1080/01431169608948714)

[IDENA (2019), _Web access to geographic information of Navarre_. Government of Navarre. Online; accessed 9. Oct. 2019.https://idena.navarra.es/Portal/](https://idena.navarra.es/Portal/)

[Pérez-Goya, U., Montesino-SanMartin, M., Militino, A.F., Ugarte, M.D. (2020). _RGISTools: Handling Multiplatform Satellite Images_. R package version 1.0.0. https://CRAN.R-project.org/package=RGISTools](https://CRAN.R-project.org/package=RGISTools)
# Supplementary materials: Using RGISTools to estimate the water levels in reservoirs, lakes, or floods

This repository provides the auxiliary data-sets and R code to reproduce the
analysis in the paper: 
_"Using RGISTools to estimate the water levels in reservoirs, lakes, or floods"_
(Pérez-Goya et al., 2020)

## Table of contents

 - [Auxiliary data-sets](## Auxiliary data-sets)
 - [R code](## R-code)
 - [References](## References)

## Auxiliary data-sets 

 - [Topographic map]() of the basin (IDENA, 2019)
 - [Water level measurements]() (CH Ebro, 2019)

## R code

 - [Download](https://github.com/mmontesinosanmartin/itoiz_article/R/download.R) 
 surface reflectance imagery from Landsat-8 and Sentinel-2
 - [Customize](https://github.com/mmontesinosanmartin/itoiz_article/R/customize.R) 
 the satellite imagery by cropping the region of interest
 - [Process](https://github.com/mmontesinosanmartin/itoiz_article/R/process.R) 
 the bands to compute the Normalize Difference Water Index (NDWI)()
 - [Analyze](https://github.com/mmontesinosanmartin/itoiz_article/R/analyze.R)
 the NDWI to detect the water body and estimate the water levels

## References

[McFeeters, S. K. (1996). _The use of the Normalized Difference Water Index (NDWI) in the delineation of open water features_. International journal of remote sensing, __17(7)__, 1425-1432.](https://doi.org/10.1080/01431169608948714)

IDENA (2019), _Web access to geographic information of Navarre_. Government of Navarre. Online; accessed 9. Oct. 2019.
(https://idena.navarra.es/Portal/)

CH Ebro (2019), _On-demand data-sets_. Automates Hydrological Information System. Online; accessed 9. Oct. 2019.
(http://www.saihebro.com/saihebro/)

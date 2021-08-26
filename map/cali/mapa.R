require(sp)
require(rgdal)
require(raster)

cali=shapefile("/Users/davidarango/Documents/David Arango/Personales/Fotomultas/heridosymuertos/datos/cali.shp")
plot(cali)
cali@data$indice=rnorm(22)
spplot(cali[,21])

cali_2=cali[,4]

###########################################################################################
########################    VISUALIZACIÓN DE DATOS HIDROLÓGICOS    ########################
###########################################################################################


pp_est <- read.csv("D:/CONGRESO/Clase/Datos/Datos_pp.csv", header = T, sep = ";")
pp_Jeque <- read.csv("D:/CONGRESO/Clase/Datos/Pp_Jequetepeque.csv", header = T, sep = ";")

ts <- seq(as.Date("01/01/1964", format = "%d/%m/%Y"), as.Date("01/12/2010", format = "%d/%m/%Y"), by = "month")

pp_Jeque[,1] <- ts


# Plot 
plot(pp_Jeque[,1], pp_Jeque[,2], type = "l", main = "Estación Asunción", xlab = "Año", ylab = "Precipitación")

# Ggplot 
Me <- median(pp_Jeque$Asunción, na.rm = T)
ggplot(pp_Jeque, aes(X, Asunción)) +
  theme_bw() +
  geom_line(color = "blue") +
  geom_line(color = "red", aes(X, Me)) +
  xlab("Año") +
  ylab("Precipitación") +
  ggtitle("Estación Asunción") +
  theme(plot.title = element_text(hjust = 0.5))



install.packages("readxl")
library("readxl")
my_data <- read_excel("D:/CONGRESO/Clase/Datos/Climatologia.xlsx")

ggplot(my_data, aes(x = Month, y = PP, color = Estación)) + 
  geom_line() +
  xlab("Mes") +
  ylab("Precipitación media (mm)") +
  ggtitle("Climatologia Jequetepeque") +
  theme(plot.title = element_text(hjust = 0.5))


# Media
AsuncionMean <- mean(pp_Jeque$Asunción, na.rm = T)

# Varianza
AsuncionVar <- var(pp_Jeque$Asunción, na.rm = T)

#Correlación entre 2 estaciones
test <- cor.test(pp_Jeque$Asunción, pp_Jeque$Celendín)

# Grafico de dispersion entre 2 estaciones con plot
plot(pp_Jeque$Asunción, pp_Jeque$Celendín, main="Grafico de dispersion", pch = 20)
abline(lm(pp_Jeque$Asunción~pp_Jeque$Celendín), col="red")


# Grafico de dispersion entre 2 estaciones con ggplot
ggplot(pp_Jeque, aes(x=Asunción, y=Celendín)) +
  geom_point() + 
  ggtitle("Gráfico de Dispersión") + 
  xlab("Precipitación Asunción") + 
  ylab("Precipitación Celendín") + 
  geom_smooth(method=lm)



###########################################################################################
########################  VISUALIZACIÓN DE FORMATOS ESPACIALES    #########################
###########################################################################################

library(raster)
dem <- raster("D:/CONGRESO/Clase/Datos/dem_250.tif")
UH <- shapefile("D:/CONGRESO/Clase/Datos/Cuenca_Jequetepeque.shp")

UH_m <- spTransform(UH, CRS(proj4string(dem)))

plot(dem) +
  plot(UH_m, add = TRUE)




library(sf)

Cuenca1	<-	st_read("D:/CONGRESO/Clase/Datos/Cuenca_Jequetepeque.shp")
geo	<-	plot(st_geometry(Cuenca1))

setwd("D:/CONGRESO/Clase/Datos/Landsat")
lista <- list.files("D:/CONGRESO/Clase/Datos/Landsat")
br <- brick(raster(lista[4]), raster(lista[3]), raster(lista[2]))

plotRGB(br)



#pp_mensual PISCO
require(ncdf4)

PISCO_PREC <- brick("D:/CONGRESO/Clase/Datos/PISCOpm.nc")

listaPP = c()
for (i in 1:420){
  PP = PISCO_PREC[[i]]
  mk <- mask(crop(PP ,UH), UH)
  b = mean(getValues(mk),na.rm=T)
  listaPP = c(listaPP,b)
  print(i)
}

mes = seq(as.Date("1981/1/1"),as.Date("2009/12/1"),"month")
dfPP = data.frame(mes,listaPP[1:348])
head(dfPP)

ggplot(dfPP, aes(x = mes, y = Precipitacion)) +
  geom_line(color = "blue") +
  ggtitle("Serie de tiempo de precipitacion")


########################################################################## Caso Shapefile
nc <- brick("D:/CONGRESO/Clase/Datos/PISCOpm.nc")
pt <- shapefile("D:/CONGRESO/Clase/Datos/Estaciones.shp")                ## Si tiene puntos como shp
ts <- seq(as.Date("1981-01-01"), as.Date("2016-12-01"), by = "month") 

ext <- extract(nc, pt)                                                    ## Extract, para sacar los puntos
plot(ext[2,],type = "l")
df <- data.frame(ts, ext[1,])                                             ## El 2 lo puede cambiar por el numero de punto que quiere(si es un solo punto tambien)
plot(df,type = "p")                                                      ## Plot1
plot(ext[2,],type = "l")                                                 ## Plot2
write.csv(df,"D:/CONGRESO/Clase/Datos/estacionX.csv")                    ## Guardar como *.csv

########################################################################## Caso Coordenadas (Igual hasta la l?nea 8)
xy = cbind(-78.422584,  -7.075452)                                      ## Introducir coordenadas
ext = extract(nc, xy)                                                   ## Extraer s?lo un punto      
df <- data.frame(ts, as.numeric(ext))
plot(df, type = "l")

##########################################################################
##########################################################################

# Si lo que quiere es sacar una media o sumatoria de un pol?gono

UH <- shapefile("D:/CONGRESO/Clase/Datos/Cuenca_Jequetepeque.shp")     ## ?rea como pol?gono
UH_wgs <- spTransform(UH, CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))

recorte <- mapply(function(i){
  mk = mask(crop(nc[[i]],UH_wgs),UH_wgs)                         ## corta la imagen o el paquete de im?genes (como un clip)
  a = sum(getValues(mk),na.rm=T)                                       ## cambia sum por mean o la funci?n que requiera
  print(i)
  return(a)},1:432)

plot(ts, recorte, type = "l")


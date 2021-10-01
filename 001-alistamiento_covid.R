library(tidyverse)
library(RSocrata)
library(dygraphs)
library(xts)
library(incidence)
library(aTSA)
library(lmtest)
library(forecast)
library(dplyr)
library(seastests)
library(trend)
token <- "ew2rEMuESuzWPqMkyPfOSGJgE" #Es una herramienta para poder descargar los datos desde el INS.
df.ins <- read.socrata("https://www.datos.gov.co/resource/gt2j-8ykr.json", app_token = token) #Descarga los datos desde la p?gina de la INS.
df.ins2=df.ins
df.ins$fecha_inicio_sintomas <- as.Date(df.ins$fecha_inicio_sintomas,tryFormats = c("%d-%m-%Y", "%d/%m/%Y"))
df.ins$fecha_de_notificaci_n <- as.Date(df.ins$fecha_de_notificaci_n, tryFormats = c("%d-%m-%Y", "%d/%m/%Y"))
df.ins$fecha_muerte <- as.Date(df.ins$fecha_muerte, tryFormats = c("%d-%m-%Y", "%d/%m/%Y"))
df.ins$fecha_recuperado <- as.Date(df.ins$fecha_recuperado, tryFormats = c("%d-%m-%Y", "%d/%m/%Y"))
df.ins$fecha_reporte_web <- as.Date(df.ins$fecha_reporte_web, tryFormats = c("%d-%m-%Y", "%d/%m/%Y"))
df.ins$fecha_diagnostico  <- as.Date(df.ins$fecha_diagnostico, tryFormats = c("%d-%m-%Y", "%d/%m/%Y"))
#De la 11 a la 16 convierte en formato fecha corta.

df.ins$confirmados <- "Confirmados" #Crea una columna para tener un conteo de los confirmados diarios.

#df.ins$fallecidos[which(df.ins$atenci_n=="Fallecido" | df.ins$estado=="Fallecido")]="Fallecidos"

df.ins <- df.ins %>%
  dplyr::select(id_de_caso,
                ciudad_municipio_nom,
                fecha_inicio_sintomas,
                confirmados,
                fecha_de_notificaci_n,
                fecha_diagnostico,
                fecha_muerte,
                fecha_reporte_web,
                everything()) #Reorganiza la base.

########################CONFIRMADOS#####################
inc.casos.colombia.confirmados <- incidence(df.ins$fecha_reporte_web,
                                            groups = df.ins$confirmados) #Hace un conteo de cantidad de confirmados por fecha.
serie.colombia <- xts(x = inc.casos.colombia.confirmados$counts,
                      order.by = inc.casos.colombia.confirmados$dates) #Crea una serie de tiempo con la cantidad de confirmados.
saveRDS(ts_colombia, "data/ts_colombia.RDS")
saveRDS(inc.casos.colombia.confirmados, "data/confirmados_CO.RDS")
saveRDS(df.ins, "data/Colombia.RDS")
Colombia2021_05= df.ins[df.ins$fecha_reporte_web>= "2021-05-01" & df.ins$fecha_reporte_web <= "2021-05-28",]
saveRDS(Colombia2021_05, "data/Colombia_202105.RDS")



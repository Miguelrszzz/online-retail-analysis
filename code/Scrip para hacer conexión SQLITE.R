library(RSQLite)
library(DBI)
library(tidyverse)

## Hacer conexión con BBDD

# 1. Establecer la conexión con tu archivo de base de datos
# Cambia "mi_base_de_datos.db" por el nombre real de tu archivo
conexion <- dbConnect(SQLite(), "C:/Users/Miguel/Desktop/Portafolio/Proyecto 1/Ventas onlines_Proyecto_1.db")

# 2. Listar las tablas para verificar que todo está bien
dbListTables(conexion)

# 3. Traer la tabla limpia a R (Usando el Query que planeamos)
# Aquí puedes pegar el SELECT con la separación de fecha y hora
Vista <- "
SELECT * FROM Normalizada
"

df_retail <- dbGetQuery(conexion, Vista)

# 4. ¡IMPORTANTE! Cerrar la conexión al terminar
dbDisconnect(conexion)


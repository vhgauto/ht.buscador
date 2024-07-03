# cambio locale, para las fechas
Sys.setlocale(locale="es_ES.UTF-8")

# paquetes ----------------------------------------------------------------

library(tidyverse)

# spotify -----------------------------------------------------------------

spotify <- read_csv("datos/spotify.csv")

# letterboxd --------------------------------------------------------------

letterboxd <- read_csv("datos/letterboxd.csv")

# datos -------------------------------------------------------------------

# combino los datos
datos <- inner_join(
  letterboxd,
  spotify,
  by = join_by(episodio)
)

# guardo los datos
write_csv(datos, "datos/datos.csv")

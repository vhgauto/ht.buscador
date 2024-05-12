
# paquetes ----------------------------------------------------------------

library(tidyverse)

# spotify -----------------------------------------------------------------

spotify <- read_csv("datos/spotify.csv")

# letterboxd --------------------------------------------------------------

letterboxd <- read_csv("datos/letterboxd.csv")

# datos -------------------------------------------------------------------

datos <- inner_join(
  letterboxd,
  spotify,
  by = join_by(episodio)
)

write_csv(datos, "datos/datos.csv")

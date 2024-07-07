# cambio locale, para las fechas
Sys.setlocale(locale = "es_ES.UTF-8")

# paquetes ----------------------------------------------------------------

library(tidyverse)

# spotify -----------------------------------------------------------------

spotify <- read_csv("datos/spotify.csv")

# letterboxd --------------------------------------------------------------

letterboxd <- read_csv("datos/letterboxd.csv")

# country club ------------------------------------------------------------

# duracion_ms y imagen_url están en ese formato porque facilitan la entrada
# de nuevas filas
# se agregan líneas para transformarlas y combinarlas con el resto de datos
country_club <- read_csv("datos/country_club.csv", show_col_types = FALSE) |> 
  separate(
    col = duracion, into = c("h", "m", "s"),
    sep = ":"
  ) |>
  mutate(
    across(
      .cols = h:s,
      .fns = as.numeric
    )
  ) |>
  mutate(
    duracion_ms = (3600*h + 60*m + s)*1000
  ) |>
  select(-h, -m, -s) |>
  mutate(imagen_url = str_remove(imagen_url, "background-image:url\\(//")) |>
  mutate(imagen_url = str_remove(imagen_url, "\\);width:100%;height:100%;")) |>
  mutate(imagen_url = str_replace_all(imagen_url, "200", "500")) |>
  mutate(imagen_url = glue::glue("https://{imagen_url}")) |>
  select(-nro) |>
  mutate(tipo = "pago") |>
  mutate(episodio_url = "https://hoytrasnoche.com/vip/")

# datos -------------------------------------------------------------------

# combino los datos de Spotify y Letterboxd
datos_spotify <- inner_join(
  letterboxd,
  spotify,
  by = join_by(episodio)
) |> 
  select(-desc, -id) |> 
  mutate(tipo = "gratis")

# combino con el Country Club y creo la base de datos final
datos <- bind_rows(country_club, datos_spotify)

# guardo los datos
write_csv(datos, "datos/datos.csv")

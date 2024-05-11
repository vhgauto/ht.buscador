
# paquetes ----------------------------------------------------------------

# paquetes
library(reactable)
library(htmltools)
library(glue)
library(tippy)
library(tidyverse)

# fuentes -----------------------------------------------------------------

# registro las fuentes a usar en el documento

# jet
# JetBrainsMonoNL Nerd Font Mono
systemfonts::register_font(
  name = "jet",
  plain = "fuentes/JetBrainsMonoNLNerdFontMono-Regular.ttf"
)

# ubuntu
# Ubuntu
systemfonts::register_font(
  name = "ubuntu",
  plain = "fuentes/Ubuntu-Regular.ttf",
  bold = "fuentes/Ubuntu-Bold.ttf",
  italic = "fuentes/Ubuntu-Italic.ttf"
)

# friz
# Friz Quadrata
systemfonts::register_font(
  name = "friz",
  plain = "fuentes/Friz Quadrata Bold.otf"
)

# colores -----------------------------------------------------------------

cr <- "#EE4121"
ca <- "#FFC10E"
cn <- "#000000" # black
cb <- "#FFFFFF" # white

# grises
cg1 <- "#080808" # grey3
cg2 <- "#0F0F0F" # grey6
cg3 <- "#171717" # grey9
cg4 <- "#7F7F7F" # grey50

# íconos ------------------------------------------------------------------

# todos de la fuente JetBrainsMonoNL Nerd Font Mono

icono_movie <- glue(
  "<span style='font-family:JetBrainsMonoNL Nerd Font Mono; color:{cr}'>",
  "&#xf0fce;</span>")

icono_play <- glue(
  "<span style='font-family:JetBrainsMonoNL Nerd Font Mono; color:{cr}'>",
  "&#xf040a;</span>")

icono_reloj <- glue(
  "<span style='font-family:JetBrainsMonoNL Nerd Font Mono; color:{cr}'>",
  "&#xf0954;</span>")

icono_reloj_header <- glue(
  "<span style='font-family:JetBrainsMonoNL Nerd Font Mono;'>",
  "&#xf0954;</span>")

icono_calendario <- glue(
  "<span style='font-family:JetBrainsMonoNL Nerd Font Mono; color:{cr}'>",
  "&#xf073;</span>")

icono_calendario_header <- glue(
  "<span style='font-family:JetBrainsMonoNL Nerd Font Mono;'>",
  "&#xf073;</span>")

icono_numeral <- glue(
  "<span style='font-family:JetBrainsMonoNL Nerd Font Mono; color:{cr}'>",
  "#</span>")

icono_github <- glue(
  "<span style='font-family:JetBrainsMonoNL Nerd Font Mono;font-size:1em;'>",
  "&#xf09b;</span>"
)

# tooltip -----------------------------------------------------------------

# texto a mostrar al pasar el mouse sobre los encabezados de las columnas

tooltip_nro <- glue(
  "Número de episodio ordenado cronológicamente")

tooltip_episodio <- glue(
  "Hacer clik en el nombre del episodio para eschucarlo ",
  "en <b style='color:{ca}'>Spotify</b>.")

tooltip_duracion <- glue("Duración de los episodios.")

tooltip_fecha <- glue("Fecha de publicación de los episodios.")

tooltip_pelicula <- glue(
  "Los nombres de las películas están en inglés. El ",
  "link redirige al sitio de la película en <b style='color:{ca}'>",
  "Letterboxd</b>.")

# redes sociales ----------------------------------------------------------

# tibble con íconos, links y formato

redes <- tibble(
  red = c("twitter", "instagram", "github", "mastodon"),
  link = c("https://twitter.com/vhgauto", "https://www.instagram.com/vhgauto",
           "https://github.com/vhgauto", "https://mastodon.social/@vhgauto"),
  icono = c("eb72", "f02fe", "f09b", "f0ad1")
) |>
  mutate(
    icono_label = glue(
      "<span style='font-family:JetBrainsMonoNL Nerd Font Mono;",
      "color:{ca}; font-size:1.0em;'>",
      "&#x{icono};",
      "</span>"
    )
  ) |>
  mutate(
    label = glue(
      "<a target='_blank' href={link}>{icono_label}</a>"
    )
  )

# extras ------------------------------------------------------------------

# texto HOY TRASNOCHE, última actualización y repositorio

# HOY TRASNOCHE
ht <- glue(
  "<b style='font-family: Friz Quadrata; color: {ca}'>HOY TRASNOCHE</b>"
)

# fecha y hora de última actualización
ahora <- format(now(tzone = "America/Argentina/Buenos_Aires"), "%d/%m/%Y %T")
ahora_label <- glue(
  "<p style='text-align:right; color:{cg4}'>{ahora}</p>"
)

# link al repositorio
link_repositorio <- "https://github.com/vhgauto/ht.buscador"

link_github <- glue(
  "<a target='_blank' href={link_repositorio}>{icono_github}</a>"
)

# datos -------------------------------------------------------------------

# lectura de datos

d <- read_csv("datos/datos.csv") |> 
  select(-desc, -id) |> 
  mutate(episodio = glue(
    "<a target='_blank' href={episodio_url}>{icono_play} {episodio}</a>")) |> 
  mutate(pelicula = glue("{pelicula} {pelicula_año}")) |> 
  select(-pelicula_año) |> 
  mutate(pelicula = glue(
    "<a target='_blank' href={link_letterboxd}>{icono_movie} {pelicula}</a>")) |> 
  select(-link_letterboxd, -episodio_url) |> 
  arrange(fecha) |> 
  group_by(fecha, episodio) |> 
  mutate(nro = cur_group_id(), .before = 1) |> 
  ungroup() |> 
  mutate(
    pelicula = str_flatten(pelicula, collapse = "<br>"),
    .by = c(nro, episodio)
  ) |> 
  distinct() |> 
  mutate(nro = case_when(
    nchar(nro) == 1 ~ glue("00{nro}"),
    nchar(nro) == 2 ~ glue("0{nro}"),
    .default = glue("{nro}")
  )
  ) |> 
  mutate(nro = glue("{icono_numeral}{nro}")) |> 
  select(
    nro,
    episodio,
    imagen_url,
    duracion_ms,
    fecha,
    pelicula
  )

# funciones ---------------------------------------------------------------

# función para dar formato a la duración de los episodios
f_duracion <- function(value) {

  minutos <- round(value/1000/60)
  dur_h <- floor(minutos/60)
  dur_m <- minutos - dur_h*60
  label_h <- glue("{dur_h}h")
  label_m <- glue("{dur_m}m")
  dur_label <- if_else(
    dur_h == 0,
    glue("{label_m}"),
    glue("{label_h}:{label_m}")
  )

  dur_label_icono <- glue("{icono_reloj} {dur_label}")

  return(dur_label_icono)
}

# función para dar formato a la fecha de los episodios
f_fecha <- function(value) {

  fecha_label <- format(value, "%d/%b/%Y") |>
    toupper() |>
    str_remove("\\.")

  fecha_label_icono <- glue("{icono_calendario} {fecha_label}")

  return(fecha_label_icono)
}

# función para dar formato al texto que aparece al pasar el mouse sobre los
# encabezados de las columnas
with_tooltip <- function(value, tooltip, ...) {
  div(
    style = glue(
    "text-decoration: underline; 
    text-decoration-color: {cr};
    text-decoration-style: solid;
    cursor: help"),
    tippy(value, tooltip, ...))
}

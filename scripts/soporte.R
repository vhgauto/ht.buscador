
# paquetes ----------------------------------------------------------------

# paquetes
library(reactable)
library(htmltools)
library(glue)
library(tippy)
library(tidyverse)

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

# tamaño de íconos
tamaño_icono <- 1.3

# todos de la fuente Nerd Font
icono_movie <- glue(
  '<span class="nf nf-md-movie_open" style="color:{cr}"></span>'
)

icono_play <- glue(
  '<span class="nf nf-md-play" style="color:{cr}"></span>'
)

icono_reloj <- glue(
  '<span class="nf nf-md-clock" style="color:{cr}"></span>'
)

icono_reloj_header <- glue(
  '<span class="nf nf-md-clock""></span>'
)

icono_calendario <- glue(
  '<span class="nf nf-fa-calendar" style="color:{cr}"></span>'
)

icono_calendario_header <- glue(
  '<span class="nf nf-fa-calendar""></span>'
)

icono_numeral <- glue('<span style="color:{cr}">#</span>')

icono_github <- glue(
  '<span class="nf nf-md-github" style="font-size:{tamaño_icono}em"></span>'
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
  link = c(
    "https://twitter.com/vhgauto", "https://www.instagram.com/vhgauto",
    "https://github.com/vhgauto", "https://mastodon.social/@vhgauto"),
  class = c(
    "nf-md-twitter", "nf-md-instagram", "nf-md-github", "nf-md-mastodon")
) |>
  mutate(
    icono_label = glue(
      '<span class="nf {class}" style="color:{ca};',
      'font-size:{tamaño_icono}em;"></span>'
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
  "<b style='font-family: Friz Quadrata Bold; color: {ca}'>HOY TRASNOCHE</b>"
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
  mutate(pelicula = glue("{pelicula} ({pelicula_año})")) |>
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

# cantidad de contenido
ht_contenido <- sum(d$duracion_ms)/1000/3600/24

ht_dias <- floor(ht_contenido)
ht_horas <- round((ht_contenido - ht_dias)*24)

ht_dias_label <- glue("<b style='color:{cr}'>{ht_dias}</b>")
ht_horas_label <- glue("<b style='color:{cr}'>{ht_horas}</b>")

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

# función para dar formato al texto del encabezado de las columnas
with_tooltip <- function(value, tooltip, ...) {
  div(
    style = glue(
    "text-decoration: underline; 
    text-decoration-color: {cr};
    text-decoration-style: solid;
    text-underline-offset: 10px;
    cursor: help"),
    tippy(value, tooltip, ...))
}


# paquetes ----------------------------------------------------------------

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

icono_flecha <- glue(
  '<span class="nf nf-fa-poop" ',
  'style="font-size:{tamaño_icono}em;"></span>'
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
  "Los nombres de las películas están (casi todos) en inglés. El ",
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

# datos -------------------------------------------------------------------

# lectura de datos

d <- read_csv("datos/datos.csv") |>
  select(-desc, -id) |>
  mutate(pelicula = glue("{pelicula} ({pelicula_año})")) |>
  select(-pelicula_año) |>
  arrange(fecha, pelicula) |>
  group_by(fecha, episodio) |>
  mutate(nro = cur_group_id(), .before = 1) |>
  ungroup() |>
  mutate(
    pelicula = str_flatten(pelicula, collapse = "<br>"),
    link_letterboxd = str_flatten(link_letterboxd, collapse = "<br>"),
    .by = c(nro, episodio)
  ) |>
  distinct() |>
  select(
    nro,
    episodio,
    imagen_url,
    duracion_ms,
    fecha,
    pelicula,
    link_letterboxd,
    episodio_url
  )

# cantidad de contenido total, en días
ht_contenido <- sum(spotify$duracion_ms) / 1000 / 3600 / 24

ht_dias <- floor(ht_contenido)
ht_horas <- round((ht_contenido - ht_dias)*24)

ht_dias_label <- glue("<b style='color:{cr}'>{ht_dias}</b>")
ht_horas_label <- glue("<b style='color:{cr}'>{ht_horas}</b>")

# funciones ---------------------------------------------------------------

# función para dar formato a la duración de los episodios
f_duracion <- function(value) {

  minutos <- round(value / 1000 / 60)
  dur_h <- floor(minutos / 60)
  dur_m <- minutos - dur_h * 60
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

# función que agrega el link de la película a Letterboxd
f_pelicula <- function(value, index) {
  v_link <- d |>
    filter(nro == index) |>
    select(link_letterboxd) |>
    pull() |>
    str_split(pattern = "<br>") |>
    list_c()

  v_pelicula <- d |>
    filter(nro == index) |>
    select(pelicula) |>
    pull() |>
    str_split(pattern = "<br>") |>
    list_c()

  label <- glue(
    "<a target='_blank' href={v_link}>{icono_movie} {v_pelicula}</a>"
  )
  l <- str_flatten(label, collapse = "<br>")
  return(l)
}

# función que agrega el link del episodio a Spotify
f_episodio <- function(value, index) {
  link <- d$episodio_url[index]
  label <- glue(
    "<a target='_blank' href={link}>{icono_play} {value}</a>"
  )
  return(label)
}

# función que agrega formato a los números
f_numero <- function(value) {

  n <- value

  if (nchar(value) == 1) {
    n <- glue("00{value}")
  }

  if (nchar(value) == 2) {
    n <- glue("0{value}")
  }

  label <- glue("{icono_numeral}{n}")

  return(label)
}

# función para dar formato al texto del encabezado de las columnas
with_tooltip <- function(value, tooltip, ...) {
  div(
    style = glue(
    "text-decoration: underline;",
    "text-decoration-color: {cr};",
    "text-decoration-style: solid;",
    "text-underline-offset: 10px;",
    "cursor: help"),
    tippy(value, tooltip, ...))
}

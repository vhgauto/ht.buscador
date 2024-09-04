
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
# _cc -> indica que es un ícono para el Country Club
icono_movie <- glue(
  '<span class="nf nf-md-movie_open" style="color:{cr}"></span>')

icono_movie_cc <- glue(
  '<span class="nf nf-md-movie_open" style="color:{ca}"></span>')

icono_play <- glue(
  '<span class="nf nf-md-play" style="color:{cr}"></span>')

icono_play_cc <- glue(
  '<span class="nf nf-md-play" style="color:{ca}"></span>')

icono_reloj <- glue(
  '<span class="nf nf-md-clock" style="color:{cr}"></span>')

icono_reloj_cc <- glue(
  '<span class="nf nf-md-clock" style="color:{ca}"></span>')

icono_reloj_header <- glue(
  '<span class="nf nf-md-clock"></span>')

icono_calendario <- glue(
  '<span class="nf nf-fa-calendar" style="color:{cr}"></span>')

icono_calendario_cc <- glue(
  '<span class="nf nf-fa-calendar" style="color:{ca}"></span>')

icono_calendario_header <- glue(
  '<span class="nf nf-fa-calendar"></span>')

icono_numeral <- glue('<span style="color:{cr}">#</span>')

icono_numeral_cc <- glue('<span style="color:{ca}">#</span>')

icono_github <- glue(
  '<span class="nf nf-md-github" style="font-size:{tamaño_icono}em"></span>')

icono_flecha <- glue(
  '<span class="nf nf-fa-poop" ',
  'style="font-size:{tamaño_icono}em;"></span>')

dos_puntos <- glue("<span style='color:{cr}'>:</span>")

barras <- glue("<span style='color:{cr}'>/</span>")

parentesis_d <- glue("<span style='color:{cr}'>)</span>")

parentesis_i <- glue("<span style='color:{cr}'>(</span>")

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

# COUNTRY CLUB
cc <- glue(
  "<b style='font-family: Friz Quadrata Bold; color: {ca}'>COUNTRY CLUB</b>"
)

# fecha y hora de última actualización
ahora <- format(now(tzone = "America/Argentina/Buenos_Aires"), "%d/%m/%Y %T")
ahora_label <- glue(
  "<p style='text-align:right; color:{cg4}'>{ahora}</p>"
)

# link al repositorio
link_repositorio <- "https://github.com/vhgauto/ht.buscador"

# tooltip -----------------------------------------------------------------

# texto a mostrar al pasar el mouse sobre los encabezados de las columnas

tooltip_nro <- glue("Número de episodio ordenado cronológicamente")

tooltip_episodio <- glue(
  "Hacer clik en el nombre del episodio para escucharlo ",
  "en el <b style='color:{ca}'>{cc}</b> o ",
  "en <b>Spotify</b>.")

tooltip_duracion <- glue("Duración del episodio.")

tooltip_fecha <- glue("Fecha de publicación del episodio.")

tooltip_pelicula <- glue(
  "Los nombres de las películas están (casi todos) en inglés. El ",
  "link redirige al sitio de la película en <b style='color:{ca}'>",
  "Letterboxd</b>.")

# datos -------------------------------------------------------------------

# lectura de datos
# agrupo las películas en el mismo episodio

d <- read_csv("datos/datos.csv", show_col_types = FALSE) |>
  mutate(pelicula = glue(
    "{pelicula} {parentesis_i}{pelicula_año}{parentesis_d}")
  ) |>
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
    episodio_url,
    tipo
  )

# cantidad de contenido total, en días
ht_contenido_ht <- sum(spotify$duracion_ms) / 1000 / 3600 / 24
ht_contenido_cc <- sum(country_club$duracion_ms) / 1000 / 3600 / 24
ht_contenido <- ht_contenido_ht + ht_contenido_cc

ht_dias <- floor(ht_contenido)
ht_horas <- round((ht_contenido - ht_dias)*24)

ht_dias_label <- glue("<b style='color:{cr}'>{ht_dias}</b>")
if (ht_horas == 1) {
   ht_horas_label <- glue("<b style='color:{cr}'>{ht_horas}</b> hora")
} else {
  ht_horas_label <- glue("<b style='color:{cr}'>{ht_horas}</b> horas")
}

# funciones ---------------------------------------------------------------

# las funciones incluyen un estilo condicional si pertenecen o no 
# al Country Club

# función para dar formato a la duración de los episodios
f_duracion <- function(value, index) {
  
  minutos <- round(value / 1000 / 60)
  dur_h <- floor(minutos / 60)
  dur_m <- minutos - dur_h * 60
  label_h <- glue("{dur_h}h")
  label_m <- glue("{dur_m}m")
  dur_label <- if_else(
    dur_h == 0,
    glue("{label_m}"),
    glue("{label_h}{dos_puntos}{label_m}")
  )
  
  if (d$tipo[index] == "pago") {
    
    dur_label_icono <- glue(
      "{icono_reloj_cc} <span style='color:{ca}'>{dur_label}</span>")
    return(dur_label_icono)
    
  } else {
    
    dur_label_icono <- glue("{icono_reloj} {dur_label}")
    return(dur_label_icono)
    
  }
  
  
}

# función para dar formato a la fecha de los episodios
f_fecha <- function(value, index) {

  fecha_label <- format(value, glue("%d{barras}%b{barras}%Y")) |>
    toupper() |>
    str_remove("\\.")
  
  if (d$tipo[index] == "pago") {
    
    fecha_label_icono <- glue(
      "{icono_calendario_cc} <span style='color:{ca}'>{fecha_label}</span>")
    return(fecha_label_icono)
    
  } else {
    
    fecha_label_icono <- glue("{icono_calendario} {fecha_label}")
    return(fecha_label_icono)
    
  }

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
  
  if (d$tipo[index] == "pago") {
    
    label <- glue(
      "<a target='_blank' href={v_link}>{icono_movie_cc} ",
      "<span style='color:{ca}'>{v_pelicula}</span> </a>")
    l <- str_flatten(label, collapse = "<br>")
    return(l)
    
  } else {
    
    label <- glue(
      "<a target='_blank' href={v_link}>{icono_movie} {v_pelicula}</a>")
    l <- str_flatten(label, collapse = "<br>")
    return(l)
    
  }

  
}

# función que agrega el link del episodio a Spotify
f_episodio <- function(value, index) {
  link <- d$episodio_url[index]
  
  if (d$tipo[index] == "pago") {
    label <- glue(
      "<a target='_blank' href={link}>{icono_play_cc} ",
      "<span style='color:{ca}'>{value}</span> </a>")
    return(label)
  } else {
    label <- glue(
      "<a target='_blank' href={link}>{icono_play} {value}</a>")
    return(label)
  }
  
}

# función que agrega formato a los números
f_numero <- function(value, index) {

  n <- value

  if (nchar(value) == 1) {
    n <- glue("00{value}")
  }

  if (nchar(value) == 2) {
    n <- glue("0{value}")
  }
  
  if (d$tipo[index] == "pago") {
    label <- glue("{icono_numeral_cc}{n}")
    return(label)
  } else {
    label <- glue("{icono_numeral}{n}")
    return(label)
  }

}

# función para mostrar las imágenes
# las imágenes del Country Club con borde amarillo
f_imagen <- function(value, index) {
  if (d$tipo[index] == "pago") {
    image <- img(
    src = value,
    style = glue("height: 200px; border:5px solid {ca};"),
    alt = value)
    tagList(div(style = "display: inline-block", image))
  } else {
    image <- img(
    src = value,
    style = glue("height: 200px"),
    alt = value)
    tagList(div(style = "display: inline-block", image))
  }

}

# función para cambiar el fondo de las celdas con imágenes
f_image_fondo <- function(value, index) {
  if (d$tipo[index] == "pago") {
    list(border = glue("10px solid {ca}"))
  } else {
    list(background = "transparent")
  }
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

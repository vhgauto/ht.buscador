
# tabla interactiva -------------------------------------------------------

r <- reactable(
  # datos
  data = d,
  # orden predeterminado por columna número de episodio
  defaultSorted = "nro",
  defaultSortOrder = "desc",
  # buscado en toda la tabla
  searchable = TRUE,
  # todas las filas en una única página
  pagination = FALSE,
  # configuración individual de cada columnas
  columns = list(

    nro = colDef(
      width = 100,
      searchable = FALSE,
      html = TRUE,
      header = with_tooltip("#", tooltip_nro),
      style = list(color = ca, fontFamily = "JetBrainsMonoNL Nerd Font Mono")
    ),

    episodio = colDef(
      sortable = FALSE,
      align = "left",
      width = 700,
      html = TRUE,
      header = with_tooltip("EPISODIO", tooltip_episodio),
      style = list(fontFamily = "Ubuntu"),
      headerStyle = list(textAlign = "center")
    ),

    imagen_url = colDef(
      name = "",
      sortable = FALSE,
      searchable = FALSE,
      align = "center",
      width = 250,
      cell = function(value) {
        image <- img(src = value, style = "height: 200px;", alt = value)
        tagList(
          div(style = "display: inline-block; ", image))}
    ),

    duracion_ms = colDef(
      html = TRUE,
      sortable = TRUE,
      width = 120,
      header = with_tooltip(icono_reloj_header, tooltip_duracion),
      cell = function(value) {
        f_duracion(value)
      }
    ),

    fecha = colDef(
      html = TRUE,
      sortable = TRUE,
      searchable = FALSE,
      header = with_tooltip(icono_calendario_header, tooltip_fecha),
      align = "center",
      width = 170,
      cell = function(value) {
        f_fecha(value)
      }
    ),

    pelicula = colDef(
      width = 450,
      html = TRUE,
      header = with_tooltip("PELÍCULA", tooltip_pelicula),
      searchable = TRUE,
      style = list(textAlign = "left", padding = "50px")
    )

  ),

  language = reactableLang(
    searchPlaceholder = "Buscar por episodio o película",
    noData = "Nada de nada"
  ),

  highlight = TRUE,
  striped = TRUE,
  bordered = FALSE,
  showSortIcon = TRUE,

  defaultColDef = colDef(
    headerClass = "header",
    align = "center",
    vAlign = "center"
  ),

  theme = reactableTheme(
    backgroundColor = cn,
    borderColor = cg3,
    color = cb,
    cellPadding = "20px 20px 20px 20px",
    cellStyle = list(fontFamily = "Ubuntu"),
    headerStyle = list(color = ca, fontFamily = "Friz Quadrata", fontSize = 30),
    highlightColor = cg2,
    stripedColor = cg1,
    searchInputStyle = list(
      marginTop = ".1rem",
      marginBottom = "3rem",
      width = "20%",
      border = "none",
      backgroundColor = cg1,
      alignSelf = "left",
      backgroundRepeat = "no-repeat",
      "&:focus" = list(backgroundColor = cg3, border = "none"),
      "::placeholder" = list(color = cg4),
      "&:hover::placeholder, &:focus::placeholder" = list(color = cb)
    )
  )
)

r

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
  # configuración individual de cada columna
  columns = list(

    nro = colDef(
      minWidth = 6,
      html = TRUE,
      searchable = FALSE,
      header = with_tooltip("#", tooltip_nro),
      style = list(color = ca, fontFamily = "JetBrains Mono")
    ),

    episodio = colDef(
      minWidth = 39,
      html = TRUE,
      sortable = FALSE,
      align = "left",
      header = with_tooltip("EPISODIO", tooltip_episodio),
      style = list(fontFamily = "Ubuntu"),
      headerStyle = list(textAlign = "center")
    ),

    imagen_url = colDef(
      minWidth = 14,
      name = "",
      sortable = FALSE,
      searchable = FALSE,
      align = "center",
      cell = function(value) {
        image <- img(src = value, style = "height: 200px;", alt = value)
        tagList(
          div(style = "display: inline-block; ", image))
      }
    ),

    duracion_ms = colDef(
      minWidth = 8,
      html = TRUE,
      sortable = TRUE,
      header = with_tooltip(icono_reloj_header, tooltip_duracion),
      cell = function(value) {
        f_duracion(value)
      }
    ),

    fecha = colDef(
      minWidth = 10,
      html = TRUE,
      sortable = TRUE,
      searchable = FALSE,
      header = with_tooltip(icono_calendario_header, tooltip_fecha),
      align = "center",
      cell = function(value) {
        f_fecha(value)
      }
    ),

    pelicula = colDef(
      minWidth = 27,
      html = TRUE,
      header = with_tooltip("PELÍCULA", tooltip_pelicula),
      headerStyle = list(paddingLeft = "50px"),
      searchable = TRUE,
      style = list(textAlign = "left", paddingLeft = "50px")
    )

  ),

  # texto en la barra de búsqueda
  language = reactableLang(
    searchPlaceholder = "Buscar por episodio o película",
    noData = "Nada de nada"
  ),

  # apariencia gral
  highlight = TRUE,
  striped = TRUE,
  bordered = FALSE,
  showSortIcon = TRUE,

  # estilo de todos los encabezados de tabla
  defaultColDef = colDef(
    headerClass = "header",
    align = "center",
    vAlign = "center"
  ),

  # tema
  theme = reactableTheme(
    backgroundColor = cn,
    borderColor = cg3,
    color = cb,
    cellPadding = "20px 20px 20px 20px",
    cellStyle = list(fontFamily = "Ubuntu"),
    headerStyle = list(
      color = ca, fontFamily = "Friz Quadrata", fontSize = 30,
      fontWeight = "bold"),
    highlightColor = cg2,
    stripedColor = cg1,
    # estilo de la barra de búsqueda
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

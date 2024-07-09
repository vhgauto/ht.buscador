
# tabla interactiva -------------------------------------------------------

r <- reactable(
  # datos
  data = d,
  # orden predeterminado por número de episodio, descendente
  defaultSorted = "nro",
  defaultSortOrder = "desc",
  # búsqueda en todas las columnas, excepto que se indique lo contrario
  searchable = TRUE,
  # todas las filas en una única página
  pagination = FALSE,
  # configuración individual por columna
  columns = list(

    nro = colDef(
      minWidth = 6,
      html = TRUE,
      searchable = FALSE,
      sortable = TRUE,
      header = with_tooltip("#", tooltip_nro),
      style = list(color = ca, fontFamily = "JetBrains Mono"),
      cell = function(value, index) {
        f_numero(value, index)
      }
    ),

    episodio = colDef(
      minWidth = 36,
      html = TRUE,
      sortable = FALSE,
      searchable = TRUE,
      align = "left",
      header = with_tooltip("EPISODIO", tooltip_episodio),
      cell = function(value, index) {
        f_episodio(value, index)
      }
    ),

    imagen_url = colDef(
      minWidth = 15,
      name = "",
      sortable = FALSE,
      searchable = FALSE,
      align = "center",
      cell = function(value, index) {
        f_imagen(value, index)
      }
    ),

    duracion_ms = colDef(
      minWidth = 8,
      html = TRUE,
      sortable = TRUE,
      searchable = FALSE,
      header = with_tooltip(icono_reloj_header, tooltip_duracion),
      cell = function(value, index) {
        f_duracion(value, index)
      }
    ),

    fecha = colDef(
      minWidth = 11,
      html = TRUE,
      sortable = TRUE,
      searchable = FALSE,
      header = with_tooltip(icono_calendario_header, tooltip_fecha),
      align = "center",
      cell = function(value, index) {
        f_fecha(value, index)
      }
    ),

    pelicula = colDef(
      minWidth = 24,
      html = TRUE,
      searchable = TRUE,
      sortable = FALSE,
      header = with_tooltip("PELÍCULA", tooltip_pelicula),
      headerStyle = list(paddingLeft = "50px"),
      style = list(textAlign = "left", paddingLeft = "50px"),
      cell = function(value, index) {
        f_pelicula(value, index)
      }
    ),

    # oculto dos columnas con links
    link_letterboxd = colDef(
      show = FALSE
    ),

    episodio_url = colDef(
      show = FALSE
    ),

    tipo = colDef(
      show = FALSE
    )

  ),

  # texto en la barra de búsqueda
  language = reactableLang(
    searchPlaceholder = "Buscar por episodio o película",
    noData = "Nada de nada."
  ),

  # apariencia general
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
      fontWeight = "bold", textAlign = "center"),
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

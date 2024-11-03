<span align="center">

# Tabla interactiva HOY TRASNOCHE

</span>

<p align="center">
<img src="img/logo.jpeg" width=40% align="center">
</p>

[<b>HOY TRASNOCHE</b>](https://open.spotify.com/show/6C4MdNWQSPhmzBlIVau30e?si=a46908e386a94946) es el único y mejor podcast ~~de cine~~ del mundo. Conducen [Fiorella Sargenti](https://www.instagram.com/fiosargenti) y [Santiago Calori](https://www.instagram.com/sancalori). El [<b>COUNTRY CLUB</b>](https://hoytrasnoche.com/vip/) es el podcast exclusivo para subscriptores.

El sitio web consiste de una tabla con datos de los episodios: nombre, fecha de publicación, duración y link para escucharlo; y de las películas: nombre, año de estreno y link a Letterboxd.

La tabla es interactiva, por lo que se puede ordenar por número de episodio, duración y fecha de publicación, o realizar una búsqueda por nombre de episodio/película.

<span align="center">

# [LINK :link:](https://vhgauto.github.io/ht.buscador/)

</span>

# Descripción

Se combinan códigos de programación en `R` (principalmente) y `python`. El sitio web utiliza datos de Spotify y Letterboxd, con ejecución automática via GitHub Actions y creación del sitio web mediante Quarto.

### Datos

Los datos de Spotify de [<b>HOY TRASNOCHE</b>](https://open.spotify.com/show/6C4MdNWQSPhmzBlIVau30e?si=a46908e386a94946) se acceden mediante la librería de Python [`{spotipy}`]((https://spotipy.readthedocs.io/)), para lo cual es necesario tener credenciales de la [API](https://developer.spotify.com/documentation/web-api).

Los datos provenientes del [<b>COUNTRY CLUB</b>](https://hoytrasnoche.com/vip/) se extraen de forma manual del sitio. En una versión futura se prevee automatizar esta etapa.

Los datos de las películas provienen de dos listas de Letterboxd: [Hoy Trasnoche - Con capítulo](https://letterboxd.com/matiasec/list/hoy-trasnoche-con-capitulo/) y [Hoy Trasnoche - Country Club](https://letterboxd.com/matiasec/list/hoy-trasnoche-country-club/), en donde se incluye el nombre del episodio. No he revisado exhaustivamente la lista. Se utilizó el paquete [`{rvest}`]((https://rvest.tidyverse.org/)) para el <i>web scrapping</i>.

Los episodios que componen la tabla son los <i>tradicionales</i>, es decir, en los que se discute una (o múltiples) película(s). No se consideraron los ranking de fin de año, los <b>Hoy Trasnoche Diario</b> o en los que se promocionaron otros productos (Mató Mil, Dr. Muerte), ni las recomendaciones del Videoclub.

La columna de películas contiene los links a las mismas en Letterboxd y los nombres están en su mayoría en inglés, excepto las para las películas en español. Los episodios en los que se comentó más de una película se agrupan dentro del mismo episodio.

La transformación de datos se llevó a cabo con los paquetes de [`{tidyverse}`]((https://www.tidyverse.org/)).

### Tabla interactiva

La tabla se creó con el paquete [`{reactable}`](https://glin.github.io/reactable/), que permite agregar un buscador y acomodar las columnas de forma ascendente/descendente, de acuerdo al contenido.

### Sitio web

El sitio web está creado con [Quarto](https://quarto.org/), generando un archivo `.html`, que es usado para su publicación mediante [GitHub Pages](https://pages.github.com/).

### Ejecución

La ejecución es parcialmente automática. La descarga de los datos de Spotify y la generación y publicación del sitio web está a cargo de [GitHub Actions](https://docs.github.com/es/actions).

El agregado de los datos de las películas de cada episodio se hace de forma manual. Cada vez que se publique un nuevo episodio, se añade la película y su información al repositorio para luego ejecutar el código entero.

### Entorno de ejecución

Para asegurar la reproducibilidad se utilizó [Conda](https://docs.conda.io/en/latest/), indicando las versiones de las herramientas informáticas. Así las funciones mantienen siempre la misma ejecución.

# Extras

Se describen a continuación los motivos personales que me llevaron a desarrollar este proyecto, los cambios a implementar en el largo plazo y una aclaración de importancia.

### Motivación

Soy entusiasta en el manejo de datos, programación y visualización, siempre en búsqueda de aprender nuevas herramientas informáticas, siendo `R` mi lenguaje favorito. Pueden ver el resto de mis [repositorios](https://github.com/vhgauto?tab=repositories) para que se hagan una idea.

Escucho [<b>HOY TRASNOCHE</b>](https://open.spotify.com/show/6C4MdNWQSPhmzBlIVau30e?si=a46908e386a94946) desde el primer momento y soy miembro del [<b>COUNTRY CLUB</b>](https://hoytrasnoche.com/vip/). Gracias al podcast aprendí a apreciar el cine en mayor profundidad y entender las dinámicas de la industria. Les estoy eternamente agradecidos por el conocimiento y las risas.

Pienso en este sitio web como un recurso de consulta. Para verificar si alguna película fue analizada, o si se desea volver a escuchar un episodio en particular.

### A futuro

En una versión posterior voy a automatizar los episodios y películas del [<b>COUNTRY CLUB</b>](https://hoytrasnoche.com/vip/), que requieren otro acercamiento ya que no están disponibles en Spotify.

### Aclaración

> [!NOTE]
> Este sitio web, su desarrollo y mantenimiento son un proyecto personal. No estoy involucrado de ninguna manera con el podcast ni con sus conductores.

# Contacto

Autor y responsable del repositorio: Mgtr. Víctor Gauto

Estoy abierto a recibir comentarios, correcciones y sugerencias. No dudes en ponerte en contacto.

[<img src='https://raw.githubusercontent.com/CLorant/readme-social-icons/refs/heads/main/medium/colored/twitter.svg'/>](https://twitter.com/vhgauto)
[<img src='https://raw.githubusercontent.com/CLorant/readme-social-icons/refs/heads/main/medium/colored/instagram.svg'/>](https://www.instagram.com/vhgauto/)
[<img src='https://joinmastodon.org/logos/logo-purple.svg' width=24 />](https://mastodon.social/@vhgauto)
[<img src='https://raw.githubusercontent.com/CLorant/readme-social-icons/refs/heads/main/medium/colored/github.svg' width=24 />](https://github.com/vhgauto)

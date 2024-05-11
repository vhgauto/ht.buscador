# Tabla interactiva HOY TRASNOCHE

<p align="center">
<img src="img/logo.jpeg" width=30% align="center">
</p>

[HOY TRASNOCHE](https://open.spotify.com/show/6C4MdNWQSPhmzBlIVau30e?si=a46908e386a94946) es el único podcast de cine. Conducen [Fiorella Sargenti](https://www.instagram.com/fiosargenti) y [Santiago Calori](https://www.instagram.com/sancalori).

El sitio web contiene los episodios, fecha de publicación y duración, junto con la película comentada, y los links para escuchar los episodios.

La tabla es interactiva, por lo que se puede ordenar por número de episodio, duración y nombre de película, o realizar una búsqueda por nombre de episodio/película.

# [LINK](https://vhgauto.github.io/ht.buscador/)

# Descripción

Se combinan lenguajes de programación en R (principalmente) y Python. El sitio web combina datos de Spotify y Letterboxd, con ejecución automática via GitHub Actions y creación del sitio web mediante Quarto.

## Datos

Los datos de Spotify de <b>HOY TRASNOCHE</b> se acceden mediante la librería de Python <code>{[spotipy](https://spotipy.readthedocs.io/)}</code>, para lo cual es necesario tener credenciales de la [API de Spotify](https://developer.spotify.com/documentation/web-api).

Los datos de las películas provienen de esta [lista de Letterboxd](https://letterboxd.com/matiasec/list/hoy-trasnoche-con-capitulo/) que incluye el nombre del episodio. Se utilizó el paquete a <code>[{rvest}](https://rvest.tidyverse.org/)</code> para el <i>web scrapping</i>.

La transformación de datos se llevó a cabo con los paquetes de <code>[{tidyverse}](https://www.tidyverse.org/)</code>.

## Creación de tabla interactiva

La tabla se creó con el paquete <code>[{reactable}](https://glin.github.io/reactable/)</code>, que permite agregar un buscador y acomodar las columnas de forma ascendente/descendente, de acuerdo al contenido.

## Sitio web

El sitio web está creado con [Quarto](https://quarto.org/), generando un archivo .html, que es usado para su publicación mediante [GitHub Pages](https://pages.github.com/).

## Ejecución

La ejecución es parcialmente automática. La descarga de los datos de Spotify y la generación y publicación del sitio web está a cargo de [GitHub Actions](https://docs.github.com/es/actions).

El agregado de los datos de las películas comentadas en cada episodio se hace de forma manual. Cada vez que se publique un nuevo episodio, se añade la película y su información al repositorio para luego ejecutar el código entero.

## Entorno de ejecución

Para asegurar la reproducibilidad se utilizó [Conda](https://docs.conda.io/en/latest/) indicando versiones de los paquetes y de <code>R</code>. Así las funciones mantienen siempre la misma ejecución.

# Contacto

Autor y responsable del repositorio: Mgtr. Víctor Gauto

Redes sociales: [Twitter](https://twitter.com/vhgauto), [Instagram](https://www.instagram.com/vhgauto/), [GitHub](https://github.com/vhgauto) y [Mastodon](https://mastodon.social/@vhgauto).

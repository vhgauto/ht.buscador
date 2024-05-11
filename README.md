# Tabla interactiva HOY TRASNOCHE

[HOY TRASNOCHE](https://open.spotify.com/show/6C4MdNWQSPhmzBlIVau30e?si=a46908e386a94946) es el único podcast de cine.

Conducen [Fiorella Sargenti](https://www.instagram.com/fiosargenti) y [Santiago Calori](https://www.instagram.com/sancalori).

Sitio web que contiene los episodios, fecha y duración, junto con la película comentada.

La tabla es interactiva, por lo que se puede ordenar por número de episodio, duración y nombre de película.

# [LINK](https://vhgauto.github.io/ht.buscador/)

# Acceso a los datos

Los datos de HOY TRASNOCHE de Spotify se acceden mediante la librería de Python <code>{[spotipy](https://spotipy.readthedocs.io/)}</code>, para lo cual es necesario tener credenciales de la [API de Spotify](https://developer.spotify.com/documentation/web-api).

Los datos de las películas provienen de esta [lista de Letterboxd](https://letterboxd.com/matiasec/list/hoy-trasnoche-con-capitulo/) que incluye el nombre del episodio.

# Procesamiento

El lenguaje de programación principal es <code>R</code>. El manejo de datos utilizó los paquetes de <code>[{tidyverse}](https://www.tidyverse.org/)</code>.

La tabla interactiva se creó con el paquete <code>[{reactable}](https://glin.github.io/reactable/)</code>.

El procesamiento de los datos tiene ejecución automática mediante <b>GitHub Actions</b>.
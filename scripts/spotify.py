#!/usr/bin/env python
# coding: utf-8

# script para obtener la información de Hoy Trasnoche disponible en Spotify

# conectarme a Spotify
import spotipy
from spotipy.oauth2 import SpotifyOAuth

# manejo de datos
import pandas as pd

# acceso a las credenciales
import os

# credenciales

sp = spotipy.Spotify(
  auth_manager = SpotifyOAuth(
    client_id = os.environ['CLIENT_ID'],
    client_secret = os.environ['CLIENT_SECRET'],
    redirect_uri = "http://localhost:1410/",
    scope = "user-read-playback-position"))

# ID de Hoy Trasnoche en Spotify
ht_id = "6C4MdNWQSPhmzBlIVau30e"

# resultados
ht = sp.show_episodes(ht_id, limit = 50, offset = 0, market = None)

# el acceso a los datos se puede hacer de a 50 episodios por ve z
# loop para descargar todos los episodios disponibles
d = []

# variables temporales para inciar el loop
total = 1 
offset = 0

# loop
while offset < total:
  results = sp.show_episodes(ht_id, limit = 50, offset = offset, market = None)
  total = 310
  offset += 50 # aumento del offset
  for i, item in enumerate(results['items']):
    episodio = item['name']
    desc = item['description']
    duracion_ms = item['duration_ms']
    id = item['id']
    imagen_url = item['images'][0]['url']
    fecha = item['release_date']
    episodio_url = item['external_urls']['spotify']
    
    d.append((episodio, desc, duracion_ms, id, imagen_url, fecha, episodio_url))

df = pd.DataFrame(
  d, 
  columns=('episodio', 'desc', 'duracion_ms', 'id', 'imagen_url', 'fecha', 'episodio_url'))

print("\n\n--- Se encontraron", len(df), "episodios ---\n\n")

# guardo los datos en un .csv
df.to_csv("datos/spotify.csv", index=False)

print("\n\n--- Datos guardados ---\n\n")

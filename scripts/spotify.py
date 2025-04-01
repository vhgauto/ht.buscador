#!/usr/bin/env python
# coding: utf-8

# script para obtener la información de Hoy Trasnoche disponible en Spotify

# conectarme a Spotify
import spotipy
from spotipy.oauth2 import SpotifyOAuth

# credenciales
import requests
import base64
import os

# manejo de datos
import pandas as pd

# función que genera un token a partir de las credenciales de Spotify
def refresh_access_token(refresh_token):
    client_id = os.environ['SPOTIPY_CLIENT_ID']
    client_secret = os.environ['SPOTIPY_CLIENT_SECRET']
    payload = {
        'grant_type': 'refresh_token',
        'refresh_token': refresh_token,
    }
    auth_header = {'Authorization': 'Basic ' + base64.b64encode((client_id + ':' + client_secret).encode()).decode()}
    response = requests.post('https://accounts.spotify.com/api/token', data=payload, headers=auth_header)
    return response.json().get('access_token')

# genero nuevo token a partir del refresh token
refresh_token = os.environ['SPOTIPY_REFRESH_TOKEN']
new_access_token = refresh_access_token(refresh_token)

# configuro acceso a Spotify
sp = spotipy.Spotify(auth=new_access_token)

# ID de Hoy Trasnoche en Spotify
ht_id = "6C4MdNWQSPhmzBlIVau30e"

# resultados
ht = sp.show_episodes(ht_id, limit = 50, offset = 0, market = None)

# el acceso a los datos se puede hacer de a 50 episodios por vez,
# loop para descargar todos los episodios disponibles
d = []

# variables temporales para inciar el loop
total = 1 
offset = 0

# loop
while offset < total:
  results = sp.show_episodes(ht_id, limit = 50, offset = offset, market = None)
  total = 400
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

# tabla con los datos de HT
df = pd.DataFrame(
  d, 
  columns=('episodio', 'desc', 'duracion_ms', 'id', 'imagen_url', 'fecha', 'episodio_url'))

# mensaje en consola
print("\n\n--- Se encontraron", len(df), "episodios ---\n\n")

# guardo los datos en un .csv
df.to_csv("datos/spotify.csv", index=False)

# mensaje en consola
print("\n\n--- Datos guardados ---\n\n")

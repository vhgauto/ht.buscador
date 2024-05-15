#!/usr/bin/env bash

# extraigo datos de Spotify
python scripts/spotify.py

# genero .html
quarto render index.qmd
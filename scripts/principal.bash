#!/usr/bin/env bash

# extraigo datos de Spotofy
python scripts/spotify.py

# genero .html
quarto render index.qmd
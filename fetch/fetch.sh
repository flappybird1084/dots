#!/bin/bash
random_number=$((RANDOM % 100))
pokemon_list="bulbasaur
charmander
squirtle
pikachu
espurr
plusle
minun
clefairy
buizel
tangela
shaymin
mew
jirachi
mudkip
oshawott
dratini
minccino
treecko
torchic"
# targetmon=$(shuf -n 1 ~/Documents/projects/coding/scripts/fetched-pokemon.txt)
targetmon=$(shuf -n 1 <(echo "$pokemon_list"))
if [ "$random_number" -lt 20 ]; then
echo "✨"
pokeget -s "$targetmon" --hide-name | fastfetch -c ~/rians-projects/Coding/shell/fetch/config.jsonc --file-raw -

else
pokeget "$targetmon" --hide-name | fastfetch -c ~/rians-projects/Coding/shell/fetch/config.jsonc --file-raw -
fi

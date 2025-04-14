#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo .... ${endColour} \n"
  tput cnorm; exit 1
}

# Ctrl + C
trap ctrl_c INT

# Functions

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso de: $0 ${endColour}"
  echo -e "\t${purpleColour}m)${endColour}${grayColour} Buscar por un nombre de película${endColour}"
  echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar este panel de ayuda${endColour}\n"
}

function searchMovie(){
  movieName="$1"

  movieName_checker="$(cat netflix_peliculas.js | grep -A 9 -i "\"titulo\": \"$movieName\"" | tr -d '"' | tr -d ',' | sed 's/ *//' | sed 's/--//')"

  if [ "$movieName_checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las características de la pelicúla${purpleColour} $movieName${endColour}${grayColour}:${endColour}\n"
    IFS=$'\n'
    for line in $movieName_checker; do
      key_movie="$(echo $line | awk '{print $1}')"
      information_movie="$(echo $line | cut -d ":" -f 2-)"
      echo -e "${greenColour}$key_movie${endColour}${grayColour}$information_movie${endColour}"
      if [ "$key_movie" == "link:" ]; then
        echo -e "\n"
      fi
    done
  else
    echo -e "\n${redColour}[!] La película $movieName no existe${endColour}"
  fi
}

# Indicadores
declare -i parameter_counter=0

# Parámetros
while getopts "m:h" arg; do
  case $arg in
    m) movieName="$OPTARG"; let parameter_counter+=1;;
    h) ;;
  esac
done

if [ "$parameter_counter" -eq 1 ]; then
  searchMovie "$movieName"
else
  helpPanel
fi


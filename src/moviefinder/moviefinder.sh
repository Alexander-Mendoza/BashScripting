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
  echo -e "\t${purpleColour}y)${endColour}${grayColour} Buscar por película por su año${endColour}"
  echo -e "\t${purpleColour}l)${endColour}${grayColour} Buscar el link de la película${endColour}"
  echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar este panel de ayuda${endColour}\n"
}

function searchMovie(){
  movieName="$1"

  movieName_checker="$(cat netflix_peliculas.js | grep -A 9 -i "\"titulo\": \"$movieName\"" | tr -d '"' | tr -d ',' | sed 's/ *//' | sed 's/--//')"

  if [ "$movieName_checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las características de la película${purpleColour} $movieName${endColour}${grayColour}:${endColour}\n"
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

function searchYear(){
  year="$1"
  
  movieName="$(cat netflix_peliculas.js | grep "\"año\": $year" -B 1 | grep "\"titulo\": " | tr -d '"' | tr -d ',' | awk '{print $2}' FS=":" | sed 's/ *//' | column)"

  if [ "$movieName" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representado las películas que salieron en el año${endColour}${blueColour} $year${endColour}${grayColour}:${endColour}"
    echo -e "\n${greenColour}$movieName${endColour}"
  else
    echo -e "\n${redColour}[!] No se existe un película con el año indicado.${endColour}"
  fi

}

function getLink(){
  movieName="$1"

  link="$(cat netflix_peliculas.js | awk "/\"titulo\": \"$movieName\"/,/\"link\"/" | tr -d '"'| tr -d ',' | sed 's/^ *//' | grep "link" | awk 'NF{print $NF}')"

  if [ "$link" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los links para las peliculas con el nombre proporcionado son los siguientes:${endColour}\n${blueColour}$link${endColour} "
  else
    echo -e "\n${redColour}[!] El link para la película '$movieName' proporcionada no existe${endColour}"
  fi

}

# Indicadores
declare -i parameter_counter=0

# Parámetros
while getopts "m:y:l:h" arg; do
  case $arg in
    m) movieName="$OPTARG"; let parameter_counter+=1;;
    y) year="$OPTARG"; let parameter_counter+=2;;
    l) link="$OPTARG"; let parameter_counter+=3;;
    h) ;;
  esac
done

if [ "$parameter_counter" -eq 1 ]; then
  searchMovie "$movieName"
elif [ "$parameter_counter" -eq 2 ]; then
  searchYear "$year"
elif [ "$parameter_counter" -eq 3 ]; then
  getLink "$link"
else
  helpPanel
fi


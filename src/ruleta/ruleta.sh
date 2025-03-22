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
	echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
	tput cnorm; exit 1
}

#Ctrl+C
trap ctrl_c INT

function helpPanel(){
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} $0${endColour}\n"
	echo -e "\t${blueColour}-m)${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"
	echo -e "\t${blueColour}-t)${endColour}${grayColour} Técnica a utilizar${endColour}${purpleColour} (${endColour}${yellowColour}martingala${endColour}${blueColour}/${endColour}${yellowColour}iverseLabrouchere${endColour}${purpleColour})${endColour}\n"
	exit 1
}

function martingala(){
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${greenColour} $money€${endColour}"
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero tienes pensado apostar? ->${endColour} " && read initial_bet
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? ->${endColour} " && read par_impar

	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de${endColour}${yellowColour} $initial_bet€${endColour}${grayColour} a${endColour}${yellowColour} $par_impar${endColour}"

	#Crear un backup del dinero apostado
	backup_bet=$initial_bet
	
	#Contador para las jugadas
	play_counter=1

	#Contador de jugadas malas
	jugadas_malas="["

	#Contador de dinero maxima
	max_money=0

	tput civis #Ocultar cursor
	while true; do
		#Se le resta lo apostado al dinero total
		money=$(($money-$initial_bet))
#		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour}${yellowColour} $initial_bet€${endColour}${grayColour} y tienes${endColour}${yellowColourColour} $money€${endColour}"
		
		#Para decirle que me dé un número random del 0 al 36
		random_number="$(($RANDOM % 37))"
#		echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour}${blueColour} $random_number${endColour}"
		
		#-le --> Menor igual
		if [ ! "$money" -le 0 ]; then
			if [ "$par_impar" == "par" ]; then
				if [ "$(($random_number % 2))" -eq 0 ]; then
					if [ "$random_number" -eq 0 ]; then
#						echo -e "${redColour}[+] Ha salido el 0, por tanto perdemos${endColour}"
						initial_bet=$(($initial_bet*2))
#						echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mimso te quedas en${endColour}${yellowColour} $money€${endColour}"
						jugadas_malas+="$random_number "
					else
#						echo -e "${yellowColour}[+]${endColour}${greenColour} El número que ha salido es par, ¡ganas!${endColour}"
						#Es la recompensa, ya que cuando se gana, se recupera lo perdido más el doble
						reward=$(($initial_bet*2))
#						echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour}${yellowColour} $reward€${endColour}"
						#se suma la recompensa al dinero total
						money=$(($money+$reward))
#						echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${yellowColour} $money€${endColour}"
						initial_bet=$backup_bet
						jugadas_malas="[ "

						# -gt es mayor que
						if [ "$money" -gt "$max_money" ]; then
							max_money="$money"
						fi
					fi
				else
#					echo -e  "${yellowColour}[+]${endColour}${redColour} El número que ha salido es impar, ¡pierdes!${endColour}"
					#Cuando se pierde la apuesta se duplica
					initial_bet=$(($initial_bet*2))

					#Se añade el número impar que salió
					jugadas_malas+="$random_number "
#					echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mimso te quedas en${endColour}${yellowColour} $money€${endColour}"
				fi
				#sleep 2
			fi
		else
			#Se ha quedado sin dinero
			echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}\n"
			echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de${endColour}${yellowColour} $play_counter${endColour}${grayColour} jugadas${endColour}"
			echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuación se van a representar las malas jugas consecutivas que han salido${endColour}\n"
			echo -e "${blueColour}$jugadas_malas]${endColour}"

			echo -e "\n${yellowColour}[+]${endColour}${grayColour} Máximo de dinero alcanzado: ${endcolour}${yellowColour} $max_money${endColour} \n"
			tput cnorm; exit 0
		fi

		#sumar uno a la variable
		let play_counter+=1
	done

	tput cnorm #Recuperar el cursor
}

while getopts "m:t:h" arg; do
	case $arg in
		m) money="$OPTARG";;
		t) technique="$OPTARG";;
		h) helpPanel;;
	esac
done

if [ "$money" ] && [ "$technique" ]; then
	if [ "$technique" == "martingala" ]; then
		martingala
	else
		echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}"
		helpPanel
	fi
else
	helpPanel	
fi

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

#	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de${endColour}${yellowColour} $initial_bet€${endColour}${grayColour} a${endColour}${yellowColour} $par_impar${endColour}"

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
		
		#-le --> Menor o igual
		if [ ! "$money" -lt 0 ]; then
			if [ "$par_impar" == "par" ]; then
				#Todo esto es para cuando se apuesta un número par.
				if [ "$(($random_number % 2))" -eq 0 ]; then
					if [ "$random_number" -eq 0 ]; then
#						echo -e "${redColour}[+] Ha salido el 0, por tanto perdemos${endColour}"
						initial_bet=$(($initial_bet*2))
#						echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mimso te quedas en${endColour}${yellowColour} $money€${endColour}"
						jugadas_malas+=" $random_number "
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
					jugadas_malas+=" $random_number "
#					echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mimso te quedas en${endColour}${yellowColour} $money€${endColour}"
				fi
				#sleep 2
			else
				#Cuando se apuesta por número impar.
				if [ "$(($random_number % 2))" -eq 1 ]; then
#					echo -e "${yellowColour}[+]${endColour}${greenColour} El número que ha salido es impar, ¡ganas!${endColour}"
					#Es la recompensa, ya que cuando se gana, se recupera lo perdido más el doble
					reward=$(($initial_bet*2))
#					echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour}${yellowColour} $reward€${endColour}"
					#se suma la recompensa al dinero total
					money=$(($money+$reward))
#					echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${yellowColour} $money€${endColour}"
					initial_bet=$backup_bet
					jugadas_malas="[ "

					# -gt es mayor que
					if [ "$money" -gt "$max_money" ]; then
						max_money="$money"
					fi
				else
#					echo -e  "${yellowColour}[+]${endColour}${redColour} El número que ha salido es par, ¡pierdes!${endColour}"
					#Cuando se pierde la apuesta se duplica
					initial_bet=$(($initial_bet*2))

					#Se añade el número impar que salió
					jugadas_malas+=" $random_number "
#					echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mimso te quedas en${endColour}${yellowColour} $money€${endColour}"
				fi

			fi
		else
			#Se ha quedado sin dinero
			echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}\n"
			echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de${endColour}${yellowColour} $(($play_counter-1))${endColour}${grayColour} jugadas${endColour}"
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

function inverseLabrouchere(){

	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${greenColour} $money€${endColour}"
        echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? ->${endColour} " && read par_impar
	
	# Declarmos el Array que contiene la secuencia con la que jugaremos.
	declare -a my_sequence=(1 2 3 4)
	jugadas_totales=0
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

	#Comenzamos el bucle
	tput civis #Ocultar el cursor
	while true; do
		
		let jugadas_totales+=1
		#El total de elementos de nuestro array tiene que se mayor a 1 para que pueda sumar los extremos
		if [ "${#my_sequence[@]}" -gt 1 ]; then
			#Nuestra apuesta se basa en sumar el primer y último elemento de Array
			bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
		else
			#Si nuestro array no es mayor que uno significa que solo hay un elemento que será nuestra siguiente apuesta
			bet=${my_sequence[0]}
		fi

		#Le restamos la apuesta realizada al dinero total
		let money-=$bet
		
		#Si el dinero no es menor que cero
		if [ ! "$money" -lt 0 ]; then
			echo -e "\n${yellowColour}[+]${endColour}${grayColour} Invertimos${endColour}${yellowColour} $bet€${endColour}"
			echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour}${yellowColour} $money€${endColour}"

			#Generamos el número random
			random_number=$(($RANDOM % 37))
			echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour}${blueColour} $random_number${endcolour}"

			if [ "$par_impar" == "par" ]; then
				if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ] ; then
					echo -e "${yellowColour}[+]${endColour}${grayColour} El número es par, ¡ganas!${endColour}"
					
					#Calculamos la recompensa
					reward=$(($bet*2))

					#Sumamos la recompensa al dinero total
					let money+=$reward
					echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${blueColour} $money€${endColour}"
					
					#Sumamos a la secuencia lo apostado anteriormente
					my_sequence+=($bet)
					my_sequence=(${my_sequence[@]})

					echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra nueva secuencia es${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
				else #Si el número es impar o es cero
					if [ "$random_number" -eq 0 ]; then
						echo -e "${redColour}[!] Ha salido el número cero, ¡pierdes!${endColour}"
					else
						echo -e "${redColour}[!] El número es impar, ¡pierdes!${endColour}"
					fi
					if [ "${#my_sequence[@]}" -gt 2 ]; then
						#Eliminamos el primer  el último elemento del Array
						unset my_sequence[0]
						unset my_sequence[-1]
					else
						my_sequence=(1 2 3 4)
						echo -e "${redColour}[!] Hemos perdidio nuestra secuencia, será restablecida${endColour}"
					fi
					#Para que no dé conflicto se debe volver asignar el contenido al array.	
					my_sequence=(${my_sequence[@]})
					echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia se nos queda de la siguiente forma: ${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
				fi
			fi
		else
			echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}"
			echo -e "${yellowColour}[+]${endColour}${grayColour} En total han habido${endColour}${yellowColour} $jugadas_totales${endColour}${grayColour} jugadas totales${endColour}\n"

			tput cnorm; exit 1
		fi
		#sleep 1
	done
	tput cnorm #Volver a mostrar el cursor.
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
	elif [ "$technique" == "inverseLabrouchere" ]; then
		inverseLabrouchere		
	else
		echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}"
		helpPanel
	fi
else
	helpPanel	
fi

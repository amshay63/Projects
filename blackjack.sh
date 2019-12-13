#!/bin/bash
#This Program Will Simulate a Basic Game of Black Jack
clear
#Create Deck Array Creation Function
deck=(
"AH" "AD" "AS" "AC"
"2H" "2D" "2S" "2C"
"3H" "3D" "3S" "3C"
"4H" "4D" "4S" "4C"
"5H" "5D" "5S" "5C"
"6H" "6D" "6S" "6C"
"7H" "7D" "7S" "7C"
"8H" "8D" "8S" "8C"
"9H" "9D" "9S" "9C"
"10H" "10D" "10S" "10C"
"JH" "JD" "JS" "JC"
"QH" "QD" "QS" "QC"
"KH" "KD" "KS" "KC"
)

#Shuffle Deck
deck=( $(shuf -e "${deck[@]}") )

#Initialize User and Dealer Hands
dealer=()
user=()
dealerCount=0
userCount=0
deckCount=51

#Function to Add to the Users Deck
function hitUser(){
	#Set Value of Card
	card=${deck[$deckCount]}
	value=${card:0:1}
	if ! [[ $value =~ [2-9] ]]
	then
		if [[ "$value" = "A" ]]
		then
			if [[ $userCount -le 10 ]]
			then
				value=11
			else
				value=1
			fi
		else
			value=10
		fi
	else
		if [[ $value -eq 1 ]]
		then 
			value=10
		fi
	fi
	user=( "${user[@]}" "$card" )
	userCount=$(( $userCount + $value ))
	unset "deck[deckCount]"
	deckCount=$(( $deckCount - 1 ))
}

#Function to Add to the Dealers Deck
function hitDealer(){
	card=${deck[$deckCount]}
        value=${card:0:1}
	if ! [[ $value =~ [2-9] ]]
        then
		if [[ "$value" = "A" ]]
        	then
                	if [[ $dealerCount -le 10 ]]
        		then
                		value=11
        		else
                		value=1
        		fi
        	else
	        	value=10
        	fi
	else
		if [[ $value -eq 1 ]]
        	then
			value=10
        	fi
        fi
        dealer=( "${dealer[@]}" "$card" )
	dealerCount=$(( $dealerCount + $value ))
	unset "deck[deckCount]"
	deckCount=$(( $deckCount - 1 ))
}
#Function to Display Dealer and Users Hand (before stand)
function display1(){
	clear
	echo "Dealer's Current Hand: "
	echo -n "[${dealer[0]}]"
	echo -n "[?]"
	echo " "
	echo "Your Current Hand: "
	for i in "${user[@]}"
	do
		echo -n "[$i]"
		echo -n " "
	done
	echo " "
	echo "Current Value of Dealer's Hand: ?"
	echo "Current Value of Your Hand: $userCount"
	echo " "

}
function display2(){
	clear
	echo "Dealer's Current Hand: "
        for i in "${dealer[@]}"
        do
		echo -n "[$i]"
		echo -n " "
	done
	echo " "
	echo "Your Current Hand: "
	for i in "${user[@]}"
	do
		echo -n "[$i]"
		echo -n " "
	done
	echo " "
	echo "Current Value of Dealer's Hand: $dealerCount"
        echo "Current Value of Your Hand: $userCount"
        echo " "
}
#Game Start
function round(){
	clear
	valid="false"
	until [ $valid = "true" ]
	do
	display1
	#Get input for whether or not to hit or stand
	echo "Actions: "
        echo "-Hit      (H)"
	echo "-Stand    (S)"
	read input
	shopt -s nocasematch
	case "$input" in
	"h") {
		valid="true"
		clear
                echo "Hit!"
		hitUser
		if [ $userCount -gt 21 ]
		then
			display2
			echo "You Lose"
		else
			round
		fi
	};;
	#If Stand, hit dealer, and test the score of each hand
	"s") {
		valid="true"
		clear
		echo "Stand..."
		while [ $dealerCount -lt 17 ]
		do
			hitDealer
		done
		display2
		if [ $dealerCount -gt 21 ] 
		then
			echo "You Win!"
		fi
		if [ $dealerCount -eq $userCount ]
		then
			echo "Tie"
		elif [ $dealerCount -gt $userCount ] && [ $dealerCount -le 21 ]
		then
			echo "You Lose"
		elif [ $dealerCount -lt $userCount ]
		then
			echo "You Win!"
		fi
	};;
	*) {
	echo "Invalid Input"
	sleep 1
	};;
	esac
	done
}

#Prompt User to Deal First Round of Cards
valid="false"
until [ $valid = "true" ]
do
clear
echo 'Type "Deal" to Deal Cards.'
read input
shopt -s nocasematch
case "$input" in
"deal") {
	valid="true" 
	clear
 echo "Dealing Cards..."
	hitUser
	hitUser
	hitDealer
	hitDealer
	round
};;

*) {
echo "Invalid Input"
sleep 1
};;
esac
done
#Restart
valid="false"
until [ $valid = "true" ] 
do
echo "Replay? (Y/N)"
read input
shopt -s nocasematch
case "$input" in
"y") {
valid="true"
exec $(readlink -f "$0")
};;
"n") {
clear
echo "Goodbye..."
valid="true"
};;

*) {
echo "Invalid Input"
sleep 1
};;
esac
done

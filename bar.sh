#!/usr/bin/env bash

# Daniel Mendoza
# Bar configuration

font0="Terminus:style=Bold:pixelsize=14"
font1="Font Awesome 5 Free Solid:style=Solid:pixelsize=14"

back="#03303a"
forg="#98dbea"
lbac="#03191e"
lfor="#5c858e"

power(){
	echo -n "%{F${lfor}}%{B${lbac}}%{A:power:} Hola $USER  %{F-}%{B-}%{A}"
}

timer(){
	echo -n "%{F${lfor}}%{B${lbac}}$(date +"%d/%m/%Y %H:%M:%S")%{F-}%{B-}"
}
main(){
	while :;
	do
		echo -n "%{l}$(power) %{r}$(timer)"
		sleep 0.1s
	done
}

main  | lemonbar -p -f "${font0}" -f "${font1}" \
	-F "${lfor}" -B "${lbac}"| \
	while read line
	do
		case ${line} in
			power)
				echo POWER
				;;
			*)
				exit 1
				;;
		esac
	done

#!/usr/bin/env bash

# Daniel Mendoza
# Bar configuration

font0="Terminus:style=Bold:pixelsize=18"
font1="Font Awesome 5 Free Solid:style=Solid:pixelsize=14"
font2="Font Awesome 5 Brands:style=Regular:pixelsize=16"
declare -a {g_vol,dektops,occupied_desks,free_desks,focused_desk}

back="#03303a"
forg="#98dbea"
lbac="#03142b"
lfor="#8fcaf7"
ifor="#0f9daa"
ibfo="#53647c"
uifo="#c8ce27"
difo="#eff700"
vfor="#71f45d"

wmanager(){
	desktops=($(bspc query -D --names))
	focused_desk=($(bspc query -D -d .focused --names))
	free_desks=($(bspc query -D -d .\!occupied --names))
	occupied_desks=($(bspc query -D -d .occupied --names))
	icons=(      )
	for((i=0;i<${#desktops[@]};++i));do
		if [[ $focused_desk == ${desktops[$i]} ]] ; then
			f_desk=$((i+1))
			echo -n "%{F${lfor}} ${icons[$i]}%{F-}"
			# echo -n "%{F${difo}} ${icons[$f_desk]}[${f_desk}]%{F-}"
			# focused="%{F${difo}} ${icons[$fdesk]}[${f_desk}]%{F-}"
		fi
	done
	unset i
	for((i=0;i<${#occupied_desks[@]};++i));do
		if [[ $focused_desk != ${occupied_desks[$i]} ]] ; then
			o_desk=$((i+1))
			echo -n "%{F${ibfo}} ${icons[$i]}%{F-}"
			# echo -n "%{F${lfor}} ${icons[$o_desk]}[${o_desk}]%{F-}"
			# occupied="%{F${lfor}} OCC[${o_desk}]%{F-}"
			# actual_desk+=(${f_desk} ${o_desk})
			# echo -n " ${actual_desk[@]}" | tr ' ' '\n' \
			# 	| sort -u | paste -sd ' '
			# echo -n "${focused} ${occupied}"
		fi
	done
}

power(){
	echo -n "%{F${ifor}}%{B${lbac}}%{A:power:} %{F-}%{B-}%{A}"
}

timer(){
	echo -n "%{F${ifor}} %{F-}%{F${lfor}}%{B${lbac}}$(date +"%d %H:%M")%{F-}%{B-}"
}

volume(){
	g_vol=($(amixer sget Master | grep -Ew -m1 "([0-9].%)|([0-9]..%)|(off)|(on)" | awk '{print $5" "$6}' | tr -d "[]"))
	if [[ ${g_vol[1]} = "on" ]] ; then
		if [ ${g_vol[0]%\%} -lt 20 ] ; then
			echo -n "%{F${ifor}}%{A3:mute:}%{A4:vup:}%{A5:vdown:} %{F-}${g_vol[0]%\%}%{F-}%{A}%{A}%{A}"
		elif [ ${g_vol[0]%\%} -ge 20 ] && [ ${g_vol[0]%\%} -le 70 ] ; then
			echo -n "%{F${ifor}}%{A3:mute:}%{A4:vup:}%{A5:vdown:} %{F-}${g_vol[0]%\%}%{F-}%{A}%{A}%{A}"
		elif [ ${g_vol[0]%\%} -gt 70 ] && [ ${g_vol[0]%\%} -le 100 ] ; then
			echo -n "%{F${ifor}}%{A3:mute:}%{A4:vup:}%{A5:vdown:} %{F-}${g_vol[0]%\%}%{F-}%{A}%{A}%{A}"
		else
			echo -n "%{F${difo}}%{A3:mute:}%{A4:vup:}%{A5:vdown:} %{F-}${g_vol[0]%\%}%{F-}%{A}%{A}%{A}"
		fi
	else
		echo -n "%{F${uifo}}%{A3:mute:}%{A4:vup:}%{A:vdown:} %{F-}%{A}%{A}%{A}"
	fi
}

player(){
	player_status=$(playerctl --player=spotify status | grep -E "(Playing|Paused)")
	if [[ ${player_status} == "Playing" ]] ; then
		playing=`python $HOME/spotify.py`
		echo -n "%{F${vfor}}%{F-}%{F${lfor}} ${playing}%{F-}"
	else
		echo -n "%{F${vfor}}%{F-}"
	fi
}

main(){
	while :;
	do
		is_spotify=$(playerctl -l 2>/dev/null | grep -oi "spotify")
		if [[ -n ${is_spotify} ]] ; then
			echo -n "%{l}$(wmanager) %{c}$(player) %{r}$(volume) $(timer) $(power)"
		else
			echo -n "%{l}$(wmanager) %{r}$(volume) $(timer) $(power)"
			sleep 0.1s
		fi
	done
}

main  | lemonbar -p -g x27+0+0 -n "BAR"		\
	-f "${font0}" -o -1 -f "${font1}"		\
	-o -3 -f "${font2}" -o -2 -u 5 -a 20	\
	-U "${lfor}" -F "${lfor}" -B "${lbac}" |\
	while read line
	do
		case ${line} in
			power)
				echo POWER
				;;
			vup)
				pactl set-sink-volume @DEFAULT_SINK@ +2%
				;;
			vdown)
				pactl set-sink-volume @DEFAULT_SINK@ -2%
				;;
			mute)
				pactl set-sink-mute @DEFAULT_SINK@ toggle
				;;
			*)
				exit 1
				;;
		esac
	done

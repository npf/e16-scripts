#!/bin/bash

Z=${1:-1}
POS=$(eesh "warp ?")
POS_XY=${POS#*: }
POS_X=${POS_XY% *}
POS_Y=${POS_XY#* }

for L in $(eesh "wl all" | tr " " "_"); do
	T=${L:1:9}
	WIN_ID=${T##*_}
	T=${L:13:5}
	WIN_X=${T##*_}
	T=${L:19:5}
	WIN_Y=${T##*_}
	T=${L:25:4}
	WIN_W=${T##*_}
	T=${L:30:4}
	WIN_H=${T##*_}
	if [ $POS_X -ge $WIN_X -a $POS_X -le $((WIN_X + WIN_W)) -a $POS_Y -ge $WIN_Y -a $POS_Y -le $((WIN_Y + WIN_H)) ]; then
		echo $L
		WIN_ID_SEL[I++]=$WIN_ID
	fi
done
#eesh "wop ${WIN_ID_SEL[Z]} raise"
eesh "wop ${WIN_ID_SEL[Z]} focus"

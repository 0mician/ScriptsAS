#!/bin/bash

convertsecs() {
    h=$(($1/3600))
    m=$((($1/60)%60))
    s=$(($1%60))
    printf "02d:%02d:%02d\n" $h $m $s
}

mplayer -identify -frames 0 $1/*.mp3 2>/dev/null | grep -Po 'ID_LENGTH=\K(\d+)' | awk '{s+=$1} END {print s}' | convertsecs()

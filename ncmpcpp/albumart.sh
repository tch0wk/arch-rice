#!/bin/bash

MUSIC_DIR=/run/media/tch0wk/8308a428-9657-423c-90b1-e940b687b931/Music 
COVER=/tmp/cover.jpg

{
    album="$(mpc --format %album% current)"
    file="$(mpc --format %file% current)"
    album_dir="${file%/*}"
    [[ -z "$album_dir" ]] && exit 1
    album_dir="$MUSIC_DIR/$album_dir"

    covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f -iregex ".*/.*\(${album}\|cover\|front\).*[.]\(jpe?g\|png\|gif\|bmp\)" \; )"
    src="$(echo -n "$covers" | head -n1)"
    rm -f "$COVER"
    if [[ -n "$src" ]] ; then
        convert "$src" "$COVER"
        if [[ -f "$COVER" ]] ; then
            killall -q feh > /dev/null 2>&1
            feh -B black -q -N -Z -g 350x350+1550+25 -^ art "$COVER" > /dev/null 2>&1
        fi
    else
        killall -q feh > /dev/null 2>&1
        feh -B black -q -Z -g 350x350+1550+25 -^ art "/home/tch0wk/.ncmpcpp/error404.png" > /dev/null 2>&1
    fi
} &
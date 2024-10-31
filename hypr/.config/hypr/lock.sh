#!/bin/bash
grim -s 1.5 -l 0 -g "0,0 1920x1080" ~/.cache/screenlock.png
grim -s 1.5 -l 0 -g "1920,240 1920x1080" ~/.cache/screenlock2.png
convert ~/.cache/screenlock.png -scale 20% -blur 0x2 -resize 200% ~/.cache/screenlock.png
convert ~/.cache/screenlock2.png -scale 20% -blur 0x2 -resize 200% ~/.cache/screenlock2.png
hyprlock

if systemctl --user is-active hue | grep -q 'inactive'; then
    systemctl --user start hue
else
    systemctl --user stop hue
fi;

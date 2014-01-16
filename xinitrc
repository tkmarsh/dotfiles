


if cmd_exists xrdb ; then
    xrdb -merge ~/.Xresources
fi

if cmd_exists autocutsell ; then
    autocutsel -fork &
    autocutsel -selection PRIMARY -fork &
fi


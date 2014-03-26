
if command -v xrdb &>/dev/null ; then
    test "$DISPLAY" != "" && xrdb -merge ~/.Xresources
fi

if command -v autocutsel &>/dev/null ; then
    autocutsel -fork &
    autocutsel -selection PRIMARY -fork &
fi


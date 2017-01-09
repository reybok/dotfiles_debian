# set monitor layout
$init xrandr --output $outputPrimary --primary --mode 1920x1080 --pos 0x0 --rotate normal --output $outputSecondary --mode 1920x1080 --pos 1920x0 --rotate normal --output $outputProjector --off

# enable optical output for Xonar DGX sound card
#$init amixer -c 0 set IEC958,0 unmute

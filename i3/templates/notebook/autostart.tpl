# browser
$init i3-msg "workspace $workspace2 ; exec firefox -P browse"                                     
$init i3-msg "workspace $workspace9 ; exec firefox -P social ; workspace $workspace1"

# network tray
$init nm-applet

# bluetooth tray
$init blueman-applet

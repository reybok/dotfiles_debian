# htop on secondary monitor
$init i3-msg "workspace $workspaceSecondary1; exec \\"i3-sensible-terminal -e 'htop'\\" ; workspace $workspace1"

# browser
$init i3-msg "workspace $workspace2 ; exec firefox -P browse"
$init i3-msg "workspace $workspace9 ; exec firefox -P social ; workspace $workspace1"

# flux with tray
$init fluxgui

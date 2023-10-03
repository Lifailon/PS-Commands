function Get-AltTab {
$wshell = New-Object -ComObject wscript.shell
$wshell.SendKeys("%{Tab}")
sleep 120
Get-AltTab
}
Get-AltTab
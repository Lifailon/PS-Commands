function Get-AltTab {
(New-Object -ComObject wscript.shell).SendKeys("%{Tab}")
Start-Sleep $(Get-Random -Minimum 30 -Maximum 180)
Get-AltTab
}
Get-AltTab
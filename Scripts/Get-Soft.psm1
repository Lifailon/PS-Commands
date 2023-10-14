function Get-Soft {
<#
.SYNOPSIS
Remote and local view and delete software via WMI or Get-Package
.DESCRIPTION
Example:
Get-Soft localhost # default (or remote host)
Get-Soft localhost -wmi # use delete via WMI
Get-Soft localhost -package # use delete via Get-Package
.LINK
https://github.com/Lifailon
#>
Param (
$srv="localhost",
[switch]$wmi,
[switch]$package
)
if ($wmi) {
$soft_wmi = gwmi Win32_Product -ComputerName $srv | select Name,Version,Vendor,
InstallDate,InstallLocation,InstallSource | sort -Descending InstallDate |
Out-Gridview -Title "Software to server $srv" -PassThru
$soft_wmi_uninstall = $soft_wmi.Name
if ($soft_wmi_uninstall -ne $null) {
$wshell = New-Object -ComObject Wscript.Shell
$output = $wshell.Popup("Delete $soft_wmi_uninstall to server $srv ?",0,"Select action",4)
} else {
Write-Host Canceled
break
}
if ($output -eq "7") {
Write-Host Canceled
break
}
if ($output -eq "6") {
$uninstall = (gwmi Win32_Product -ComputerName $srv -Filter "Name = '$soft_wmi_uninstall'").Uninstall()
$outcode = $uninstall.ReturnValue
if ($outcode -eq 0) {
Write-Host -ForegroundColor Green "Successfully"
} else {
Write-Host -ForegroundColor Red "Error: $outcode"
}
}
}
if ($package) {
if ($srv -like "localhost") {
$soft_pack = Get-Package -ProviderName msi,Programs | Out-Gridview -Title "Software to server $srv" -PassThru
} else {
$soft_pack = icm $srv {Get-Package} | ? ProviderName -match "(Programs)|(msi)" | Out-Gridview -Title "Software to server $srv" -PassThru
}
if ($soft_pack -ne $null) {
$soft_name = $soft_pack.Name
$wshell = New-Object -ComObject Wscript.Shell
$output = $wshell.Popup("Delete $soft_name to server $srv ?",0,"Select action",4)
} else {
Write-Host Canceled
break
}
if ($output -eq "7") {
Write-Host Canceled
break
}
if ($output -eq "6") {
if ($srv -like "localhost") {
Get-Package -Name "$soft_name" | Uninstall-Package -Force -ForceBootstrap
} else {
$session = New-PSSession $srv
icm -Session $session {
Get-Package -Name "$using:soft_name" | Uninstall-Package -Force -ForceBootstrap
}
Remove-PSSession $session
}
}
}
}
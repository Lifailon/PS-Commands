function Get-Uptime {
<#
.SYNOPSIS
Remote and local check uptime via WMI
.DESCRIPTION
Example:
Get-Uptime localhost # default (or remote host)
.LINK
https://github.com/Lifailon
#>
Param (
$srv="localhost"
)
if ($srv -like "localhost") {
$boottime = Get-CimInstance Win32_OperatingSystem | select LastBootUpTime
} else {
$boottime = Get-CimInstance -ComputerName $srv Win32_OperatingSystem | select LastBootUpTime
}
$datetime = (Get-Date) - $boottime.LastBootUpTime
$global:uptime = [string]$datetime.Days+" days "+[string]$datetime.Hours+" hours "+
[string]$datetime.Minutes+" minutes"
$LastTime = [string]$boottime.LastBootUpTime.DateTime
$Collections = New-Object System.Collections.Generic.List[System.Object]
$Collections.Add([PSCustomObject]@{
Uptime = $uptime;
BootTime = $LastTime
})
$Collections
}
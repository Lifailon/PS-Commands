function Get-Size {
<#
.SYNOPSIS
Remote and local check use and all memory or space logical disk
For remote use applyed Invoke-Command via WinRM for memory and WMI for logical disk
.DESCRIPTION
Example:
Get-Size -disk localhost # default
Get-Size -memory localhost
.LINK
https://github.com/Lifailon
#>
Param (
$srv="localhost",
[switch]$memory,
[switch]$disk
)
if ($memory) {
if ($srv -like "localhost") {
$mem = Get-ComputerInfo
} else {
$mem = Invoke-Command -ComputerName $srv -ScriptBlock {Get-ComputerInfo}
}
$mem | select @{
Label="Size"; Expression={[string]($_.CsPhyicallyInstalledMemory/1mb)+" Gb"}},
@{Label="Free"; Expression={[string]([int]($_.OsFreePhysicalMemory/1kb))+" Mb"}}
} else {
gwmi Win32_logicalDisk -ComputerName $srv | select @{Label="Volume"; Expression={$_.DeviceID}},
@{Label="Size"; Expression={[string]([int]($_.Size/1Gb))+" Gb"}},
@{Label="Free"; Expression={[string]([int]($_.FreeSpace/1Gb))+" Gb"}},
@{Label="%Free"; Expression={[string]([int]($_.FreeSpace/$_.Size*100))+" %"}}
}
}
function Get-Update {
<#
.SYNOPSIS
Remote and local view and delete updates packages
Using WMI, dism Online and Invoke-Command via WinRM
.DESCRIPTION
Example:
Get-Update localhost # windows updates list (WMI) default
Get-Update localhost | Out-GridView
Get-Update localhost -delete # DISM packages list for delete updates
.LINK
https://github.com/Lifailon
#>
Param (
$srv="localhost",
[switch]$delete
)
if ($delete){
if ($srv -like "localhost") {
$dismName = dism /Online /Get-Packages /format:table | 
Out-Gridview -Title "DISM $Text_Packages $Text_ToServer $srv" –PassThru
if ($dismName -ne $null) {
$dismNamePars = $dismName -replace "\|.+"
$dismNamePars = $dismNamePars -replace "\s"
$wshell = New-Object -ComObject Wscript.Shell
$output = $wshell.Popup("Delete Update $dismNamePars to server $srv ?",0,"Select action",4)
if ($output -eq "6") {
dism /Online /Remove-Package /PackageName:$dismNamePars /quiet /norestart
}
}
} else {
$session = New-PSSession $srv
$dismName = icm -Session $session {dism /Online /Get-Packages /format:table} | 
Out-Gridview -Title "DISM $Text_Packages $Text_ToServer $srv" –PassThru
if ($dismName -ne $null) {
$dismNamePars = $dismName -replace "\|.+"
$dismNamePars = $dismNamePars -replace "\s"
$wshell = New-Object -ComObject Wscript.Shell
$output = $wshell.Popup("Delete Update $dismNamePars to server $srv ?",0,"Select action",4)
if ($output -eq "6") {
icm -Session $session {$dismNamePars = $using:dismNamePars}
icm -Session $session {dism /Online /Remove-Package /PackageName:$dismNamePars /quiet /norestart}
Remove-PSSession $session
}
}
}
} else {
Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $srv
}
}
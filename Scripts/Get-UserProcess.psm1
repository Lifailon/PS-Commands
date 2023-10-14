function Get-UserProcess {
<#
.SYNOPSIS
Remote and local view and stop processes
Using Get-Process and Invoke-Command via WinRM
.DESCRIPTION
Example:
Get-UserProcess localhost # default (Run as Administartor)
Get-UserProcess localhost -stop # stop process force
.LINK
https://github.com/Lifailon
#>
Param (
$srv="localhost",
[switch]$stop
)
if ($srv -like "localhost") {
$ps_out = ps -IncludeUserName | Sort-Object -Descending CPU | select ProcessName,Product,
ProductVersion,UserName,
@{Name="Processor Time sec"; Expression={[int]$_.CPU}},
@{Name="Processor Time min"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}},
@{Name="Memory WS"; Expression={[string]([int]($_.WS / 1024kb))+"MB"}},
@{Name="Memory PM"; Expression={[string]([int]($_.PM / 1024kb))+"MB"}},
@{Name="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}},
Path | Out-GridView -Title "Local user processes" -PassThru
if ($stop -and $ps_out) {
$ps_out | Stop-Process -Force
}
} else {
$ps_out = icm $srv {ps -IncludeUserName} | Sort-Object -Descending CPU | select ProcessName,Product,
ProductVersion,UserName,
@{Name="Processor Time sec"; Expression={[int]$_.CPU}},
@{Name="Processor Time min"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}},
@{Name="Memory WS"; Expression={[string]([int]($_.WS / 1024kb))+"MB"}},
@{Name="Memory PM"; Expression={[string]([int]($_.PM / 1024kb))+"MB"}},
@{Name="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}},
Path | Out-GridView -Title "Remote user processes to server $srv" -PassThru
if ($stop -and $ps_out) {
$session = New-PSSession $srv
icm -Session $session {Stop-Process -Name $using:ps_out.ProcessName -Force}
Remove-PSSession $session
}
}
}
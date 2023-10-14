function Get-EventTS {
<#
.SYNOPSIS
Parsing remote and local Windows Events Terminal Services
.DESCRIPTION
Example:
Get-EventTS localhost -connect # User authentication succeeded
Get-EventTS localhost -logon # Shell start notification received
Get-EventTS localhost -logoff # Session logoff succeeded
Get-EventTS localhost -disconnect # Session has been disconnected
Get-EventTS localhost -reconnect # Session reconnection succeeded
.LINK
https://github.com/Lifailon
#>
Param (
$srv="localhost",
[switch]$connect,
[switch]$logon,
[switch]$logoff,
[switch]$disconnect,
[switch]$reconnect
)
if ($connect) {
$RDPAuths = Get-WinEvent -ComputerName $srv -LogName "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational" `
-FilterXPath '<QueryList><Query Id="0"><Select>*[System[EventID=1149]]</Select></Query></QueryList>'
[xml[]]$xml = $RDPAuths | Foreach {$_.ToXml()}
$EventData = Foreach ($event in $xml.Event) {
New-Object PSObject -Property @{
"Connection Time" = (Get-Date ($event.System.TimeCreated.SystemTime) -Format 'yyyy-MM-dd hh:mm K')
"User Name" = $event.UserData.EventXML.Param1
"User Address" = $event.UserData.EventXML.Param3
"Event ID" = $event.System.EventID
}} 
$EventData | Out-Gridview -Title "TS-Remote-Connection-Manager to server $srv"
}

if (!($connect)) {
if ($logon) {
$FilterXPath = '<QueryList><Query Id="0"><Select>*[System[EventID=21]]</Select></Query></QueryList>'
}
if ($logoff) {
$FilterXPath = '<QueryList><Query Id="0"><Select>*[System[EventID=23]]</Select></Query></QueryList>'
}
if ($disconnect) {
$FilterXPath = '<QueryList><Query Id="0"><Select>*[System[EventID=24]]</Select></Query></QueryList>'
}
if ($reconnect) {
$FilterXPath = '<QueryList><Query Id="0"><Select>*[System[EventID=25]]</Select></Query></QueryList>'
}
$RDPAuths = Get-WinEvent -ComputerName $srv -LogName "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational" `
-FilterXPath $FilterXPath
[xml[]]$xml = $RDPAuths | Foreach {$_.ToXml()}
$EventData = Foreach ($event in $xml.Event) {
New-Object PSObject -Property @{
"Connection Time" = (Get-Date ($event.System.TimeCreated.SystemTime) -Format 'yyyy-MM-dd hh:mm K')
"User Name" = $event.UserData.EventXML.User
"User ID" = $event.UserData.EventXML.SessionID
"User Address" = $event.UserData.EventXML.Address
"Event ID" = $event.System.EventID
}}
$EventData | Out-Gridview -Title "TS-Local-Session-Manager to server $srv"
}
}
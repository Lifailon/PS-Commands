function Get-Broker {
<#
.SYNOPSIS
Add-on for module RemoteDesktop
Features:
Remote shadow connection to user via rdp
Disconnect user
Collection list and software
Host list and roles
.DESCRIPTION
Example:
Get-Broker localhost -r # remote shadow connection to user via rdp
Get-Broker localhost -d # disconnect user
Get-Broker localhost -c # collection list and software
Get-Broker localhost -h # host list and roles
.LINK
https://github.com/Lifailon
#>
Param (
$broker="localhost",
[switch]$r,
[switch]$d,
[switch]$c,
[switch]$h
)
if ($c) {
$Coll = Get-RDRemoteDesktop -ConnectionBroker $broker | Out-GridView -title "Broker-Connect" -PassThru
$CollName = $Coll.CollectionName
}
if ($CollName) {
Get-RDAvailableApp -ConnectionBroker $broker -CollectionName $CollName | Out-GridView -title "Software $CollName"
}
if ($h) {
Get-RDServer -ConnectionBroker $broker | Out-GridView -title "Broker-Connect"
}
if (($r) -or ($d)) {
$out = Get-RDUserSession -ConnectionBroker $broker | select hostserver, UserName, SessionState, CreateTime, DisconnectTime,
unifiedsessionid | Out-GridView -title "Broker-Connect" -PassThru | select hostserver, unifiedsessionid
}
if ($out) {
$srv = $out.HostServer
$id = $out.UnifiedSessionId
if ($r) {
mstsc /v:"$srv" /shadow:"$id" /control /noconsentprompt
}
if ($d) {
Disconnect-RDUser -HostServer $srv -UnifiedSessionID $id # -Force
}
}
}
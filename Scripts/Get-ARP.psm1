function Get-ARP {
<#
.SYNOPSIS
Module using arp.exe for created object powershell and search mac-address
For proxy use Invoke-Command via WinRM
.DESCRIPTION
Example:
Get-MACProxy # default localhost
Get-MACProxy -proxy dc-01 # remote get arp table
Get-MACProxy -proxy dc-01 -search server-01 # search mac-address server on proxy-server
.LINK
https://github.com/Lifailon
#>
Param (
$proxy,
$search
)
if (!$proxy) {
$arp = arp -a
}
if ($proxy) {
$arp = icm $proxy {arp -a}
}
$mac = $arp[3..260]
$mac = $mac -replace "^\s\s"
$mac = $mac -replace "\s{1,50}"," "
$mac_coll = New-Object System.Collections.Generic.List[System.Object]
foreach ($m in $mac) {
$smac = $m -split " "
$mac_coll.Add([PSCustomObject]@{
IP = $smac[0];
MAC = $smac[1];
Type = $smac[2]
})
}
if ($search) {
if ($search -NotMatch "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}") {
#$ns = nslookup $search
#$ns = $ns[-2]
#$global:ns = $ns -replace "Address:\s{1,10}"
$rdns = Resolve-DnsName $search -ErrorAction Ignore
$ns = $rdns.IPAddress
if ($ns -eq $null) {
return
}
} else {
$ns = $search
}
$mac_coll = $mac_coll | ? ip -Match $ns
}
$mac_coll
}
function Send-WOL {
param (
[Parameter(Mandatory = $True)]$Mac,
$IP,
[int]$Port = 9
)
$Mac = $Mac.replace(":", "-")
if (!$IP) {$IP = [System.Net.IPAddress]::Broadcast}
$SynchronizationChain = [byte[]](,0xFF * 6)
$ByteMac = $Mac.Split("-") | %{[byte]("0x" + $_)}
$Package = $SynchronizationChain + ($ByteMac * 16)
$UdpClient = New-Object System.Net.Sockets.UdpClient
$UdpClient.Connect($IP, $port)
$UdpClient.Send($Package, $Package.Length)
$UdpClient.Close()
}

# Send-WOL -Mac "D8-BB-C1-70-A3-4E"
# Send-WOL -Mac "D8-BB-C1-70-A3-4E" -IP 192.168.3.100
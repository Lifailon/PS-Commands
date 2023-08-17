function Test-NetUDPConnection {
param(
[string]$ComputerName = "127.0.0.1",
[int32]$PortServer    = 5201,
[int32]$PortClient    = 5211,
$Message
)
begin {
$UdpObject = New-Object system.Net.Sockets.Udpclient($PortClient)
$UdpObject.Connect($ComputerName, $PortServer)
}
process {
$ASCIIEncoding = New-Object System.Text.ASCIIEncoding
if (!$Message) {$Message = Get-Date -UFormat "%Y-%m-%d %T"}
$Bytes = $ASCIIEncoding.GetBytes($Message)
[void]$UdpObject.Send($Bytes, $Bytes.length)
}
end {
$UdpObject.Close()
}
}

# Test-NetUDPConnection -ComputerName 192.168.3.100 -PortServer 5201
# Test-NetUDPConnection -ComputerName 192.168.3.100 -PortServer 514 -Message "<30>May 31 00:00:00 HostName multipathd[784]: Test message"
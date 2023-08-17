function Start-UDPServer {
param(
$Port = 5201
)
$RemoteComputer = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
do {
$UdpObject = New-Object System.Net.Sockets.UdpClient($Port)
$ReceiveBytes = $UdpObject.Receive([ref]$RemoteComputer)
$UdpObject.Close()
$ASCIIEncoding = New-Object System.Text.ASCIIEncoding
[string]$ReturnString = $ASCIIEncoding.GetString($ReceiveBytes)
[PSCustomObject]@{
LocalDateTime = $(Get-Date -UFormat "%Y-%m-%d %T")
ClientIP      = $RemoteComputer.address.ToString()
ClientPort    = $RemoteComputer.Port.ToString()
Message       = $ReturnString
}
} while (1)
}

# Start-UDPServer -Port 5201
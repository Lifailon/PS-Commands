function Start-TCPServer {
    param(
    $Port = 5201
    )
    do {
    $TcpObject = New-Object System.Net.Sockets.TcpListener($port)
    $ReceiveBytes = $TcpObject.Start()
    $ReceiveBytes = $TcpObject.AcceptTcpClient()
    $TcpObject.Stop()
    $ReceiveBytes.Client.RemoteEndPoint | select Address,Port
    } while (1)
}
    
# Start-TCPServer -Port 5201
# Test-NetConnection -ComputerName 192.168.3.99 -Port 5201
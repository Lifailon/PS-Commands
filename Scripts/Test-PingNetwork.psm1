function Test-PingNetwork {
param (
    [Parameter(Mandatory,ValueFromPipeline)][string[]]$Network,
    [ValidateRange(100,10000)][int]$Timeout = 100
)
$ping = New-Object System.Net.NetworkInformation.Ping
$Network  = $Network -replace "0$"
$net = @()
foreach ($r in @(1..254)) {
    $net += "$network$r"
}
foreach ($n in $net) {
    $ping.Send($n, $timeout) | select @{Name="Address"; Expression={$n -replace ".+\."}}, Status
}
}

# Test-PingNetwork -Network 192.168.3.0
# Test-PingNetwork -Network 192.168.3.0 -Timeout 1000
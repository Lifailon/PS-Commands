function Start-PingRSJob ($Network) {
$RNetwork = $Network -replace "\.\d{1,3}$","."
foreach ($4 in 1..254) {
$ip = $RNetwork+$4
(Start-RSJob {"$using:ip : "+(ping -n 1 -w 50 $using:ip)[2]}) | Out-Null
}
$ping_out = Get-RSJob | Receive-RSJob
$ping_out
Get-RSJob | Remove-RSJob
}

# Start-PingRSJob -Network 192.168.3.0
# (Measure-Command {Start-PingRSJob -Network 192.168.3.0}).TotalSeconds # 10 Seconds
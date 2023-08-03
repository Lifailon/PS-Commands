$url = "https://cdn.zabbix.com/zabbix/binaries/stable/6.4/6.4.5/zabbix_agent2-6.4.5-windows-amd64-static.zip"
$path = "$home\Downloads\zabbix-agent2-6.4.5.zip"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($url, $path)
Expand-Archive $path -DestinationPath "C:\zabbix-agent2-6.4.5\"
Remove-Item $path
New-NetFirewallRule -DisplayName "Zabbix-Agent" -Profile Any -Direction Inbound -Action Allow -Protocol TCP -LocalPort 10050,10051

$Zabbix_Server = "192.168.3.102"
$conf = "C:\zabbix-agent2-6.4.5\conf\zabbix_agent2.conf"
$cat = cat $conf
$rep = $cat -replace "Server=.+","Server=$Zabbix_Server"
$rep | Select-String Server=
$rep > $conf

$exe = "C:\zabbix-agent2-6.4.5\bin\zabbix_agent2.exe"
.$exe --config $conf --install
Get-Service *Zabbix*Agent* | Start-Service
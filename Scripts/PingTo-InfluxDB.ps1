while ($true) {
	$tz = (Get-TimeZone).BaseUtcOffset.TotalMinutes
	$unixtime  = (New-TimeSpan -Start (Get-Date "01/01/1970") -End ((Get-Date).AddMinutes(-$tz))).TotalSeconds # -3h UTC
	$timestamp = ([string]$unixtime -replace "\..+") + "000000000"
	$tnc = tnc 8.8.8.8
	$Status = $tnc.PingSucceeded
	$RTime = $tnc.PingReplyDetails.RoundtripTime
	Invoke-RestMethod -Method POST -Uri "http://192.168.3.104:8086/write?db=powershell" -Body "ping,host=$(hostname) status=$status,rtime=$RTime $timestamp"
	sleep 1
}
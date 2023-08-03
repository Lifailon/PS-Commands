function ConvertTo-Encoding ([string]$From, [string]$To) {
    Begin {
        $encFrom = [System.Text.Encoding]::GetEncoding($from)
        $encTo = [System.Text.Encoding]::GetEncoding($to)
    }
    Process {
        $bytes = $encTo.GetBytes($_)
        $bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes)
        $encTo.GetString($bytes)
    }
}

$localization = (Get-Culture).LCID # текущая локализация
if ($localization -eq 1049) {
	$performance = "\\$(hostname)\Процессор(_Total)\% загруженности процессора" | ConvertTo-Encoding UTF-8 windows-1251
} else {
	$performance = "\Processor(_Total)\% Processor Time"
}

$tz = (Get-TimeZone).BaseUtcOffset.TotalMinutes
while ($true) {
	$unixtime  = (New-TimeSpan -Start (Get-Date "01/01/1970") -End ((Get-Date).AddMinutes(-$tz))).TotalSeconds
	$timestamp = ([string]$unixtime -replace "\..+") + "000000000"
	[double]$value = (Get-Counter $performance).CounterSamples.CookedValue.ToString("0.00").replace(",",".")
	Invoke-RestMethod -Method POST -Uri "http://192.168.3.104:8086/write?db=powershell" -Body "performance,host=$(hostname),counter=CPU value=$value $timestamp"
	sleep 5
}
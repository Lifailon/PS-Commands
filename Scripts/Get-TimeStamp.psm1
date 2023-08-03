function Get-TImeStamp {
    $tz = (Get-TimeZone).BaseUtcOffset.TotalMinutes
    $unixtime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End ((Get-Date).AddMinutes(-$tz))).TotalSeconds # -3h UTC
    ([string]$unixtime -replace "\..+") + "000000000"
}
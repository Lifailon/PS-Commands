function ConvertTo-UnixTime {
    param (
        $date = $(Get-Date)
    )
    $tz = (Get-TimeZone).BaseUtcOffset.TotalMinutes
    $sec = (New-TimeSpan -Start (Get-Date "01/01/1970") -End ((Get-Date).AddMinutes(-$tz))).TotalSeconds # -3h UTC
    [int]$sec
}
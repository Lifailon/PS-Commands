function Get-FromTelegram {
param (
    $token = "687...:AAF...",
    [switch]$last,
    [switch]$date
)
$endpoint = "getUpdates"
$url      = "https://api.telegram.org/bot$token/$endpoint"
$result   = Invoke-RestMethod -Uri $url
if ($date) {
$Collections = New-Object System.Collections.Generic.List[System.Object]
foreach ($r in $($result.result)) {
    $EpochTime = [DateTime]"1/1/1970"
    $TimeZone = Get-TimeZone
    $UTCTime = $EpochTime.AddSeconds($r.message.date)
    $d = $UTCTime.AddMinutes($TimeZone.BaseUtcOffset.TotalMinutes)
	#$d
    $Collections.Add([PSCustomObject]@{
        Message = $r.message.text;
        Date    = $d
    })
}
$Collections
} else {
if ($last) {
    $result.result.message.text[-1]
} else {
    $result.result.message.text
}
}
}
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

function Send-ToTelegram {
param (
[Parameter(Mandatory = $True)]$Text,
$token    = "687...:AAF...",
$chat     = "125468108"
)
$endpoint = "sendMessage"
$url      = "https://api.telegram.org/bot$token/$endpoint"
$Body = @{
chat_id = $Chat
text    = $Text
}
Invoke-RestMethod -Uri $url -Body $Body
}

$LastDate = (Get-FromTelegram -date)[-1].Date
while ($true) {
    $LastMessage  = (Get-FromTelegram -date)[-1]
    Start-Sleep 1
    $LastDateTest = $LastMessage.Date
    if (($LastMessage.Message -match "/Service") -and ($LastDate -ne $LastDateTest)) {
        $ServiceName = $($LastMessage.Message -split " ")[-1]
        $Result = $(Get-Service $ServiceName -ErrorAction Ignore).Status
        if ($Result) {
            Send-ToTelegram -Text $Result
        } else {
            Send-ToTelegram -Text "Service not found"
        }
        $LastDate = $LastDateTest
    }
}
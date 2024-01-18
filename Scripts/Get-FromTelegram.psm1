function Get-FromTelegram {
    param (
        $Token = "687...:AAF...",
        [switch]$Date,
        [switch]$Last,
        [switch]$ChatID
    )
    $endpoint = "getUpdates"
    $url      = "https://api.telegram.org/bot$Token/$endpoint"
    $result   = Invoke-RestMethod -Uri $url
    if ($Date) {
        $Collections = New-Object System.Collections.Generic.List[System.Object]
        foreach ($r in $($result.result)) {
            $EpochTime = [DateTime]"1/1/1970"
            $TimeZone = Get-TimeZone
            $UTCTime = $EpochTime.AddSeconds($r.message.date)
            $d = $UTCTime.AddMinutes($TimeZone.BaseUtcOffset.TotalMinutes)
            $Collections.Add([PSCustomObject]@{
                Message = $r.message.text;
                Date    = $d
            })
        }
        $Collections
    }
    else {
        if ($Last) {
            $result.result.message.text[-1]
        }
        elseif ($ChatID) {
            $Collections = New-Object System.Collections.Generic.List[System.Object]
            foreach ($r in $($result.result)) {
                $Collections.Add([PSCustomObject]@{
                    Message = $r.message.text;
                    UserName = $r.message.chat.username;
                    ChatID = $r.message.chat.id;
                    ChatType = $r.message.chat.type
                })
            }
            $Collections
        }
        else {
            $result.result.message.text
        }
    }
}

# Get-FromTelegram
# Get-FromTelegram -Last
# Get-FromTelegram -Date
# Get-FromTelegram -ChatID
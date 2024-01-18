function Send-ToTelegram {
param (
    [Parameter(Mandatory = $True)]$Text,
    $Token    = "687...:AAF...",
    $Chat     = "125468108",
    $Keyboard
)
    $endpoint = "sendMessage"
    $url      = "https://api.telegram.org/bot$Token/$endpoint"
    $Body = @{
        chat_id = $Chat
        text    = $Text
    }
    if ($keyboard -ne $null) {
        $Body += @{reply_markup = $keyboard}
    }
    Invoke-RestMethod -Uri $url -Body $Body
}
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
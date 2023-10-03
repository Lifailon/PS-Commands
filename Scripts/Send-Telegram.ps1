function Send-Telegram  {
param (
[Parameter(Mandatory = $True)]$Text
)$token_bot = "5517149522:AAFop4_darMpTT7VgLpY2hjkDkkV1dzmGNM"
$id_chat = "-609779646"
$payload = @{
"chat_id" = $id_chat
"text" = $Text
"parse_mode" = "html"
}
Invoke-RestMethod -Uri ("https://api.telegram.org/bot{0}/sendMessage" -f $token_bot) -Method Post -ContentType "application/json;charset=utf-8" -Body (
ConvertTo-Json -Compress -InputObject $payload
)
}

Send-Telegram -Text Test
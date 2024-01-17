function Send-DiscordChannel {
    param (
        $Token,
        $Channel,
        $Text
    )
    $URL = "https://discordapp.com/api/channels/$Channel/messages"
    $Body = @{
        content = $Text
    } | ConvertTo-Json
    curl -s $URL -X POST -H "Authorization: Bot $Token" -H "Content-Type: application/json" -d $Body
}

# Send-DiscordChannel -Token $DISCORD_TOKEN -Channel $DISCORD_CHANNEL_ID -Text "Test message from PowerShell"
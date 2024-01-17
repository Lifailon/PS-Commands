function Read-DiscordMessages {
    param (
        $Token,
        $Channel,
        [switch]$Last
    )
    $URL = "https://discordapp.com/api/channels/$Channel/messages"
    $Output = curl -s -X GET $URL -H "Authorization: Bot $Token" -H "Content-Type: application/json" | ConvertFrom-Json
    if ($last) {
        $Output[0].content
    }
    else {
        $Output | Select-Object @{Name="Time"; Expression={$_.timestamp}},
        @{Name="Message"; Expression={$_.content}},
        @{Name="UserName"; Expression={$_.author.username}}
    }
}

# Read-DiscordMessages -Token $DISCORD_TOKEN -Channel $DISCORD_CHANNEL_ID
# Read-DiscordMessages -Token $DISCORD_TOKEN -Channel $DISCORD_CHANNEL_ID -Last
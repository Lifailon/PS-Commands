# Module: https://github.com/Lifailon/Console-Translate
function Get-GoogleTranslate {
    param (
        [Parameter(Mandatory,ValueFromPipeline)][string[]]$Text,
        [string]$LanguageTarget = "RU",
        [string]$LanguageSource,
        [string]$Key = "AIzaSyBOti4mM-6x9WDnZIjIeyEU21OpBXqWBgw" # Public API Key for Google Translate
    )
    $url = "https://translation.googleapis.com/language/translate/v2?key=${key}"
    $Header = @{
        "Content-Type" = "application/json"
    }
    $Body = @{
        "q" = "$Text"
        "target" = "$LanguageTarget"
        "source" = "$LanguageSource"
    } | ConvertTo-Json
    $WebClient = New-Object System.Net.WebClient
    foreach ($key in $Header.Keys) {
        $WebClient.Headers.Add($key, $Header[$key])
    }
    $Response = $WebClient.UploadString($url, "POST", $Body) | ConvertFrom-Json
    $Response.data.translations.translatedText
}

Get-GoogleTranslate -Text "Привет" -LanguageTarget en
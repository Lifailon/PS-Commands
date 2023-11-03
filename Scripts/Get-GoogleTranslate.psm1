function Get-Translate {
    param (
        $data,
        $key = "KEY" # Get https://cloud.google.com/translate/docs/reference/rest
    )
    $url = "https://translation.googleapis.com/language/translate/v2?key=$key"
    $body = @{
        q = $data
        target = "ru"
        source = "en"
    } | ConvertTo-Json
    try {
        $response = Invoke-RestMethod -Uri $url -Method POST -ContentType "application/json" -Body $body
        $translation = $response.data.translations[0].translatedText
        return $translation
    } catch {
        Write-Output "Error: $($_.Exception.Message)"
    }
}

# Get-Translate -data "What is your name"
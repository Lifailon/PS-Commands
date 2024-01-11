function Get-GigaChat {
    param (
        [Parameter(Mandatory,ValueFromPipeline)][string]$Content,
        [Parameter(Mandatory)][string]$Cred_Base64,
        [ValidateRange(0.1,2)][float]$temperature = 0.9,
        [ValidateRange(1,4)][int64]$n = 1,
        [int64]$max_tokens = 512,
        [boolean]$stream = $False,
        [string]$model = "GigaChat:latest"
    )
    $UUID = [System.Guid]::NewGuid()
    $url = "https://ngw.devices.sberbank.ru:9443/api/v2/oauth"
    $headers = @{
        "Authorization" = "Basic $Cred_Base64"
        "RqUID" = "$UUID"
        "Content-Type" = "application/x-www-form-urlencoded"
    }
    $body = @{
        scope = "GIGACHAT_API_PERS"
    }
    $GIGA_TOKEN = $(Invoke-RestMethod -Uri $url -Method POST -Headers $headers -Body $body).access_token
    $role = "user"
    $url = "https://gigachat.devices.sberbank.ru/api/v1/chat/completions"
    $headers = @{
        "Authorization" = "Bearer $GIGA_TOKEN"
        "Content-Type" = "application/json"
    }
    $body = @{
        model = $model
        messages = @(
            @{
                role = $role
                content = $content
            }
        )
        temperature = $temperature
        n = $n
        max_tokens = $max_tokens
        stream = $stream
    } | ConvertTo-Json
    $Request = Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body $body
    $Request.choices.message.content
}

# Сгенерировать вторизационные данные (действует 30 минут): https://developers.sber.ru/studio
#$Cred = "N2U2ZDJmOWYtODI1ZS00OWI3LTk4ZjQtNjJmYmI3NTA2NDI3OmExY2FiN2U3LTBhZjgtNDMzMi1iODAwLTE3Y2I5OTQ1MWViNg=="
#Get-GigaChat -Cred_Base64 $Cred -Content "Напиши скрипт на языке PowerShell для создания UUID"
#Get-GigaChat -Cred_Base64 $Cred -Content "Напиши скрипт на языке Bash для создания UUID"
#Get-GigaChat -Cred_Base64 $Cred -Content "Выполняй роль калькулятора. Посчитай сумму двух чисел"
#Get-GigaChat -Cred_Base64 $Cred -Content "Расскажи, что такое платформа .NET" -n 2
Start-PodeServer {
    Add-PodeEndpoint -Address localhost -Port "8080" -Protocol "HTTP"
    ### Get info endpoints
    Add-PodeRoute -Path "/" -Method "GET" -ScriptBlock {
        Write-PodeJsonResponse -Value @{
        "service"="/api/service";
        "process"="/api/process"
        }
    }
    ### GET
    Add-PodeRoute -Path "/api/service" -Method "GET" -ScriptBlock {
        Write-PodeJsonResponse -Value $(
            Get-Service | Select-Object Name,@{
                Name="Status"; Expression={[string]$_.Status}
            },@{
                Name="StartType"; Expression={[string]$_.StartType}
            } | ConvertTo-Json
        )
    }
    Add-PodeRoute -Path "/api/process" -Method "GET" -ScriptBlock {
        Write-PodeJsonResponse -Value $(
            Get-Process | Sort-Object -Descending CPU | Select-Object -First 15 ProcessName,
            @{Name="ProcessorTime"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}},
            @{Name="Memory"; Expression={[string]([int]($_.WS / 1024kb))+"MB"}},
            @{Label="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}}
        )
    }
    Add-PodeRoute -Path "/api/process-html" -Method "GET" -ScriptBlock {
        Write-PodeHtmlResponse -Value (
            Get-Process | Sort-Object -Descending CPU | Select-Object -First 15 ProcessName,
            @{Name="ProcessorTime"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}},
            @{Name="Memory"; Expression={[string]([int]($_.WS / 1024kb))+"MB"}},
            @{Label="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}} # Auto ConvertTo-Html
        )
    }
    ### POST
    Add-PodeRoute -Path "/api/service" -Method "POST" -ScriptBlock {
        # https://pode.readthedocs.io/en/latest/Tutorials/WebEvent/
        # $WebEvent | Out-Default
        $Value = $WebEvent.Data["ServiceName"]
        $Status = (Get-Service -Name $Value).Status
        Write-PodeJsonResponse -Value @{
            "Name"="$Value";
            "Status"="$Status";
        }
    }
}

# irm http://localhost:8080/api/service -Method Get
# irm http://localhost:8080/api/process -Method Get
# irm http://localhost:8080/api/process-html -Method Get
# irm http://localhost:8080/api/service -Method Post -Body @{"ServiceName" = "AnyDesk"}
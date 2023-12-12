function Get-ProcessDescription {
    param (
        $ProcessName
    )
    if ($null -eq $ProcessName) {
        $GetProcess = Get-Process -ErrorAction Ignore
    }
    else {
        $GetProcess = Get-Process -Name $ProcessName -ErrorAction Ignore
    }
    if ($null -ne $GetProcess) {
        $GetProcess | Sort-Object -Descending CPU | Select-Object ProcessName,
        @{Name="TotalProcTime"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}},
        @{Name="UserProcTime"; Expression={$_.UserProcessorTime -replace "\.\d+$"}},
        @{Name="PrivilegedProcTime"; Expression={$_.PrivilegedProcessorTime -replace "\.\d+$"}},
        @{Name="WorkingSet"; Expression={[string]([int]($_.WS / 1024kb))+" MB"}},
        @{Name="PeakWorkingSet"; Expression={[string]([int]($_.PeakWorkingSet / 1024kb))+" MB"}},
        @{Name="PageMemory"; Expression={[string]([int]($_.PM / 1024kb))+" MB"}},
        @{Name="VirtualMemory"; Expression={[string]([int]($_.VM / 1024kb))+" MB"}},
        @{Name="PrivateMemory"; Expression={[string]([int]($_.PrivateMemorySize / 1024kb))+" MB"}},
        @{Name="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}},
        @{Name="Threads"; Expression={$_.Threads.Count}},
        Handles,Path
    }
}

# Get-ProcessDescription *
# Get-ProcessDescription *torrent*
# Get-ProcessDescription qbittorrent
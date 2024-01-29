function Get-Event {
    param (
        [string]$LogName,
        [switch]$List
    )
    if ($List) {
        Get-WinEvent -ListLog * | Where-Object RecordCount -gt 0 | 
        Select-Object RecordCount,
        @{Name="LastWriteTime"; Expression={Get-Date -Date $($_.LastWriteTime) -UFormat "%d.%m.%Y %T"}},
        @{Name="FileSize"; Expression={($_.FileSize / 1024kb).ToString("0.00 Mb")}},
        LogIsolation,
        LogType,
        LogName | Sort-Object LogIsolation
    }
    else {
        Get-WinEvent -LogName $LogName | Select-Object @{Name="TimeCreated"; Expression={Get-Date -Date $($_.TimeCreated) -UFormat "%d.%m.%Y %T"}},
        LevelDisplayName,
        Level,
        Message
    }
}
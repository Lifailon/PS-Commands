function Get-WinUpdate {
    Get-CimInstance Win32_QuickFixEngineering | Sort-Object -Descending InstalledOn | Select-Object HotFixID,
    @{
        name="InstallDate";expression={
            $_.InstalledOn.ToString("dd.MM.yyyy")
        }
    },
    Description,
    InstalledBy
}
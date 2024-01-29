function Get-WinUpdate {
    Get-CimInstance Win32_QuickFixEngineering | Select-Object HotFixID,
    Description,
    InstalledBy,
    InstalledOn
    # wusa /uninstall /kb:123456
    # dism /Online /Get-Packages /format:table
    # dism /Online /Remove-Package /PackageName:Package_for_DotNetRollup_481~31bf3856ad364e35~amd64~~10.0.9206.1 /quiet /norestart
}
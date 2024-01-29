function Get-Software {
    Get-CimInstance Win32_Product | Select-Object Name,
    Version,
    Vendor,
    InstallDate,
    InstallLocation,
    InstallSource
}
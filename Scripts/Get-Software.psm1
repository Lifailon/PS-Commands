function Get-Software {
    Get-CimInstance Win32_Product  | Sort-Object -Descending  InstallDate | Select-Object Name,
    Version,
    Vendor,
    @{
        name="InstallDate";expression={
            [datetime]::ParseExact($_.InstallDate, "yyyyMMdd", $null).ToString("dd.MM.yyyy")
        }
    },
    InstallLocation,
    InstallSource,
    PackageName,
    LocalPackage
}
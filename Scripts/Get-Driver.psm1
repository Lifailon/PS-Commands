function Get-Driver {
    Get-CimInstance -Class Win32_PnPSignedDriver | Select-Object DriverProviderName,
    FriendlyName,
    Description,
    DriverVersion,
    DriverDate
}
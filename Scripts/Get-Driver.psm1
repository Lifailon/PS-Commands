function Get-Driver {
    Get-CimInstance -Class Win32_PnPSignedDriver |
    Select-Object DriverProviderName, FriendlyName, Description, DriverVersion, DriverDate |
    Group-Object DriverProviderName, FriendlyName, Description, DriverVersion, DriverDate |
    ForEach-Object {$_.Group[0]}
}
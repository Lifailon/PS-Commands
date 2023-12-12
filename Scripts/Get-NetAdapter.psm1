function Get-NetAdapter {
    Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true | Select-Object Description,
    DHCPEnabled,DHCPLeaseObtained,DHCPLeaseExpires,DHCPServer,
    @{Label="IPAddress"; Expression={[string]($_.IPAddress)}},
    @{Label="DefaultIPGateway"; Expression={[string]($_.DefaultIPGateway)}},
    @{Label="IPSubnet"; Expression={[string]($_.IPSubnet)}},
    MACAddress
}
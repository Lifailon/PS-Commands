function Get-NetIpConfig {
    Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true |
    Select-Object Description,
    @{Label="IPAddress"; Expression={[string]($_.IPAddress)}},
    @{Label="GatewayDefault"; Expression={[string]($_.DefaultIPGateway)}},
    @{Label="Subnet"; Expression={[string]($_.IPSubnet)}},
    @{Label="DNSServer"; Expression={[string]($_.DNSServerSearchOrder)}},
    MACAddress,
    DHCPEnabled,
    DHCPServer,
    DHCPLeaseObtained,
    DHCPLeaseExpires
}
function Get-NetStat {
    Get-NetTCPConnection -State Established,Listen | Sort-Object -Descending State |
    Select-Object @{name="ProcessName";expression={(Get-Process -Id $_.OwningProcess).ProcessName}},
    LocalAddress,
    LocalPort,
    RemotePort,
    @{name="RemoteHostName";expression={((nslookup $_.RemoteAddress)[3]) -replace ".+:\s+"}},
    RemoteAddress,
    State,
    CreationTime,
    @{Name="RunTime"; Expression={((Get-Date) - $_.CreationTime) -replace "\.\d+$"}},
    @{name="ProcessPath";expression={(Get-Process -Id $_.OwningProcess).Path}}
}
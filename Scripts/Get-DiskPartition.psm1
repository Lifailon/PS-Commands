function Get-DiskPartition {
    $PhysicalDisk = Get-CimInstance -Namespace root/Microsoft/Windows/Storage -ClassName MSFT_PhysicalDisk
    $Partition = Get-CimInstance -Namespace root/Microsoft/Windows/Storage -ClassName MSFT_Partition | 
    Select-Object @{Label="Disk"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DiskNumber | Select-Object -ExpandProperty FriendlyName}},
    IsBoot,
    IsSystem,
    IsHidden,
    IsReadOnly,
    IsShadowCopy,
    @{Label="OffSet"; Expression={($_.OffSet/1Gb).ToString("0.00 Gb")}},
    @{Label="Size"; Expression={($_.Size/1Gb).ToString("0.00 Gb")}}
    $Partition | Sort-Object Disk,OffSet
}
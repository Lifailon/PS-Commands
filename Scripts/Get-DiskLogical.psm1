function Get-DiskLogical {
    $LogicalDisk = Get-CimInstance Win32_logicalDisk | Where-Object {$null -ne $_.Size} |
    Select-Object @{Label="Value"; Expression={$_.DeviceID}},
    @{Label="AllSize"; Expression={([int]($_.Size/1Gb))}},
    @{Label="FreeSize"; Expression={([int]($_.FreeSpace/1Gb))}},
    @{Label="Free%"; Expression={
    [string]([int]($_.FreeSpace/$_.Size*100))+" %"}},
    FileSystem,
    VolumeName
    $CollectionLD = New-Object System.Collections.Generic.List[System.Object]
    $LogicalDisk | ForEach-Object {
        $CollectionLD.Add([PSCustomObject]@{
            Logical_Disk = $_.Value
            FileSystem = $_.FileSystem
            VolumeName = $_.VolumeName
            AllSize    = [string]$_.AllSize+" Gb"
            FreeSize   = [string]$_.FreeSize+" Gb"
            Free       = $_."Free%"
        })
    }
    $CollectionLD
}
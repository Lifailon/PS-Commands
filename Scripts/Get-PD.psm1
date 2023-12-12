function Get-PD {
    $PhysicalDisk = Get-CimInstance Win32_DiskDrive | Select-Object Model,
    @{Label="Size"; Expression={[int]($_.Size/1Gb)}},Partitions,InterfaceType
    $CollectionPD = New-Object System.Collections.Generic.List[System.Object]
    $PhysicalDisk | ForEach-Object {
        $CollectionPD.Add([PSCustomObject]@{
            Model          = $_.Model
            Size           = [string]$_.Size+" Gb"
            PartitionCount = $_.Partitions
            Interface      = $_.InterfaceType
        })
    }
    $CollectionPD
}
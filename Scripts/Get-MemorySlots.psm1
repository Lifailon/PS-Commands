function Get-MemorySlots {
    $Memory = Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer,PartNumber,
    ConfiguredClockSpeed,@{Label="Memory"; Expression={[string]($_.Capacity/1Mb)}},
    Tag,DeviceLocator,BankLabel
    $CollectionMemory = New-Object System.Collections.Generic.List[System.Object]
    $Memory | ForEach-Object {
        $CollectionMemory.Add([PSCustomObject]@{
            Tag     = $_.Tag
            Model   = [String]$_.ConfiguredClockSpeed+" Mhz "+$_.Manufacturer+" "+$_.PartNumber
            Size    = [string]($_.Memory)+" Mb"
            Device  = $_.DeviceLocator
            Bank    = $_.BankLabel
        })
    }
    $CollectionMemory
}
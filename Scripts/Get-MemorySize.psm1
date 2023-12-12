function Get-MemorySize {
    $Memory           = Get-CimInstance Win32_OperatingSystem
    $MemUse           = $Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory
    $GetProcess       = Get-Process
    $ws               = ((($GetProcess).WorkingSet | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
    $pm               = ((($GetProcess).PM | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
    $CollectionMemory = New-Object System.Collections.Generic.List[System.Object]
    $CollectionMemory.Add([PSCustomObject]@{
        MemoryAll  = ($memory.TotalVisibleMemorySize/1mb).ToString("0.00 GB")
        MemoryUse  = ($MemUse/1mb).ToString("0.00 GB")
        WorkingSet = $ws
        PageMemory = $pm
    })
    $CollectionMemory
}
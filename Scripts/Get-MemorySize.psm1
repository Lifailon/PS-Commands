function Get-MemorySize {
    $Memory           = Get-CimInstance Win32_OperatingSystem
    $MemUse           = $Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory
    $MemUserProc      = ($MemUse / $Memory.TotalVisibleMemorySize) * 100
    $GetProcess       = Get-Process
    $ws               = ((($GetProcess).WorkingSet | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
    $pm               = ((($GetProcess).PM | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
    $CollectionMemory = New-Object System.Collections.Generic.List[System.Object]
    $CollectionMemory.Add([PSCustomObject]@{
        MemoryAll     = ($memory.TotalVisibleMemorySize/1mb).ToString("0.00 GB")
        MemoryUse     = ($MemUse/1mb).ToString("0.00 GB")
        MemoryUseProc = [string]([int]$MemUserProc)+" %"
        WorkingSet    = $ws
        PageMemory    = $pm
    })
    $CollectionMemory
}
function Get-MemorySize {
    $Memory           = Get-CimInstance Win32_OperatingSystem
    $MemUse           = $Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory
    $MemUserProc      = ($MemUse / $Memory.TotalVisibleMemorySize) * 100
    $PageSize         = $Memory.TotalVirtualMemorySize - $Memory.TotalVisibleMemorySize
    $PageFree         = $Memory.FreeVirtualMemory - $Memory.FreePhysicalMemory
    $PageUse          = $PageSize - $PageFree
    $PageUseProc      = ($PageUse / $PageSize) * 100
    $PageFile         = Get-CimInstance Win32_PageFileUsage
    $PagePath         = [string]$($PageFile).Description
    $MemVirtUse       = $Memory.TotalVirtualMemorySize - $Memory.FreeVirtualMemory
    $MemVirtUseProc   = ($MemVirtUse / $Memory.TotalVirtualMemorySize) * 100
    $GetProcess       = Get-Process
    $ws               = ((($GetProcess).WorkingSet | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
    $pm               = ((($GetProcess).PM | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
    $CollectionMemory = New-Object System.Collections.Generic.List[System.Object]
    $CollectionMemory.Add([PSCustomObject]@{
        MemoryAll         = ($memory.TotalVisibleMemorySize/1mb).ToString("0.00 GB")
        MemoryUse         = ($MemUse/1mb).ToString("0.00 GB")
        MemoryUseProc     = [string]([int]$MemUserProc)+" %"
        PageSize          = ($PageSize/1mb).ToString("0.00 GB")
        PageUse           = ($PageUse/1mb).ToString("0.00 GB")
        PageUseProc       = [string]([int]$PageUseProc)+" %"
        PagePath          = $PagePath
        MemoryVirtAll     = ($memory.TotalVirtualMemorySize/1mb).ToString("0.00 GB")
        MemoryVirtUse     = ($MemVirtUse/1mb).ToString("0.00 GB")
        MemoryVirtUseProc = [string]([int]$MemVirtUseProc)+" %"
        ProcWorkingSet    = $ws
        ProcPageMemory    = $pm
    })
    $CollectionMemory
}
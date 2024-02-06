function Get-ProcessPerformance {
    param (
        $ProcessName
    )
    if ($null -eq $ProcessName) {
        $GetProcess = Get-Process -ErrorAction Ignore | Where-Object ProcessName -ne Idle
    }
    else {
        $GetProcess = Get-Process -Name $ProcessName -ErrorAction Ignore
    }
    if ($null -ne $GetProcess) {
        $ProcessPerformance = Get-CimInstance Win32_PerfFormattedData_PerfProc_Process
        $Collections = New-Object System.Collections.Generic.List[System.Object]
        foreach ($Process in $GetProcess) {
            $ProcPerf = $ProcessPerformance | Where-Object IDProcess -eq $Process.Id
            $Collections.Add([PSCustomObject]@{
                Name           = $Process.Name
                ProcTime       = "$($ProcPerf.PercentProcessorTime) %"
                IOps           = $ProcPerf.IODataOperationsPersec
                IObsRead       = $($ProcPerf.IOReadBytesPersec / 1mb).ToString("0.00 Mb")
                IObsWrite      = $($ProcPerf.IOWriteBytesPersec / 1mb).ToString("0.00 Mb")
                RunTime        = if ($null -ne $Process.StartTime) {
                    $([string]([datetime](Get-Date) - $Process.StartTime) -replace "\.\d+$")
                }
                TotalTime      = $Process.TotalProcessorTime -replace "\.\d+$"
                UserTime       = $Process.UserProcessorTime -replace "\.\d+$"
                PrivTime       = $Process.PrivilegedProcessorTime -replace "\.\d+$"
                WorkingSet     = $($Process.WorkingSet / 1mb).ToString("0.00 Mb")
                PeakWorkingSet = $($Process.PeakWorkingSet / 1mb).ToString("0.00 Mb")
                PageMemory     = $($Process.PagedMemorySize / 1mb).ToString("0.00 Mb")
                Threads        = $Process.Threads.Count
                Handles        = $Process.Handles
                #Path           = $Process.Path
                #Company        = $Process.Company
                #FileVersion    = $Process.FileVersion
                #CommandLine    = $Process.CommandLine
            })
        }
        $Collections | Sort-Object -Descending ProcTime,IOps,TotalTime
    }
}
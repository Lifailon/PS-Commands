function Get-Performance {
    $GC = Get-Counter
    $CollectionPerf = New-Object System.Collections.Generic.List[System.Object]
    $CollectionPerf.Add([PSCustomObject]@{
        CPUTotalTime  = [string]([int]($GC.CounterSamples[4].CookedValue))+" %"
        MemoryUse     = [string]([int]($GC.CounterSamples[2].CookedValue))+" %"
        DiskTotalTime = [string]([int]($GC.CounterSamples[1].CookedValue))+" %"
        AdapterName   = $GC.CounterSamples[0].InstanceName
        AdapterSpeed  = ($GC.CounterSamples[0].CookedValue/1024/1024).ToString("0.000 MByte/Sec")
    })
    $CollectionPerf
}
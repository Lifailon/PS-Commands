function Get-CPUse {
    $CPU_Use_Proc = [string]((Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -ErrorAction Ignore | 
    Where-Object name -eq "_Total").PercentProcessorTime)+" %"
    $CollectionCPU = New-Object System.Collections.Generic.List[System.Object]
    $CollectionCPU.Add([PSCustomObject]@{
        CPU = $CPU_Use_Proc
    })
    $CollectionCPU
}
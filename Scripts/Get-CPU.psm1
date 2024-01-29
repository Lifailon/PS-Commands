function Get-CPU {
    $CPU_Perf = Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor
    $CPU_Cores = $CPU_Perf | Where-Object Name -ne "_Total" | Sort-Object {[int]$_.Name}
    $CPU_Total = $CPU_Perf | Where-Object Name -eq "_Total"
    $CPU_All = $CPU_Cores + $CPU_Total
    $CPU_All | Select-Object Name,
    @{Label="ProcessorTime"; Expression={[String]$_.PercentProcessorTime+" %"}},
    @{Label="PrivilegedTime"; Expression={[String]$_.PercentPrivilegedTime+" %"}},
    @{Label="UserTime"; Expression={[String]$_.PercentUserTime+" %"}},
    @{Label="InterruptTime"; Expression={[String]$_.PercentInterruptTime+" %"}},
    @{Label="IdleTime"; Expression={[String]$_.PercentIdleTime+" %"}}
}

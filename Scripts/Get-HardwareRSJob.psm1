Import-Module PoshRSJob -ErrorAction Ignore
if (!(Get-Module PoshRSJob)) {
   Install-Module PoshRSJob -Scope CurrentUser -Force
}

function Get-HardwareRSJob {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    i
    f ($null -eq $ComputerName) {
        # Creat jobs
        Start-RSJob -Name SYS -ScriptBlock {Get-CimInstance Win32_ComputerSystem} | Out-Null
        Start-RSJob -Name OS -ScriptBlock {Get-CimInstance Win32_OperatingSystem} | Out-Null
        Start-RSJob -Name BB -ScriptBlock {Get-CimInstance Win32_BaseBoard} | Out-Null
        Start-RSJob -Name CPU -ScriptBlock {Get-CimInstance Win32_Processor} | Out-Null
        Start-RSJob -Name CPU_Use -ScriptBlock {Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor} | Out-Null
        Start-RSJob -Name GetProcess -ScriptBlock {Get-Process} | Out-Null
        Start-RSJob -Name MEM -ScriptBlock {Get-CimInstance Win32_PhysicalMemory} | Out-Null
        Start-RSJob -Name PhysicalDisk -ScriptBlock {Get-CimInstance Win32_DiskDrive} | Out-Null
        Start-RSJob -Name LogicalDisk -ScriptBlock {Get-CimInstance Win32_logicalDisk} | Out-Null
        Start-RSJob -Name IOps -ScriptBlock {Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk} | Out-Null
        Start-RSJob -Name VideoCard -ScriptBlock {Get-CimInstance Win32_VideoController} | Out-Null
        Start-RSJob -Name NetworkAdapter -ScriptBlock {Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true} | Out-Null
        Start-RSJob -Name InterfaceStatCurrent -ScriptBlock {Get-CimInstance -ClassName Win32_PerfFormattedData_Tcpip_NetworkInterface} | Out-Null
        Start-RSJob -Name InterfaceStatAll -ScriptBlock {Get-CimInstance -ClassName Win32_PerfRawData_Tcpip_NetworkInterface} | Out-Null
        # Get data from jobs
        Start-Sleep -Milliseconds 100
        while ($(Get-RSJob).State -contains "Running") {
            Start-Sleep -Milliseconds 100
        }
        $SYS = Get-RSJob -Name SYS | Receive-RSJob
        $OS = Get-RSJob -Name OS | Receive-RSJob
        $BB = Get-RSJob -Name BB | Receive-RSJob
        $CPU = Get-RSJob -Name CPU | Receive-RSJob
        $CPU_Use = Get-RSJob -Name CPU_Use | Receive-RSJob
        $GetProcess = Get-RSJob -Name GetProcess | Receive-RSJob
        $MEM = Get-RSJob -Name MEM | Receive-RSJob
        $PhysicalDisk = Get-RSJob -Name PhysicalDisk | Receive-RSJob
        $LogicalDisk = Get-RSJob -Name LogicalDisk | Receive-RSJob
        $IOps = Get-RSJob -Name IOps | Receive-RSJob
        $VideoCard = Get-RSJob -Name VideoCard | Receive-RSJob
        $NetworkAdapter = Get-RSJob -Name NetworkAdapter | Receive-RSJob
        $InterfaceStatCurrent = Get-RSJob -Name InterfaceStatCurrent | Receive-RSJob
        $InterfaceStatAll = Get-RSJob -Name InterfaceStatAll | Receive-RSJob
        Get-RSJob | Remove-RSJob -Force
        # Select data
        $Uptime = ([string]($OS.LocalDateTime - $OS.LastBootUpTime) -split ":")[0,1] -join ":"
        $BootDate = Get-Date -Date $($OS).LastBootUpTime -Format "dd/MM/yyyy hh:mm:ss"
        $BBv = $BB.Manufacturer+" "+$BB.Product+" "+$BB.Version
        $CPU = $CPU | Select-Object Name,
            @{Label="Core"; Expression={$_.NumberOfCores}},
            @{Label="Thread"; Expression={$_.NumberOfLogicalProcessors}}
        $CPU_Use_Proc = [string](($CPU_Use | Where-Object name -eq "_Total").PercentProcessorTime)+" %"
        $Process_Count = $GetProcess.Count
        $Threads_Count = $GetProcess.Threads.Count
        $Handles_Count = ($GetProcess.Handles | Measure-Object -Sum).Sum
        $ws = ((($GetProcess).WorkingSet | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
        $pm = ((($GetProcess).PM | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
        $MemUse = $OS.TotalVisibleMemorySize - $OS.FreePhysicalMemory
        $MemUserProc = ($MemUse / $OS.TotalVisibleMemorySize) * 100
        $MEM = $MEM | Select-Object Manufacturer,PartNumber,ConfiguredClockSpeed,
            @{Label="Memory"; Expression={[string]($_.Capacity/1Mb)}}
        $MEMs = $MEM.Memory | Measure-Object -Sum
        $PhysicalDisk = $PhysicalDisk | Select-Object Model,
            @{Label="Size"; Expression={[int]($_.Size/1Gb)}}
        $PDs = $PhysicalDisk.Size | Measure-Object -Sum
        $LogicalDisk = $LogicalDisk | Where-Object {$null -ne $_.Size} |
            Select-Object @{Label="Value"; Expression={$_.DeviceID}},
            @{Label="AllSize"; Expression={([int]($_.Size/1Gb))}},
            @{Label="FreeSize"; Expression={([int]($_.FreeSpace/1Gb))}},
            @{Label="Free%"; Expression={[string]([int]($_.FreeSpace/$_.Size*100))+" %"}}
        $LDs = $LogicalDisk.AllSize | Measure-Object -Sum
        $IOps = $IOps | Where-Object { $_.Name -eq "_Total" } | Select-Object Name,
            @{name="TotalTime";expression={"$($_.PercentDiskTime) %"}},
            @{name="IOps";expression={$_.DiskTransfersPersec}},
            @{name="ReadBytesPersec";expression={$($_.DiskReadBytesPersec/1mb).ToString("0.000 MByte/Sec")}},
            @{name="WriteBytesPersec";expression={$($_.DiskWriteBytesPersec/1mb).ToString("0.000 MByte/Sec")}}
        $VideoCard = $VideoCard | Select-Object @{Label="VideoCard"; Expression={$_.Name}},
            @{Label="Display"; Expression={[string]$_.CurrentHorizontalResolution+"x"+[string]$_.CurrentVerticalResolution}}, 
            @{Label="vRAM"; Expression={([int]$($_.AdapterRAM/1Gb))}}
        $VCs = $VideoCard.vRAM | Measure-Object -Sum
        $NAs = $NetworkAdapter | Measure-Object
        $InterfaceStatCurrent = $InterfaceStatCurrent | Select-Object Name,
            @{name="Total";expression={$($_.BytesTotalPersec/1mb).ToString("0.000 MByte/Sec")}},
            @{name="Received";expression={$($_.BytesReceivedPersec/1mb).ToString("0.000 MByte/Sec")}},
            @{name="Sent";expression={$($_.BytesSentPersec/1mb).ToString("0.000 MByte/Sec")}}
        $InterfaceStatAll = $InterfaceStatAll | Select-Object Name,
            @{name="Total";expression={$($_.BytesTotalPersec/1gb).ToString("0.00 GByte")}},
            @{name="Received";expression={$($_.BytesReceivedPersec/1gb).ToString("0.00 GByte")}},
            @{name="Sent";expression={$($_.BytesSentPersec/1gb).ToString("0.00 GByte")}}
        $PortListenCount = $(Get-NetTCPConnection -State Listen).Count
        $PortEstablishedCount = $(Get-NetTCPConnection -State Established).Count
        $Collection = New-Object System.Collections.Generic.List[System.Object]
        $Collection.Add([PSCustomObject]@{
            Host                      = $SYS.Name
            Uptime                    = $uptime
            BootDate                  = $BootDate
            Owner                     = $SYS.PrimaryOwnerName
            OS                        = $OS.Caption
            Motherboard               = $BBv
            Processor                 = $CPU[0].Name
            Core                      = $CPU[0].Core
            Thread                    = $CPU[0].Thread
            CPU                       = $CPU_Use_Proc
            ProcessCount              = $Process_Count
            ThreadsCount              = $Threads_Count
            HandlesCount              = [int]$Handles_Count
            MemoryAll                 = [string]$($MEMs.Sum/1Kb)+" GB"
            MemoryUse                 = ($MemUse/1mb).ToString("0.00 GB")
            MemoryUseProc             = [string]([int]$MemUserProc)+" %"
            WorkingSet                = $ws
            PageMemory                = $pm
            MemorySlots               = $MEMs.Count
            PhysicalDiskCount         = $PDs.Count
            PhysicalDiskAllSize       = [string]$PDs.Sum+" Gb"
            LogicalDiskCount          = $LDs.Count
            LogicalDiskAllSize        = [string]$LDs.Sum+" Gb"
            DiskTotalTime             = $IOps.TotalTime
            DiskTotalIOps             = $IOps.IOps
            DiskTotalRead             = $IOps.ReadBytesPersec
            DiskTotalWrite            = $IOps.WriteBytesPersec
            VideoCardCount            = $VCs.Count
            VideoCardAllSize          = [string]$VCs.Sum+" Gb"
            NetworkAdapterEnableCount = $NAs.Count
            NetworkReceivedCurrent    = $InterfaceStatCurrent.Received
            NetworkSentCurrent        = $InterfaceStatCurrent.Sent
            NetworkReceivedTotal      = $InterfaceStatAll.Received
            NetworkSentTotal          = $InterfaceStatAll.Sent
            PortListenCount           = $PortListenCount
            PortEstablishedCount      = $PortEstablishedCount
        })
        $Collection
    }
    else {
        $url = "http://$ComputerName"+":$Port/api/hardware"
        $EncodingCred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${User}:${Pass}"))
        $Headers = @{"Authorization" = "Basic ${EncodingCred}"}
        try {
            Invoke-RestMethod -Headers $Headers -Uri $url
        }
        catch {
            Write-Error "Error connection"
        }
    }
}
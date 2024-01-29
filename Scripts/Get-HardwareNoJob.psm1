function Get-HardwareNoJob {
    param (
        $ComputerName,
        $Port = 8443,
        $User = "rest",
        $Pass = "api"
    )
    if ($null -eq $ComputerName) {
        $Collection = New-Object System.Collections.Generic.List[System.Object]
        $SYS = Get-CimInstance Win32_ComputerSystem
        $BootTime = Get-CimInstance -ComputerName $srv Win32_OperatingSystem |
        Select-Object LocalDateTime,
        LastBootUpTime
        $Uptime = ([string]($BootTime.LocalDateTime - $BootTime.LastBootUpTime) -split ":")[0,1] -join ":"
        $BootDate = Get-Date -Date $BootTime.LastBootUpTime -Format "dd/MM/yyyy hh:mm:ss"
        $OS = Get-CimInstance Win32_OperatingSystem
        $BB = Get-CimInstance Win32_BaseBoard
        $BBv = $BB.Manufacturer+" "+$BB.Product+" "+$BB.Version
        $CPU = Get-CimInstance Win32_Processor |
        Select-Object Name,
        @{Label="Core"; Expression={$_.NumberOfCores}},
        @{Label="Thread"; Expression={$_.NumberOfLogicalProcessors}}
        $CPU_Use_Proc = [string]((Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -ErrorAction Ignore | 
        Where-Object name -eq "_Total").PercentProcessorTime)+" %"
        $GetProcess = Get-Process
        $Process_Count = $GetProcess.Count
        $Threads_Count = $GetProcess.Threads.Count
        $Handles_Count = ($GetProcess.Handles | Measure-Object -Sum).Sum
        $ws = ((($GetProcess).WorkingSet | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
        $pm = ((($GetProcess).PM | Measure-Object -Sum).Sum/1gb).ToString("0.00 GB")
        $Memory = Get-CimInstance Win32_OperatingSystem
        $MemUse = $Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory
        $MemUserProc = ($MemUse / $Memory.TotalVisibleMemorySize) * 100
        $MEM = Get-CimInstance Win32_PhysicalMemory |
        Select-Object Manufacturer,
        PartNumber,
        ConfiguredClockSpeed,@{Label="Memory"; Expression={[string]($_.Capacity/1Mb)}}
        $MEMs = $MEM.Memory | Measure-Object -Sum
        $PhysicalDisk = Get-CimInstance Win32_DiskDrive |
        Select-Object Model,
        @{Label="Size"; Expression={[int]($_.Size/1Gb)}}
        $PDs = $PhysicalDisk.Size | Measure-Object -Sum
        $LogicalDisk = Get-CimInstance Win32_logicalDisk | Where-Object {$null -ne $_.Size} |
        Select-Object @{Label="Value"; Expression={$_.DeviceID}},
        @{Label="AllSize"; Expression={([int]($_.Size/1Gb))}},
        @{Label="FreeSize"; Expression={([int]($_.FreeSpace/1Gb))}},
        @{Label="Free%"; Expression={[string]([int]($_.FreeSpace/$_.Size*100))+" %"}}
        $LDs = $LogicalDisk.AllSize | Measure-Object -Sum
        $IOps = Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk -ErrorAction Ignore | 
        Where-Object { $_.Name -eq "_Total" } | 
        Select-Object Name,
        @{name="TotalTime";expression={"$($_.PercentDiskTime) %"}},
        @{name="IOps";expression={$_.DiskTransfersPersec}},
        @{name="ReadBytesPersec";expression={$($_.DiskReadBytesPersec/1mb).ToString("0.000 MByte/Sec")}},
        @{name="WriteBytesPersec";expression={$($_.DiskWriteBytesPersec/1mb).ToString("0.000 MByte/Sec")}}
        $VideoCard = Get-CimInstance Win32_VideoController | 
        Select-Object @{Label="VideoCard"; Expression={$_.Name}},
        @{Label="Display"; Expression={[string]$_.CurrentHorizontalResolution+"x"+[string]$_.CurrentVerticalResolution}}, 
        @{Label="vRAM"; Expression={([int]$($_.AdapterRAM/1Gb))}}
        $VCs = $VideoCard.vRAM | Measure-Object -Sum
        $NetworkAdapter = Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true
        $NAs = $NetworkAdapter | Measure-Object
        $InterfaceStatCurrent = Get-CimInstance -ClassName Win32_PerfFormattedData_Tcpip_NetworkInterface |
        Select-Object Name,
        @{name="Total";expression={$($_.BytesTotalPersec/1mb).ToString("0.000 MByte/Sec")}},
        @{name="Received";expression={$($_.BytesReceivedPersec/1mb).ToString("0.000 MByte/Sec")}},
        @{name="Sent";expression={$($_.BytesSentPersec/1mb).ToString("0.000 MByte/Sec")}}
        $InterfaceStatAll = Get-CimInstance -ClassName Win32_PerfRawData_Tcpip_NetworkInterface |
        Select-Object Name,
        @{name="Total";expression={$($_.BytesTotalPersec/1gb).ToString("0.00 GByte")}},
        @{name="Received";expression={$($_.BytesReceivedPersec/1gb).ToString("0.00 GByte")}},
        @{name="Sent";expression={$($_.BytesSentPersec/1gb).ToString("0.00 GByte")}}
        $PortListenCount = $(Get-NetTCPConnection -State Listen).Count
        $PortEstablishedCount = $(Get-NetTCPConnection -State Established).Count
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
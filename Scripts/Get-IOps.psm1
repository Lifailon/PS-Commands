function Get-IOps {
    Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk -ErrorAction Ignore | 
    Where-Object { $_.Name -ne "_Total" } | Select-Object Name,PercentDiskTime,PercentIdleTime,
    PercentDiskWriteTime,PercentDiskReadTime,CurrentDiskQueueLength,DiskBytesPersec,DiskReadBytesPersec,
    DiskReadsPersec,DiskTransfersPersec,DiskWriteBytesPersec,DiskWritesPersec
}
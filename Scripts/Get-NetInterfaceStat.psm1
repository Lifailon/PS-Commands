function Get-NetInterfaceStat {
    param (
        [switch]$Current
    )
    if ($Current) {
        Get-CimInstance -ClassName Win32_PerfFormattedData_Tcpip_NetworkInterface |
        Select-Object Name,
        @{name="Total";expression={$($_.BytesTotalPersec/1mb).ToString("0.000 MByte/Sec")}}, # Сумма полученных и отправленных байт за секунду
        @{name="Received";expression={$($_.BytesReceivedPersec/1mb).ToString("0.000 MByte/Sec")}}, # Количество байт, полученных за секунду
        @{name="Sent";expression={$($_.BytesSentPersec/1mb).ToString("0.000 MByte/Sec")}}, # Количество байт, отправленных за секунду
        PacketsPersec, # Общее количество пакетов в секунду (включает все виды пакетов)
        PacketsReceivedPersec, # Количество пакетов, полученных за секунду
        PacketsReceivedUnicastPersec, # Количество уникальных (unicast) пакетов, полученных за секунду, включает в себя широковещательные (broadcast) и групповые (multicast) пакеты
        PacketsReceivedNonUnicastPersec, # Количество не уникальных (non-unicast) пакетов, полученных за секунду
        PacketsReceivedDiscarded, # Количество отброшенных пакетов при получении
        PacketsReceivedErrors, # Количество пакетов с ошибками при получении
        PacketsSentPersec, # Количество пакетов, отправленных за секунду
        PacketsSentUnicastPersec, # Количество уникальных (unicast) пакетов, отправленных за секунду
        PacketsSentNonUnicastPersec # Количество не уникальных (non-unicast) пакетов, отправленных за секунду
    }
    else {
        Get-CimInstance -ClassName Win32_PerfRawData_Tcpip_NetworkInterface |
        Select-Object Name,
        @{name="Total";expression={$($_.BytesTotalPersec/1gb).ToString("0.00 GByte")}},
        @{name="Received";expression={$($_.BytesReceivedPersec/1gb).ToString("0.00 GByte")}},
        @{name="Sent";expression={$($_.BytesSentPersec/1gb).ToString("0.00 GByte")}}, 
        PacketsPersec,
        PacketsReceivedPersec,
        PacketsReceivedUnicastPersec,
        PacketsReceivedNonUnicastPersec,
        PacketsReceivedDiscarded,
        PacketsReceivedErrors,
        PacketsSentPersec,
        PacketsSentUnicastPersec,
        PacketsSentNonUnicastPersec
    }
}

# Get-NetInterfaceStat -Current
# Get-NetInterfaceStat
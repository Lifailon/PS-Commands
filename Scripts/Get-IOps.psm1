function Get-IOps {
    Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk | Select-Object Name,
    @{name="ReadWriteTime";expression={"$($_.PercentDiskTime) %"}}, # Процент времени, в течение которого физический диск занят обработкой запросов ввода-вывода
    @{name="ReadTime";expression={"$($_.PercentDiskReadTime) %"}}, # Процент времени, в течение которого физический диск занят чтением данных
    @{name="WriteTime";expression={"$($_.PercentDiskWriteTime) %"}}, # Процент времени, в течение которого физический диск занят записью данных
    @{name="IdleTime";expression={"$($_.PercentIdleTime) %"}}, #  Процент времени, в течение которого физический диск не занят (находится в режиме простоя)
    @{name="QueueLength";expression={$_.CurrentDiskQueueLength}}, # Текущая длина очереди диска (количество запросов, которые ожидают обработки диском)
    @{name="BytesPersec";expression={$($_.DiskBytesPersec/1mb).ToString("0.000 MByte/Sec")}}, # Скорость передачи данных через диск в байтах в секунду (объединенное значение для чтения и записи)
    @{name="ReadBytesPersec";expression={$($_.DiskReadBytesPersec/1mb).ToString("0.000 MByte/Sec")}}, # Скорость чтения данных с диска в байтах в секунду
    @{name="WriteBytesPersec";expression={$($_.DiskWriteBytesPersec/1mb).ToString("0.000 MByte/Sec")}}, # Скорость записи данных на диск в байтах в секунду
    @{name="IOps";expression={$_.DiskTransfersPersec}}, # Общее количество операций ввода-вывода (чтение и запись) с диска в секунду
    @{name="ReadsIOps";expression={$_.DiskReadsPersec}}, # Количество операций чтения с диска в секунду
    @{name="WriteIOps";expression={$_.DiskWritesPersec}} # Количество операций записи на диск в секунду
}
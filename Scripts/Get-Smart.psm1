function Get-Smart {
    $PhysicalDisk = Get-CimInstance -Namespace root/Microsoft/Windows/Storage -ClassName MSFT_PhysicalDisk
    $DiskSensor = $PhysicalDisk | Get-StorageReliabilityCounter
    $DiskSensor | Select-Object @{Label="DiskName"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DeviceId | Select-Object -ExpandProperty FriendlyName}},
    Temperature,
    @{Label="HealthStatus"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DeviceId | Select-Object -ExpandProperty HealthStatus}},
    @{Label="OperationalStatus"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DeviceId | Select-Object -ExpandProperty OperationalStatus}},
    @{Label="MediaType"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DeviceId | Select-Object -ExpandProperty MediaType}},
    @{Label="BusType"; Expression={$PhysicalDisk | Where-Object DeviceId -eq $_.DeviceId | Select-Object -ExpandProperty BusType}},
    PowerOnHours, # Количество часов, в течение которых жесткий диск был во включенном состоянии
    StartStopCycleCount, # Количество циклов включения и выключения жесткого диска (каждый цикл выключения и последующего включения считается за один раз)
    FlushLatencyMax, # Максимальное время задержки (латентность) для операций очистки кэша на диске (сброса кеша на диск).
    LoadUnloadCycleCount, #  Количество циклов загрузки/выгрузки механизма парковки головок на жёстких дисках с перемещающимися головками (не относится к SSD)
    ReadErrorsTotal, # Общее количество ошибок чтения данных с диска
    ReadErrorsCorrected, # Количество ошибок чтения, которые были исправлены системой коррекции ошибок
    ReadErrorsUncorrected, # Количество ошибок чтения, которые не удалось исправить
    ReadLatencyMax, # Максимальная задержка (латентность) при чтении данных с диска
    WriteErrorsTotal,
    WriteErrorsCorrected,
    WriteErrorsUncorrected,
    WriteLatencyMax
}
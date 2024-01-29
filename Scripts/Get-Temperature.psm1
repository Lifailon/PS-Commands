# Get-CimInstance CIM_TemperatureSensor
# Get-CimInstance Win32_TemperatureProbe
# Get-CimInstance Win32_PerfFormattedData_Counters_ThermalZoneInformation
# Get-CimInstance MSAcpi_ThermalZoneTemperature -Namespace root/WMI
# Get-CimInstance CIM_Fan
# Get-CimInstance CIM_CoolingDevice

function Get-Temperature {
    $ThermalZoneTemperature = Get-CimInstance MSAcpi_ThermalZoneTemperature -Namespace root/WMI
    $ThermalZoneTemperature.CurrentTemperature / 10 - 273.15
}
$path = "$home\Desktop\Services-to-Excel.xlsx"
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $false # отключить открытие GUI
$ExcelWorkBook = $Excel.Workbooks.Add() # Создать книгу
$ExcelWorkSheet = $ExcelWorkBook.Worksheets.Item(1) # Создать лист
$ExcelWorkSheet.Name = "Services" # задать имя листа
$ExcelWorkSheet.Cells.Item(1,1) = "Name service"
# Задать имена столбцов:
$ExcelWorkSheet.Cells.Item(1,2) = "Description"
$ExcelWorkSheet.Cells.Item(1,3) = "Status"
$ExcelWorkSheet.Cells.Item(1,4) = "Startup type"
$ExcelWorkSheet.Rows.Item(1).Font.Bold = $true # выделить жирным шрифтом
$ExcelWorkSheet.Rows.Item(1).Font.size=14
# Задать ширину колонок:
$ExcelWorkSheet.Columns.Item(1).ColumnWidth=30
$ExcelWorkSheet.Columns.Item(2).ColumnWidth=80
$ExcelWorkSheet.Columns.Item(3).ColumnWidth=15
$ExcelWorkSheet.Columns.Item(4).ColumnWidth=25
$services =  Get-Service
$counter = 2 # задать начальный номер строки для записи
foreach ($service in $services) {
$status = $service.Status
if ($status -eq 1) {
$status_type = "Stopped"
} elseif ($status -eq 4) {
$status_type = "Running"
}
$Start = $service.StartType
if ($Start -eq 1) {
$start_type = "Delayed start"
} elseif ($Start -eq 2) {
$start_type = "Automatic"
} elseif ($Start -eq 3) {
$start_type = "Manually"
} elseif ($Start -eq 4) {
$start_type = "Disabled"
}
$ExcelWorkSheet.Columns.Item(1).Rows.Item($counter) = $service.Name
$ExcelWorkSheet.Columns.Item(2).Rows.Item($counter) = $service.DisplayName
$ExcelWorkSheet.Columns.Item(3).Rows.Item($counter) = $status_type
$ExcelWorkSheet.Columns.Item(4).Rows.Item($counter) = $start_type
if ($status_type -eq "Running") {
$ExcelWorkSheet.Columns.Item(3).Rows.Item($counter).Font.Bold = $true
}
$counter++ # +1 увеличить для счетчика строки Rows
}
$ExcelWorkBook.SaveAs($path)
$ExcelWorkBook.close($true)
$Excel.Quit()
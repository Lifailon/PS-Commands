$path = "$home\Desktop\Services-to-Excel.xlsx"
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $false
$ExcelWorkBook = $excel.Workbooks.Open($path) # открыть xlsx-файл
$ExcelWorkBook.Sheets | select Name,Index # отобразить листы
$ExcelWorkSheet = $ExcelWorkBook.Sheets.Item(1) # открыть лист по номеру Index
1..100 | %{$ExcelWorkSheet.Range("A$_").Text} # прочитать значение из столбца А строки c 1 по 100
$Excel.Quit()
$path = "$home\Documents\Get-Service.db"
$TableName = "Service"
Import-Module MySQLite
Invoke-MySQLiteQuery -Path $path -Query "SELECT * FROM $TableName"
## posh-Commands

### Help
`Get-Command *Service*` поиск команды по имени \
`Get-Help Get-Service` синтаксис \
`Get-Service | Get-Member` отобразить Method (действия: Start, Stop), Property (объекты вывода: Status, DisplayName), Event (события объектов: Click) и Alias \
`Get-Alias ps` \
`Get-Verb` действия, утвержденные для использования в командах \
`Set-ExecutionPolicy Unrestricted` \
`Get-ExecutionPolicy`

### ping
`Test-Connection -Count 1 $srv1, $srv2` отправить icmp-пакет двум хостам \
`Test-Connection $srv -ErrorAction SilentlyContinue` не выводить ошибок, если хост не отвечает \
`Test-Connection -Source $srv1 -ComputerName $srv2` пинг с удаленного компьютера

### nslookup
`Resolve-DnsName ya.ru -Type MX` ALL,ANY,A,NS,SRV,CNAME,PTR,TXT(spf)

### port
`tnc $srv -p 5985` \
`tnc $srv -CommonTCPPort WINRM # HTTP,RDP,SMB` \
`tnc ya.ru –TraceRoute -Hops 2 # TTL=2` \
`tnc ya.ru -DiagnoseRouting` # маршрутизация до хоста, куда (DestinationPrefix: 0.0.0.0/0) через (NextHop: 192.168.1.254)

### ipconfig
`Get-NetIPConfiguration` \
`Get-NetAdapter` \
`Get-NetAdapterAdvancedProperty` \
`Get-NetAdapterStatistics`

### Route
`Get-NetRoute`

### Netstat
`Get-NetTCPConnection -State Established,Listen | where LocalAddress -match "192.168"`

### Hash
`Get-Filehash -Algorithm SHA256 "$env:USERPROFILE\Documents\RSA.conf.txt"`

### Clipboard
`Set-Clipboard $srv` скопировать в буфер обмена \
`Get-Clipboard` вставить

### Array
`$srv = @("server-01", "server-02")`  создать массив \
`$srv += @("server-03")` добавить в массив новый элемент \
`$srv.Count` отобразить кол-во элементов в массиве \
`Out-String` построчный вывод

### Index
`$srv[0]` вывести первое значение элемента массива \
`$srv[0] = Name` замена элемента в массиве \
`$srv[0].Length` узнать кол-во символов первого значения в массиве \
`$srv[10..100]` срез

### PSCustomObject
`$obj = @()` \
`$obj += [PSCustomObject]@{User = $env:username; Server = $env:computername}` медленный метод добавления, в каждой интерации перезаписывается массив и коллекция становится фиксированного размера (Collection was of a fixed size)

`$Collections = New-Object System.Collections.Generic.List[System.Object]` \
`$Collections.Add([PSCustomObject]@{User = $env:username; Server = $env:computername})`

`Get-Service | Select Name,DisplayName,Status,StartType | Export-csv -path "$home\Desktop\Get-Service.csv" -Append -Encoding Default` экспортировать в csv (-Encoding UTF8) \
`Import-Csv "$home\Desktop\Get-Service.csv" -Delimiter ","` импортировать массив

### Pipeline
`$obj | Add-Member -MemberType NoteProperty -Name "Type" -Value "user" -Force` добавление объкта вывода NoteProperty \
`$obj | Add-Member -MemberType NoteProperty -Name "User" -Value "admin" -Force` изменеие содержимого для сущности объекта User \
`ping $srv | Out-Null` перенаправить результат вывода в Out-Null

### Variable
`$var = Read-Host "Enter"` ручной ввод \
`$pass = Read-Host "Enter Password" -AsSecureString` скрывать набор \
`$global:path = "\\path"` задать глобальную переменную, например в функции \
`$using:srv` использовать переменную текущей сесси в Invoke-сессии \
`Get-Variable` отобразить все переменные \
`Get-Variable *srv*` найти переменную по имени \
`Get-Variable -Scope Global` отобразить все глобальные переменные \
`Get-Variable Error` последняя команда с ошибкой \
`Remove-Variable -Name *` очистить все переменные \
`$LASTEXITCODE` содержит код вывода последней запущенной программы, например ping. Если код возврата положительный (True), то $LastExitCode = 0

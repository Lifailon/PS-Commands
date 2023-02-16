# Заметки команд PowerShell

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

### ENV
`Get-ChildItem Env:` отобразить все переменные окружения \
`$env:PSModulePath` директории импорта модулей \
`$env:userprofile` \
`$env:computername` \
`$env:username` \
`$env:userdnsdomain` \
`$env:logonserver` \
`([DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()).Name` \
`[Environment]::GetFolderPath('ApplicationData')`

### GetType
`$srv.GetType()` узнать тип данных \
`$srv -is [string]` проверка на соответствие типа данных \
`$srv -isnot [System.Object]` проверка на несоответствие \
`$char = $srv.ToCharArray()` разбить строку [string] на массив [System.Array] из букв \
`$char.GetType()` тип данных: Char[] \
`[Object]` массив (BaseType:System.Array) \
`[int]` целое число (BaseType:System.ValueType) \
`[String]` строка-текст (BaseType:System.Object) \
`[DateTime]` формат времени (BaseType:System.ValueType)

### Property
`$srv.Count` кол-во элементов в массиве \
`$srv.Length` содержит количество символом строки переменной [string] или количество значений (строк) объекта \
`$srv.Chars(2)` отобразить 3-й символ в строке \
`$srv[2]` отобразить 3-ю строку в массиве

### Method
`$srv.Insert(0,"https://")` добавить значение перед первым символом \
`$srv.Substring(4)` удалить (из всего массива) первые 4 символа \
`$srv.Remove(3)` удалить из всего массива все после 3 символа \
`$string = "123"` создать строку \
`$int = [convert]::ToInt32($string)` преобразовать строку в тип данных число \
`[string]::Concat($text,$num)` объеденить переменные в одну строку \
`[string]::Join(":",$text,$num)` объеденить используя разделитель \
`[string]::Compare($text,$num,$true)` выдает 0 при совпадении или 1/-1 при несовпадении, $true (без учета регистра) или $false (с учетом регистра) \
`[string]::Equals($text,$num)` производит сравнение двух строк и выдает $true при их совпадении или $false при несовпадении \
`[string]::IsNullOrEmpty($text)` проверяет наличие строки, если строка пуста $true, если нет $false \
`[string]::IsNullOrWhiteSpace($text2)` проверяет на наличие только символов пробел, табуляция или символ новой строки

### Get-Date
`(Get-Date).AddHours(-3)` \
`$Date = (Get-Date -Format "dd/MM/yyyy hh:mm:ss")` \
`$Date = Get-Date -f "dd/MM/yyyy"` получаем тип данных [string] \
`[DateTime]$gDate = Get-Date "$Date"` преобразовать в тип [DateTime] \
`[int32]$days=($fDate-$gDate).Days` получить разницу в днях \
`"5/7/07" -as [DateTime]` преобразовать входные данные в тип данных [DateTime]

### Regex (регулярные выражения)
`-replace "1","2"` замена элементов в индексах массива (везде где присутствует 1, заменить на 2), для удаления используется только первое значение \
`-split " "` преобразовать строку в массив, разделителем указан пробел, которой удаляется ($url.Split("/")[-1]) \
`-join " "` преобразовать массив (коллекцию) в единую строку (string), добавить разделителем пробел \
`$iplist -contains "192.168.1.1"` проверить, что в массиве есть целое значение, выводит True или False \
`"192.168.1.1" -in $iplist` проверить на наличие указанного значения в массиве \
`-like *txt*` поиск по маскам wildcard, выводит значение на экран \
`-match txt` поиска по шаблонам, проверка на соответствие содержимого текста \
`-match "zabbix|rpc"` условия, для поиска по нескольким словам \
`-NotMatch` проверка на отсутствие вхождения \
`$ip = "192.168.10.1"` \
`$ip -match "(\.\d{1,3})\.\d{1,2}"` True \
`$Matches` отобразить все подходящие переменные последнего поиска, которые входят и не входят в группы ()

### Группировка
`if ((($1 -eq 1) -and ($2 -eq 2)) -or ($1 -ne 3)) {"$true"} else {"$false"}` два условия: (если $1 = 1 и $2 = 2) или $1 не равно 3. Если хотя бы одно из выражений равно True, то все условие относится к True и наоборот \
`-and` логическое И \
`-or` логическое ИЛИ \
`!(Test-Path $path)` # логическое НЕТ (-not), если путь недоступен, вернет True

### Специальные символы
`\d` число от 0 до 9 (20-07-2022 эквивалент: "\d\d-\d\d-\d\d\d\d") \
`\w` буква от "a" до "z" и от "A" до "Z" или число от 0 до 9 \
`\s` пробел, эквивалент: " " \
`\n` новая строка \
`\b` маска, определяет начало и конец целого словосочетания для поиска \
`.` обозначает любой символ, кроме новой строки \
`\` экранирует любой специальны символ (метасимвол). Используется, если нужно указать конкретный символ, вместо специального ({ } [ ] / \ + * . $ ^ | ?) \
`+` повторяется 1 и более раз (\s+) \
`{1,25}` квантификатор, указывает количество повторений символа слева на право (от 1 до 25 раз) \
`[]` поиск совпадения любой буквы, например, [A-z0-9] от A до z и цифры от 0 до 9 ("192.168.1.1" -match "192.1[6-7][0-9]")

### Якори
`^` или `\A` определяет начало строки. $url -replace '^','https:' # добавить в начало; \
`$` или `\Z` обозначают конец строки. $ip -replace "\d{1,3}$","0" \
`(?=text)` поиск слова слева. Пишем слева на право от искомого (ищет только целые словосочетания) "Server:\s(.{1,30})\s(?=$username)" \
`(?<=text)` поиск слова справа. $in_time -replace ".+(?<=Last)" # удалить все до слова Last \
`(?!text)` не совпадает со словом слева \
`(?<!text)` не совпадает со словом справа

### Группы захвата
`$date = '12.31.2021'` \
`$date -replace '^(\d{2}).(\d{2})','$2.$1'` поменять местами \
`$1` содержимое первой группы в скобках \
`$2` содержимое второй группы

### Условный оператор
`$rh = Read-Host` \
`if ($rh -eq 1) {ipconfig} elseif ($rh -eq 2) {getmac} else {hostname}` \
Если условие if () является истенным ($True), выполнить действие в {} \
Если условие if () является ложным ($False), выполнить действие не обязательного оператора else \
Условие Elseif идёт после условия if для проверки дополнительных условий перед выполнение оператора else. Оператор, который первый вернет $True, отменит выполнение следующих дополнительных условий \
Если передать переменную в условие без оператора, то будет проверяться наличие значения у переменной на $True/$False \
`if ((tnc $srv -Port 80).TcpTestSucceeded) {"Opened port"} else {"Closed port"}`

### Операторы
`-eq` равно (equal) \
`-ceq` учитывать регистр \
`-ne` не равно (not equal) \
`-gt` больше (greater) \
`-ge` больше или равно \
`-lt` меньше (less) \
`-le` меньше или равно

### Foreach
`$list = 100..110` создать массив из цифр от 100 до 110 \
`foreach ($srv in $list) {ping 192.168.3.$srv -n 1 -w 50}` $srv хранит текущий элемент из $list и повторяет команду до последнего элемента в массиве \
`$foreach.Current` текущий элемент в цикле \
`$foreach.Reset()` обнуляет итерацию, перебор начнется заново, что приводит к бесконечному циклу \
`$foreach.MoveNext()` переход к следующему элементу в цикле

### ForEach-Object
`100..110 | %{ping -n 1 -w 50 192.168.3.$_ > $null` \
`if ($LastExitCode -eq 0) {Write-Host "192.168.3.$_" -ForegroundColor green` \
`} else {` \
`Write-Host "192.168.3.$_"-ForegroundColor Red}}` \
`%` передать цикл через конвеер (ForEach-Object) \
`$_` переменная цикла и конвеера ($PSItem) \
`gwmi Win32_QuickFixEngineering | where {$_.InstalledOn.ToString() -match "2022"} | %{($_.HotFixID.Substring(2))}` gwmi создает массив, вывод команды передается where для поиска подходящих под критерии объектов. По конвееру передается в цикл для удаления первых (2) символов методом Substring из всех объектов HotFixID.

### While
`$srv = "yandex.ru"` \
`$out2 = "Есть пинг"` \
`$out3 = "Нет пинга"` \
`$out = $false` # предварительно сбросить переменную, While проверяет условие до запуска цикла \
`While ($out -eq $false){` # пока условие является $true, цикл будет повторяться \
`$out = ping -n 1 -w 50 $srv` \
`if ($out -match "ttl") {$out = $true; $out2} else {$out = $false; $out3; sleep 1}` \
`}`

`while ($True){` # запустить бесконечный цикл \
`$result = ping yandex.ru -n 1 -w 50` \
`if ($result -match "TTL"){` # условие, при котором будет выполнен break \
`Write-Host "Сайт доступен"` \
`break` # остановит цикл \
`} else {Write-Host "Сайт недоступен"; sleep 1}` \
`}`

### Select-String
`ipconfig /all | Select-String dns` поиск текста

### Select-Object
`Get-Process | Select-Object -Property *` отобразить все доступные объекты вывода \
`Get-Process | select -Unique "Name"` удалить повторяющиеся значения в массиве \
`Get-Process | select -ExpandProperty ProcessName` преобразовать из объекта-коллекции в массив (вывести содержимое без наименовая столбца) \
`(Get-Process).ProcessName`

`ps | Sort-Object -Descending CPU | select -first 10 ProcessName,` # сортировка по CPU, вывести первых 10 значений (-first) \
`@{Name="ProcessorTime"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}},` # затрачено процессорного времени в минутах \
`@{Name="Memory"; Expression={[string]([int]($_.WS / 1024kb))+"MB"}},` # делим байты на КБ \
`@{Label="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}}` # вычесть из текущего времени - время запуска, и удалить milisec

### Format-Table/Format-List
`Get-Process | ft ProcessName, StartTime -Autosize` автоматическая группировка размера столбцов

### Compare-Object
`Compare-Object -ReferenceObject (Get-Content -Path .\file1.txt) -DifferenceObject (Get-Content -Path .\file2.txt)` сравнение двух файлов \
`$group1 = Get-ADGroupMember -Identity "Domain Admins"` \
`$group2 = Get-ADGroupMember -Identity "Enterprise Admins"` \
`Compare-Object -ReferenceObject $group1 -DifferenceObject $group2 -IncludeEqual`
`==` нет изменений \
`<=` есть изменения в $group1 \
`=>` есть изменения в $group2 \

### Where-Object
`Get-Process | Where-Object {$_.ProcessName -match "zabbix"}` фильтрация/поиск процессов по имени свойства объекта \
`Get-Process | where CPU -gt 10 | Sort-Object -Descending CPU` вывести объекты, где значения CPU больше 10 \
`Get-Process | where WS -gt 200MB` отобразить процессы где WS выше 200МБ \
`Get-Service | where Name -match "zabbix"` поиск службы \
`Get-Service -ComputerName $srv | Where {$_.Name -match "WinRM"} | Restart-Service` перезапустить службу на удаленном компьютере \
`(Get-Service).DisplayName` вывести значения свойства массива \
`netstat -an | where {$_ -match 443}` \
`(netstat -an) -match 443`

### Sort-Object
`Get-Process | Sort-Object -Descending CPU | ft` обратная (-Descending) сортировка по CPU \
`$path[-1..-10]` # обратная сборка массива без сортировки

### Last/First
`Get-Process | Sort-Object -Descending CPU | select -First 10` вывести первых 10 объектов \
`Get-Process | Sort-Object -Descending CPU | select -Last 10` вывести последних 10 объектов

### ConvertTo-HTML
`Get-Process | select Name, CPU | ConvertTo-HTML -As list > "$env:userprofile\desktop\proc-list.html"` вывод в формате List (Format-List) или Table (Format-Table)

### Get-EventLog
`Get-EventLog -List` отобразить все корневые журналы логов и их размер \
`Clear-EventLog Application` очистить логи указанного журнала \
`Get-EventLog -LogName Security -InstanceId 4624` найти логи по ID в журнале Security

`function Get-Log ($count=30,$hour=-3) {` # указать значения параметров по умолчанию \
`Get-EventLog -LogName Application -Newest $count | where-Object TimeWritten -ge (Get-Date).AddHours($hour)` # отобразить 30 новых событий за последние 3 часа \
`}` \
`Get-Log 10 -1` # передача параметров функции (если значения идут по порядку, то можно не указывать названия переменных)

### Get-WinEvent
`Get-WinEvent -ListLog * | where logname -match SMB | sort -Descending RecordCount` отобразить все доступные журналы логов \
`Get-WinEvent -LogName "Microsoft-Windows-SmbClient/Connectivity" | where` \
`Get-WinEvent -LogName Security -MaxEvents 100` отобразить последние 100 событий \
`Get-WinEvent -FilterHashtable @{LogName="Security";ID=4624}` найти логи по ID в журнале Security

`$RDPAuths = Get-WinEvent -ComputerName $srv -LogName "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational" -FilterXPath '<QueryList><Query Id="0"><Select>*[System[EventID=1149]]</Select></Query></QueryList>'` \
`[xml[]]$xml = $RDPAuths | Foreach {$_.ToXml()}` \
`$EventData = Foreach ($event in $xml.Event) {` \
`New-Object PSObject -Property @{` \
`"Время подключения" = (Get-Date ($event.System.TimeCreated.SystemTime) -Format 'yyyy-MM-dd hh:mm K')` \
`"Имя пользователя" = $event.UserData.EventXML.Param1` \
`"Адрес клиента" = $event.UserData.EventXML.Param3` \
`}}` \
`$EventData | Out-Gridview -Title "История RDP подключений на сервере $srv"`

`$obj = @() \
`$fw = Get-WinEvent 'Microsoft-Windows-Windows Firewall With Advanced Security/Firewall'` \
`foreach ($temp_fw in $fw) {` \
`if ($temp_fw.id -eq 2004) {$type = "Added Rule"} elseif ($id -eq 2006) {$type = "Deleted Rule"}` \
`$port = $temp_fw.Properties[7] | select -ExpandProperty value` \
`$name = $temp_fw.Properties[1] | select -ExpandProperty value` \
`$obj += [PSCustomObject]@{Time = $temp_fw.TimeCreated; Type = $type; Port = $port; Name = $name}` \
`}`

### Time
`(Measure-Command {ping ya.ru}).TotalSeconds` узнать только время выполнения \
`(Get-History)[-1] | select @{Name="RunTime"; Expression={$_.EndExecutionTime - $_.StartExecutionTime}},ExecutionStatus,CommandLine` посчитать время работы последней [-1] (select -Last 1) выполненной команды и узнать ее статус \
`$start_time = Get-Date` зафиксировать время до выполнения команды \
`$end_time = Get-Date` зафиксировать время по завершению \
`$time = $end_time - $start_time` высчитать время работы скрипта \
`$min = $time.minutes` \
`$sec = $time.seconds` \
`Write-Host "$min минут $sec секунд"` \
`$timer = [System.Diagnostics.Stopwatch]::StartNew()` запустить таймер \
`$timer.IsRunning` статус работы таймера \
`$timer.Elapsed.TotalSeconds` отобразить время с момента запуска (в секундах) \
`$timer.Stop()` остановить таймер

### Firewall
`New-NetFirewallRule -Profile Any -DisplayName "Open Port 135 RPC" -Direction Inbound -Protocol TCP -LocalPort 135` открыть in-порт \
`Get-NetFirewallRule | Where-Object {$_.DisplayName -match "135"}` найти правило по имени \
`Get-NetFirewallPortFilter | where LocalPort -like 80` найти действующие правило по номеру порта

`Get-NetFirewallRule -Enabled True -Direction Inbound | select -Property DisplayName,`
`@{Name='Protocol';Expression={($_ | Get-NetFirewallPortFilter).Protocol}},`
`@{Name='LocalPort';Expression={($_ | Get-NetFirewallPortFilter).LocalPort}},`
`@{Name='RemotePort';Expression={($_ | Get-NetFirewallPortFilter).RemotePort}},`
`@{Name='RemoteAddress';Expression={($_ | Get-NetFirewallAddressFilter).RemoteAddress}},`
`Enabled,Profile`

### Performance
`(Get-Counter -ListSet *).CounterSetName` вывести список всех доступных счетчиков производительности в системе \
`(Get-Counter -ListSet *memory*).Counter` все счетчики, включая дочернии, поиск по wildcard-имени \
`Get-Counter "\Memory\Available MBytes"` объем свободной оперативной памяти \
`Get-Counter -cn $srv "\LogicalDisk(*)\% Free Space"` % свободного места на всех разделах дисков \
`(Get-Counter "\Process(*)\ID Process").CounterSamples` \
`Get-Counter "\Processor(_Total)\% Processor Time" –ComputerName $srv -MaxSamples 5 -SampleInterval 2` 5 проверок каждые 2 секунды \
`Get-Counter "\Процессор(_Total)\% загруженности процессора" -Continuous` непрерывно \
`(Get-Counter "\Процессор(*)\% загруженности процессора").CounterSamples`

### ThreadJob
`Install-Module -Name ThreadJob` установить модуль \
`Get-Module ThreadJob -list` \
`(Start-ThreadJob {ping ya.ru}) | Out-Null` создать фоновую задачу \
`while ($True){` \
`$status = @((Get-Job).State)[-1]` # отобразить статус последней [-1] фоновой задачи \
`if ($status -like "Completed"){` # если Completed \
`Get-Job | Receive-Job` # отобразить вывод, после каждого запроса результат удаляется (Get-Job).HasMoreData -eq $False \
`Get-Job | Remove-Job -Force` # удалить все задачи \
`break` # остановить цикл \
`}}` \
`Get-Job | Receive-Job -Keep` отобразить и не удалять вывод (-Keep)

### Event
`Register-EngineEvent` регистрирует подписку на события PowerShell или New-Event и создает задание (Get-Job) \
`Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {` \
`$date = Get-Date -f hh:mm:ss; (New-Object -ComObject Wscript.Shell).Popup("PowerShell Exit: $date",0,"Action",64)` \
`}` \
`-SupportEvent` не выводит результат регистрации события на экран, в Get-EventSubscriber и Get-Job \
`-Forward` перенаправляет события из удаленного сеанса (New-PSSession) в локальный сеанс

`Register-ObjectEvent` регистрирует подписку на события объектов .NET \
`$System_Obj | Get-Member -MemberType Event` отобразить список всех событий объекта \
`Register-ObjectEvent -InputObject $System_Obj -EventName Click -SourceIdentifier SrvListClick -Action {` \
`Write-Host $System_Obj.Text` \
`}` \
`Get-EventSubscriber` список зарегистрированных подписок на события в текущей сессии \
`Unregister-Event -SourceIdentifier SrvListClick` удаляет регистрацию подписки на событие по имени события (или все *) \
`Remove-Job -Name SrvListClick` удаляет задание \
`-InputObject` объект или переменная, хранящая объект \
`-EventName` событие (например, Click,MouseClick) \
`-SourceIdentifier` название регистрируемого события \
`-Action` действие при возникновении события

### Out-File
`Read-Host –AsSecureString | ConvertFrom-SecureString | Out-File "$env:userprofile\desktop\password.txt"` писать в файл. Преобразовать пароль в формат SecureString с использованием шифрования Windows Data Protection API (DPAPI)

### Get-Content (gc/cat/type)
`$password = gc "$env:userprofile\desktop\password.txt" | ConvertTo-SecureString` читать хэш пароля из файла с помощью ключей, хранящихся в профиле текущего пользователя, который невозможно прочитать на другом копьютере

### AES Key
`$AESKey = New-Object Byte[] 32` \
`[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($AESKey)` \
`$AESKey | Out-File "C:\password.key"` \
`$Cred.Password | ConvertFrom-SecureString -Key (Get-Content "C:\password.key") | Set-Content "C:\password.txt"` сохранить пароль в файл используя внешний ключ \
`$pass = Get-Content "C:\password.txt" | ConvertTo-SecureString -Key (Get-Content "\\Server\Share\password.key")` расшифровать пароль на втором компьютере

### Credential
`$Cred = Get-Credential` сохраняет креды в переменные $Cred.Username и $Cred.Password \
`$Cred.GetNetworkCredential().password` извлечь пароль \
`cmdkey /generic:"TERMSRV/$srv" /user:"$username" /pass:"$password"` добавить указанные креды аудентификации на на терминальный сервер для подключения без пароля \
`mstsc /admin /v:$srv` авторизоваться \
`cmdkey /delete:"TERMSRV/$srv"` удалить добавленные креды аудентификации из системы \
`rundll32.exe keymgr.dll,KRShowKeyMgr` хранилище Stored User Names and Password \
`Get-Service VaultSvc` служба для работы Credential Manager \
`Install-Module CredentialManager` установить модуль управления Credential Manager к хранилищу PasswordVault из PowerShell \
`[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls11,Tls12'` для устаноки модуля \
`Get-StoredCredential` получить учетные данные из хранилища Windows Vault \
`Get-StrongPassword` генератор пароля \
`New-StoredCredential -UserName test -Password "123456"` добавить учетную запись \
`Remove-StoredCredential` удалить учетную запись \
`$Cred = Get-StoredCredential | where {$_.username -match "admin"}` \
`$pass = $cred.password` \
`$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass)` \
`[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)`

### Items
`Test-Path $path` проверить доступность пути \
`Get-Location` отобразить текущие месторасположение (Alias: pwd/gl) \
`Set-Location $path` перемещение по каталогам (Alias: cd/sl) \
`Invoke-Item $path` открыть файл (Alias: ii/start) \
`Get-ChildItem $path *.exe* -Recurse` отобразить содержимое каталога (Alias: ls/dir) и дочерних каталогов (-Recurse) \
`Get-ItemProperty $env:userprofile\Documents\dns-list.txt | select FullName,Directory,Name,BaseName,Extension` свойтсва файла \
`Get-ItemProperty -Path $path\* | select FullName,CreationTime,LastWriteTime` свойства файлов содержимого директории, дата их создания и последнего изменения \
`New-Item -Path "C:\test\" -ItemType "Directory"` создать директорию (Alias: mkdir/md) \
`New-Item -Path "C:\test\file.txt" -ItemType "File" -Value "Добавить текст в файл"` создать файл \
`"test" > "C:\test\file.txt"` заменить содержимое \
`"test" >> "C:\test\file.txt"` добавить строку в файл \
`New-Item -Path "C:\test\test\file.txt" -Force` ключ используется для создания отсутствующих в пути директорий или перезаписи файла если он уже существует \
`Move-Item` перемещение объектов (Alias: mv/move) \
`Remove-Item -Recurse` рекурсивное удаление, без запроса подверждения если в каталоге находятся файлы (Alias: rm/del) \
`Remove-Item 'C:\test\*'` удаление файлов внутри каталога \
`Rename-Item "C:\test\*.*" "*.jpg"` переименовать файлы по маске (Alias: ren) \
`Copy-Item` копирование файлов и каталогов (Alias: cp/copy) \
`Copy-Item -Path "C:\*.txt" -Destination "C:\test\"` знак '\' в конце Destination используется для переноса папки внутрь указанной, отсутствие, что это новое имя директории \
`Copy-Item -Path "C:\*" -Destination "C:\test\" -Include '*.txt','*.jpg'` копировать объекты с указанным расширением (Include) \
`Copy-Item -Path "C:\*" -Destination "C:\test\" -Exclude '*.jpeg'` копировать объекты, за исключением файлов с расширением (Exclude) \
`$log = Copy-Item "C:\*.txt" "C:\test\" -PassThru` вывести результат копирования (логирование) в переменную, можно забирать строки с помощью индексов $log[0].FullName

`$date = (Get-Date).AddDays(-30)` \
`$files = (Get-ChildItem $path).FullName` \
`$creations = Get-ItemProperty $files | select FullName,LastWriteTime` \
`foreach ($creat in $creations) {` \
`if ($creat.LastWriteTime -le $date) {` \
`Remove-Item $creat.FullName -Recurse` \
`}` \
`}`

### Local User and Group
`Get-LocalUser` список пользователей \
`Get-LocalGroup` список групп \
`New-LocalUser "1C" -Password $Password -FullName "1C Domain"` создать пользователя \
`Set-LocalUser -Password $Password 1c` изменить пароль \
`Add-LocalGroupMember -Group "Administrators" -Member "1C"` добавить в группу Администраторов \
`Get-LocalGroupMember "Administrators"` члены группы

### SMB
`Get-SmbServerConfiguration` \
`Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force` отключить протокол SMB v1 \
`Get-WindowsFeature | Where-Object {$_.name -eq "FS-SMB1"} | ft Name,Installstate` модуль ServerManager, проверить установлен ли компонент SMB1 \
`Install-WindowsFeature FS-SMB1` установить SMB1 \
`Uninstall-WindowsFeature –Name FS-SMB1 –Remove` удалить SMB1 клиента (понадобится перезагрузка) \
`Get-WindowsOptionalFeature -Online` модуль DISM, для работы с компонентами Windows \
`Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -Remove` удалить SMB1 \
`Set-SmbServerConfiguration –AuditSmb1Access $true` включить аудит SMB1 \
`Get-SmbConnection` список активных сессий и используемая версия SMB (Dialect) \
`Get-SmbOpenFile | select ClientUserName,ClientComputerName,Path,SessionID` список открытых файлов \
`Get-SmbShare` список сетевых папок \
`New-SmbShare -Name xl-share -Path E:\test` создать новую общую сетевую папку (расшарить) \
`-EncryptData $True` включить шифрование SMB \
`-Description` имя в сетевом окружении \
`-ReadAccess "domain\username"` доступ на чтение \
`-ChangeAccess` доступ на запись \
`-FullAccess` полный доступ \
`-NoAccess ALL` нет прав \
`-FolderEnumerationMode [AccessBased | Unrestricted]` позволяет скрыть в сетевой папке объекты, на которых у пользователя нет доступа с помощью Access-Based Enumeration (ABE) \
`Get-SmbShare xl-share | Set-SmbShare -FolderEnumerationMode AccessBased` ключить ABE для всех расшаренных папок \
`Remove-SmbShare xl-share -force` удалить сетевой доступ (шару) \
`Get-SmbShareAccess xl-share` вывести список доступов безопасности к шаре \
`Revoke-SmbShareAccess xl-share -AccountName Everyone –Force` удалить группу из списка доступов \
`Grant-SmbShareAccess -Name xl-share -AccountName "domain\XL-Share" -AccessRight Change –force` изменить/добавить разрешения на запись (Full,Read) \
`Grant-SmbShareAccess -Name xl-share -AccountName "все" -AccessRight Change –force` \
`Block-SmbShareAccess -Name xl-share -AccountName "domain\noAccess" -Force` принудительный запрет \
`New-SmbMapping -LocalPath X: -RemotePath \\$srv\xl-share -UserName support4 -Password password –Persistent $true` подключить сетевой диск \
`-Persistent` восстановление соединения после отключения компьютера или сети \
`-SaveCredential` позволяет сохранить учетные данные пользователя для подключения в диспетчер учетных данных Windows Credential Manager \
`Stop-Process -Name "explorer" | Start-Process -FilePath "C:\Windows\explorer.exe"` перезапустить процесс для отображения в проводнике \
`Get-SmbMapping` список подключенных сетевых дисков \
`Remove-SmbMapping X: -force` отмонтировать сетевой диск \
`$CIMSession = New-CIMSession –Computername $srv` создать сеанс CIM (аудентификация на SMB) \
`Get-SmbOpenFile -CIMSession $CIMSession | select ClientUserName,ClientComputerName,Path | Out-GridView -PassThru | Close-SmbOpenFile -CIMSession $CIMSession -Confirm:$false –Force` закрыть файлы (открыть к ним сетевой доступ)

### Get-Acl
`(Get-Acl \\$srv\xl-share).access` доступ ACL на уровне NTFS \
`Get-Acl C:\Drivers | Set-Acl C:\Distr` скопировать NTFS разрешения с одной папки и применить их на другую

### NTFSSecurity
`Install-Module -Name NTFSSecurity -force` \
`Get-Item "\\$srv\xl-share" | Get-NTFSAccess` \
`Add-NTFSAccess -Path "\\$srv\xl-share" -Account "domain\xl-share" -AccessRights Fullcontrol -PassThru` добавить \
`Remove-NTFSAccess -Path "\\$srv\xl-share" -Account "domain\xl-share" -AccessRights FullControl -PassThru` удалить \
`Get-ChildItem -Path "\\$srv\xl-share" -Recurse -Force | Clear-NTFSAccess` удалить все разрешения, без удаления унаследованных разрешений \
`Get-ChildItem -Path "\\$srv\xl-share" -Recurse -Force | Enable-NTFSAccessInheritance` включить NTFS наследование для всех объектов в каталоге

### Out-Gridview
`Get-Service -cn $srv | Out-GridView -Title "Service $srv" -OutputMode Single –PassThru | Restart-Service` перезапустить выбранную службу

### wshell
`$wshell = New-Object -ComObject Wscript.Shell` \
`$Output = $wshell.Popup("Выберите действие?",0,"Заголовок",4)` \
`if ($output -eq 6) {"yes"} elseif ($output -eq 7) {"no"} else {"no good"}`

`Type:` \
`0` ОК \
`1` ОК и Отмена \
`2` Стоп, Повтор, Пропустить \
`3` Да, Нет, Отмена \
`4` Да и Нет \
`5` Повтор и Отмена \
`16` Stop \
`32` Question \
`48` Exclamation \
`64` Information

`Output:` \
`-1` Timeout \
`1` ОК \
`2` Отмена \
`3` Стоп \
`4` Повтор \
`5` Пропустить \
`6` Да \
`7` Нет

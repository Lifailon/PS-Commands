![Image alt](https://github.com/Lifailon/PowerShell-Commands/blob/rsa/Logo/PowerShell-Commands.png)

- [Object](#Object)
- [Regex](#Regex)
- [Items](#Items)
- [Credential](#Credential)
- [Event](#Event)
- [Firewall](#Firewall)
- [Performance](#Performance)
- [Regedit](#Regedit)
- [Scheduled](#Scheduled)
- [Network](#Network)
- [SMB](#SMB)
- [WinRM](#WinRM)
- [ComObject](#ComObject)
- [WMI](#WMI)
- [ActiveDirectory](#ActiveDirectory)
- [ServerManager](#ServerManager)
- [PackageManagement](#PackageManagement)
- [PowerCLI](#PowerCLI)
- [EMShell](#EMShell)
- [TrueNAS](#TrueNAS)
- [Veeam](#Veeam)
- [REST API](#REST-API)
- [IE](#IE)
- [Selenium](#Selenium)
- [Console API](#Console-API)
- [Excel](#Excel)
- [XML](#XML)
- [SQLite](#SQLite)
- [DSC](#DSC)
- [Git](#Git)

### Help
`Get-Command *Service*` поиск команды по имени \
`Get-Help Get-Service` синтаксис \
`Get-Help Stop-Process -Parameter *` описание всех параметров \
`Get-Service | Get-Member` отобразить Method (действия: Start, Stop), Property (объекты вывода: Status, DisplayName), Event (события объектов: Click) и Alias \
`Get-Alias ps` \
`Get-Verb` действия, утвержденные для использования в командах \
`Set-ExecutionPolicy Unrestricted` \
`Get-ExecutionPolicy` \
`$PSVersionTable`

# Object

### History
`Get-History` история команд текущей сессии \
`(Get-PSReadLineOption).HistorySavePath` путь к сохраненному файлу с 4096 последних команд (из модуля PSReadLine) \
`Get-Content (Get-PSReadlineOption).HistorySavePath | Select-String Get` поиск по содержимому файла (GREP) \
`Set-PSReadlineOption -MaximumHistoryCount 10000` изменить количество сохраняемых команд в файл \
`Get-PSReadLineOption | select MaximumHistoryCount` \
`Set-PSReadlineOption -HistorySaveStyle SaveNothing` отключить ведение журнала \
`F2` переключиться с InlineView на ListView

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

### HashTable
`$hashtable = @{}` \
`$User = "user"` \
`$Server = "Computer"` \
`$hashtable.Add($env:username,$env:computername)` \
`$hashtable.Remove("Lifailon")`

`$hashtable = @{"User" = "$env:username"; "Server" = "$env:computername"}` \
`$Tag = @{$true = 'dev'; $false = 'prod'}[([System.Net.Dns]::GetHostEntry("localhost").HostName) -match '.*.TestDomain$']`

### Keys
`$hashtable.Keys` список всех ключей \
`$hashtable["User"]` получить значение (Values) по ключу

### PSCustomObject
`$Collections = New-Object System.Collections.Generic.List[System.Object]` \
`$Collections.Add([PSCustomObject]@{User = $env:username; Server = $env:computername})`

`$object = New-Object –TypeName PSCustomObject -Property @{User = $env:username; Server = $env:computername}` \
`$object | Get-Member` \
`$object | Add-Member –MemberType NoteProperty –Name IP –Value "192.168.1.1"` имеет возможость добавить свойство или -MemberType ScriptMethod \
`$object.PsObject.Properties.Remove('User')` удалить свойство (столбец)

`$arr = @()` \
`$arr += [PSCustomObject]@{User = $env:username; Server = $env:computername}` медленный метод добавления, в каждой интерации перезаписывается массив и коллекция становится фиксированного размера (без возможности удаления) \
`$arr.Remove(0)` Exception calling "Remove" with "1" argument(s): "Collection was of a fixed size"

`Class CustomClass {` \
`[string]$User` \
`[string]$Server` \
`}` \
`$Class = New-Object -TypeName CustomClass` \
`$Class.User = $env:username` \
`$Class.Server = $env:computername`

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

### Select-Object
`Get-Process | Select-Object -Property *` отобразить все доступные объекты вывода \
`Get-Process | select -Unique "Name"` удалить повторяющиеся значения в массиве \
`Get-Process | select -ExpandProperty ProcessName` преобразовать из объекта-коллекции в массив (вывести содержимое без наименовая столбца) \
`(Get-Process).ProcessName`

### Expression
```
ps | Sort-Object -Descending CPU | select -first 10 ProcessName, # сортировка по CPU, вывести первых 10 значений (-first)
@{Name="ProcessorTime"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}}, # затрачено процессорного времени в минутах
@{Name="Memory"; Expression={[string]([int]($_.WS / 1024kb))+"MB"}}, # делим байты на КБ
@{Label="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}} # вычесть из текущего времени - время запуска, и удалить milisec
```
### Select-String
`ipconfig /all | Select-String dns` поиск текста

### Format-Table/Format-List
`Get-Process | ft ProcessName, StartTime -Autosize` автоматическая группировка размера столбцов

### Measure-Object
`Get-Process | Measure | select Count` кол-во объектов \
`Get-Process | Measure -Line -Word -Character` кол-во строк, слов и Char объектов

### Compare-Object
`Compare-Object -ReferenceObject (Get-Content -Path .\file1.txt) -DifferenceObject (Get-Content -Path .\file2.txt)` сравнение двух файлов \
`$group1 = Get-ADGroupMember -Identity "Domain Admins"` \
`$group2 = Get-ADGroupMember -Identity "Enterprise Admins"` \
`Compare-Object -ReferenceObject $group1 -DifferenceObject $group2 -IncludeEqual`
`==` нет изменений \
`<=` есть изменения в $group1 \
`=>` есть изменения в $group2

### Where-Object (?)
`Get-Process | Where-Object {$_.ProcessName -match "zabbix"}` фильтрация/поиск процессов по имени свойства объекта \
`Get-Process | where CPU -gt 10 | Sort-Object -Descending CPU` вывести объекты, где значения CPU больше 10 \
`Get-Process | where WS -gt 200MB` отобразить процессы где WS выше 200МБ \
`Get-Service | where Name -match "zabbix"` поиск службы \
`Get-Service -ComputerName $srv | Where {$_.Name -match "WinRM"} | Restart-Service` перезапустить службу на удаленном компьютере \
`(Get-Service).DisplayName` вывести значения свойства массива \
`netstat -an | where {$_ -match 443}` \
`netstat -an | ?{$_ -match 443}` \
`(netstat -an) -match 443`

### Sort-Object
`Get-Process | Sort-Object -Descending CPU | ft` обратная (-Descending) сортировка по CPU \
`$path[-1..-10]` обратная сборка массива без сортировки

### Last/First
`Get-Process | Sort-Object -Descending CPU | select -First 10` вывести первых 10 объектов \
`Get-Process | Sort-Object -Descending CPU | select -Last 10` вывести последних 10 объектов

# Regex

`-replace "1","2"` замена элементов в индексах массива (везде где присутствует 1, заменить на 2), для удаления используется только первое значение \
`-split " "` преобразовать строку в массив, разделителем указан пробел, которой удаляется ($url.Split("/")[-1]) \
`-join " "` преобразовать массив (коллекцию) в единую строку (string), добавить разделителем пробел \
`$iplist -contains "192.168.1.1"` проверить, что в массиве есть целое значение, выводит True или False \
`"192.168.1.1" -in $iplist` проверить на наличие указанного значения в массиве \
`-like *txt*` поиск по маскам wildcard, выводит значение на экран \
`-match txt` поиска по шаблонам, проверка на соответствие содержимого текста \
`-match "zabbix|rpc"` условия, для поиска по нескольким словам \
`-NotMatch` проверка на отсутствие вхождения \

### Matches
`$ip = "192.168.10.1"` \
`$ip -match "(\.\d{1,3})\.\d{1,2}"` True \
`$Matches` отобразить все подходящие переменные последнего поиска, которые входят и не входят в группы ()

`$String = "09/14/2017 12:00:27 - mtbill_post_201709141058.txt 7577_Delivered: OK"` \
`$String -Match ".*(?=\.txt)" | Out-Null` \
`$Matches[0][-4..-1] -Join ""`

`$string.Substring($string.IndexOf(".txt")-4, 4) # 2-й вариант (IndexOf)`

### Группировка
`if ((($1 -eq 1) -and ($2 -eq 2)) -or ($1 -ne 3)) {"$true"} else {"$false"}` два условия: (если $1 = 1 и $2 = 2) или $1 не равно 3. Если хотя бы одно из выражений равно True, то все условие относится к True и наоборот \
`-and` логическое И \
`-or` логическое ИЛИ \
`!(Test-Path $path)` логическое НЕТ (-not), если путь недоступен, вернет True

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

### GetType
`$srv.GetType()` узнать тип данных \
`$srv -is [string]` проверка на соответствие типа данных \
`$srv -isnot [System.Object]` проверка на несоответствие \
`$char = $srv.ToCharArray()` разбить строку [string] на массив [System.Array] из букв \
`$char.GetType()` тип данных: Char[] \
`[Object]` массив (BaseType:System.Array) \
`[int]` целое число (BaseType:System.ValueType) \
`[String]` строка-текст (BaseType:System.Object) \
`[DateTime]` формат времени (BaseType:System.ValueType) \
`[Boolean]` логический тип ($True/$False)

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

### Date
`(Get-Date).AddHours(-3)` \
`$Date = (Get-Date -Format "dd/MM/yyyy hh:mm:ss")` \
`$Date = Get-Date -f "dd/MM/yyyy"` получаем тип данных [string] \
`[DateTime]$gDate = Get-Date "$Date"` преобразовать в тип [DateTime] \
`[int32]$days=($fDate-$gDate).Days` получить разницу в днях \
`"5/7/07" -as [DateTime]` преобразовать входные данные в тип данных [DateTime] \
`New-TimeSpan -Start $VBRRP.CreationTimeUTC -End $VBRRP.CompletionTimeUTC` получить разницу во времени

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

### ForEach-Object (%)
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

# Items

`Test-Path $path` проверить доступность пути \
`Get-ChildItem $path -Filter *.txt -Recurse` # отобразить содержимое каталога (Alias: ls/gci/dir) и дочерних каталогов (-Recurse) и отфильтровать вывод \
`Get-Location` отобразить текущие месторасположение (Alias: pwd/gl) \
`Set-Location $path` перемещение по каталогам (Alias: cd/sl) \
`Invoke-Item $path` открыть файл (Alias: ii/start) \
`Get-ItemProperty $env:userprofile\Documents\dns-list.txt | select FullName,Directory,Name,BaseName,Extension` свойтсва файла \
`Get-ItemProperty -Path $path\* | select FullName,CreationTime,LastWriteTime` свойства файлов содержимого директории, дата их создания и последнего изменения \
`New-Item -Path "C:\test\" -ItemType "Directory"` создать директорию (Alias: mkdir/md) \
`New-Item -Path "C:\test\file.txt" -ItemType "File" -Value "Добавить текст в файл"` создать файл \
`"test" > "C:\test\file.txt"` заменить содержимое \
`"test" >> "C:\test\file.txt"` добавить строку в файл \
`New-Item -Path "C:\test\test\file.txt" -Force` ключ используется для создания отсутствующих в пути директорий или перезаписи файла если он уже существует \
`Move-Item` перемещение объектов (Alias: mv/move) \
`Remove-Item "$path\" -Recurse` удаление всех файлов внутри каталога, без запроса подверждения (Alias: rm/del) \
`Remove-Item $path -Recurse -Include "*.txt","*.temp" -Exclude "log.txt"` удалить все файлы с расширением txt и temp ([Array]), кроме log.txt \
`Rename-Item "C:\test\*.*" "*.jpg"` переименовать файлы по маске (Alias: ren) \
`Copy-Item` копирование файлов и каталогов (Alias: cp/copy) \
`Copy-Item -Path "\\server-01\test" -Destination "C:\" -Recurse` копировать директорию с ее содержимым (-Recurse) \
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

`ls (pwd).Path | %{` \
`$size = "{0:N1} Mb" -f ((ls $_.FullName -Recurse -Force | Measure-Object -Property Length -Sum).Sum / 1Mb) # посчитать размер всех дочерних директория в Mb (округлить до одного символа после запятой)` \
`$hashtable += @{"$_.Name" = $size} # заполнить hashtable` \
`}`

### Filehash
`Get-Filehash -Algorithm SHA256 "$env:USERPROFILE\Documents\RSA.conf.txt"`

### Clipboard
`Set-Clipboard $srv` скопировать в буфер обмена \
`Get-Clipboard` вставить

# Credential

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

### Out-Gridview
`Get-Service -cn $srv | Out-GridView -Title "Service $srv" -OutputMode Single –PassThru | Restart-Service` перезапустить выбранную службу

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

# Event

### EventLog
`Get-EventLog -List` отобразить все корневые журналы логов и их размер \
`Clear-EventLog Application` очистить логи указанного журнала \
`Get-EventLog -LogName Security -InstanceId 4624` найти логи по ID в журнале Security
```
function Get-Log {
Param(
[Parameter(Mandatory = $true, ValueFromPipeline = $true)][int]$Count,
$Hour
)
if ($Hour -ne $null) {
Get-EventLog -LogName Application -Newest $Count | ? TimeWritten -ge (Get-Date).AddHours($Hour)
} else {
Get-EventLog -LogName Application -Newest $Count
}
}
10 | Get-Log
Get-Log 100 -2
```
### WinEvent
`Get-WinEvent -ListLog * | where logname -match SMB | sort -Descending RecordCount` отобразить все доступные журналы логов \
`Get-WinEvent -LogName "Microsoft-Windows-SmbClient/Connectivity" | where` \
`Get-WinEvent -LogName Security -MaxEvents 100` отобразить последние 100 событий \
`Get-WinEvent -FilterHashtable @{LogName="Security";ID=4624}` найти логи по ID в журнале Security
```
$obj = @()
$fw = Get-WinEvent "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall"
foreach ($temp_fw in $fw) {
if ($temp_fw.id -eq 2004) {$type = "Added Rule"} elseif ($id -eq 2006) {$type = "Deleted Rule"}
$port = $temp_fw.Properties[7] | select -ExpandProperty value
$name = $temp_fw.Properties[1] | select -ExpandProperty value
$obj += [PSCustomObject]@{Time = $temp_fw.TimeCreated; Type = $type; Port = $port; Name = $name}
}
$obj
```
### XPath
```
$srv = "localhost"
$FilterXPath = '<QueryList><Query Id="0"><Select>*[System[EventID=21]]</Select></Query></QueryList>'
$RDPAuths = Get-WinEvent -ComputerName $srv -LogName "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational" -FilterXPath $FilterXPath
[xml[]]$xml = $RDPAuths | Foreach {$_.ToXml()}
$EventData = Foreach ($event in $xml.Event) {
New-Object PSObject -Property @{
"Connection Time" = (Get-Date ($event.System.TimeCreated.SystemTime) -Format 'yyyy-MM-dd hh:mm K')
"User Name" = $event.UserData.EventXML.User
"User ID" = $event.UserData.EventXML.SessionID
"User Address" = $event.UserData.EventXML.Address
"Event ID" = $event.System.EventID
}}
$EventData | ft
```
# Firewall

`New-NetFirewallRule -Profile Any -DisplayName "Open Port 135 RPC" -Direction Inbound -Protocol TCP -LocalPort 135` открыть in-порт \
`Get-NetFirewallRule | Where-Object {$_.DisplayName -match "135"}` найти правило по имени \
`Get-NetFirewallPortFilter | where LocalPort -like 80` найти действующие правило по номеру порта

`Get-NetFirewallRule -Enabled True -Direction Inbound | select -Property DisplayName,`
`@{Name='Protocol';Expression={($_ | Get-NetFirewallPortFilter).Protocol}},`
`@{Name='LocalPort';Expression={($_ | Get-NetFirewallPortFilter).LocalPort}},`
`@{Name='RemotePort';Expression={($_ | Get-NetFirewallPortFilter).RemotePort}},`
`@{Name='RemoteAddress';Expression={($_ | Get-NetFirewallAddressFilter).RemoteAddress}},`
`Enabled,Profile`

### Firewall-Manager
`Install-Module Firewall-Manager` \
`Export-FirewallRules -Name * -CSVFile $home\documents\fw.csv` -Inbound -Outbound -Enabled -Disabled -Allow -Block (фильтр правил для экспорта) \
`Import-FirewallRules -CSVFile $home\documents\fw.csv`

# Performance

`(Get-Counter -ListSet *).CounterSetName` вывести список всех доступных счетчиков производительности в системе \
`(Get-Counter -ListSet *memory*).Counter` все счетчики, включая дочернии, поиск по wildcard-имени \
`Get-Counter "\Memory\Available MBytes"` объем свободной оперативной памяти \
`Get-Counter -cn $srv "\LogicalDisk(*)\% Free Space"` % свободного места на всех разделах дисков \
`(Get-Counter "\Process(*)\ID Process").CounterSamples` \
`Get-Counter "\Processor(_Total)\% Processor Time" –ComputerName $srv -MaxSamples 5 -SampleInterval 2` 5 проверок каждые 2 секунды \
`Get-Counter "\Процессор(_Total)\% загруженности процессора" -Continuous` непрерывно \
`(Get-Counter "\Процессор(*)\% загруженности процессора").CounterSamples`

# Regedit

`Get-PSDrive` список всех доступных дисков и веток реестра \
`cd HKLM:\` HKEY_LOCAL_MACHINE \
`cd HKCU:\` HKEY_CURRENT_USER \
`Get-Item` получить информацию о ветке реестра \
`New-Item` создать новый раздел реестра \
`Remove-Item` удалить ветку реестра \
`Get-ItemProperty` получить значение ключей/параметров реестра (это свойства ветки реестра, аналогично свойствам файла) \
`Set-ItemProperty` изменить название или значение параметра реестра \
`New-ItemProperty` создать параметр реестра \
`Remove-ItemProperty` удалить параметр

`Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select DisplayName` список установленных программ \
`Get-Item HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Profiles\Outlook\9375CFF0413111d3B88A00104B2A6676\00000002` посмотреть содержимое Items \
`(Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Profiles\Outlook\9375CFF0413111d3B88A00104B2A6676\00000002)."New Signature"` отобразить значение (Value) свойства (Property) Items \
`$reg_path = "HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Profiles\Outlook\9375CFF0413111d3B88A00104B2A6676\00000002"` \
`$sig_name = "auto"` \
`Set-ItemProperty -Path $reg_path -Name "New Signature" -Value $sig_name` изменить или добавить в корне ветки (Path) свойство (Name) со значением (Value) \
`Set-ItemProperty -Path $reg_path -Name "Reply-Forward Signature" -Value $sig_name`

# Scheduled

`$Trigger = New-ScheduledTaskTrigger -At 01:00am -Daily` 1:00 ночи \
`$Trigger = New-ScheduledTaskTrigger –AtLogon` запуск при входе пользователя в систему \
`$Trigger = New-ScheduledTaskTrigger -AtStartup` при запуске системы \
`$User = "NT AUTHORITY\SYSTEM"` \
`$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "$home\Documents\DNS-Change-Tray-1.3.ps1"` \
`$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Unrestricted -WindowStyle Hidden -File $home\Documents\DNS-Change-Tray-1.3.ps1"` \
`Register-ScheduledTask -TaskName "DNS-Change-Tray-Startup" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force`

`Get-ScheduledTask | ? state -ne Disabled` список всех активных заданий \
`Start-ScheduledTask DNS-Change-Tray-Startup` запустить задание немедленно \
`Get-ScheduledTask DNS-Change-Tray-Startup | Disable-ScheduledTask` отключить задание \
`Get-ScheduledTask DNS-Change-Tray-Startup | Enable-ScheduledTask` включить задание \
`Unregister-ScheduledTask DNS-Change-Tray-Startup` удалить задание \
`Export-ScheduledTask DNS-Change-Tray-Startup | Out-File $home\Desktop\Task-Export-Startup.xml` экспортировать задание в xml \
`Register-ScheduledTask -Xml (Get-Content $home\Desktop\Task-Export-Startup.xml | Out-String) -TaskName "DNS-Change-Tray-Startup"`

# Network

### ping
`Test-Connection -Count 1 $srv1, $srv2` отправить icmp-пакет двум хостам \
`Test-Connection $srv -ErrorAction SilentlyContinue` не выводить ошибок, если хост не отвечает \
`Test-Connection -Source $srv1 -ComputerName $srv2` пинг с удаленного компьютера

### port
`tnc $srv -p 5985` \
`tnc $srv -CommonTCPPort WINRM` HTTP,RDP,SMB \
`tnc ya.ru –TraceRoute -Hops 2` TTL=2 \
`tnc ya.ru -DiagnoseRouting` маршрутизация до хоста, куда (DestinationPrefix: 0.0.0.0/0) через (NextHop: 192.168.1.254)

### ipconfig
`Get-NetIPConfiguration` \
`Get-NetAdapter` \
`Get-NetAdapterAdvancedProperty` \
`Get-NetAdapterStatistics`

### DNSClientServerAddress
`Get-DNSClientServerAddress` \
`Set-DNSClientServerAddress -InterfaceIndex (Get-NetIPConfiguration).InterfaceIndex -ServerAddresses 8.8.8.8`

### nslookup
`nslookup ya.ru 8.8.8.8` \
`nslookup -type=any ya.ru` \
`Resolve-DnsName ya.ru -Type MX` ALL,ANY,A,NS,SRV,CNAME,PTR,TXT(spf)

### route
`Get-NetRoute`

### netstat
`Get-NetTCPConnection -State Established,Listen | ? LocalAddress -match "192.168"`

### LocalGroup
`Get-LocalUser` список пользователей \
`Get-LocalGroup` список групп \
`New-LocalUser "1C" -Password $Password -FullName "1C Domain"` создать пользователя \
`Set-LocalUser -Password $Password 1C` изменить пароль \
`Add-LocalGroupMember -Group "Administrators" -Member "1C"` добавить в группу Администраторов \
`Get-LocalGroupMember "Administrators"` члены группы
```
@("vproxy-01","vproxy-02","vproxy-03") | %{
icm $_ {Add-LocalGroupMember -Group "Administrators" -Member "support4"}
icm $_ {Get-LocalGroupMember "Administrators"}
}
```
# WinRM

`Get-Service -Name winrm -RequiredServices` статус зависимых служб \
`Enter-PSSession -ComputerName $srv` подключиться к PowerShell сессии через PSRemoting. Подключение возможно только по FQDN-имени \
`Invoke-Command $srv -ScriptBlock {Get-ComputerInfo}` выполнение команды через PSRemoting \
`$session = New-PSSession $srv` открыть сессию \
`Get-PSSession` отобразить активные сессии \
`icm -Session $session {$srv = $using:srv}` передать переменную текущей сессии ($using) в удаленную \
`Disconnect-PSSession $session` закрыть сессию \
`Remove-PSSession $session` удалить сессию

### Windows Remote Management Configuration
`winrm quickconfig -quiet` изменит запуск службы WinRM на автоматический, задаст стандартные настройки WinRM и добавить исключения для портов в fw \
`Enable-PSRemoting –Force` \
`Test-WSMan $srv -ErrorAction Ignore` проверить работу WinRM на удаленном компьютере (игнорировать вывыод ошибок) \
`New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName "$env:computername" -FriendlyName "WinRM HTTPS Certificate" -NotAfter (Get-Date).AddYears(5)` создать самоподписанный сертификат и скопировать отпечаток (thumbprint) \
`New-Item -Path WSMan:\Localhost\Listener -Transport HTTPS -Address * -CertificateThumbprint "CACA491A66D1706AC2FEB5E53D0E111C1C73DD65"` создать прослушиватель \
`New-NetFirewallRule -DisplayName 'WinRM HTTPS Management' -Profile Domain,Private -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986` открыть порт в fw \
`winrm enumerate winrm/config/listener` текущая конфигурация прослушивателей WinRM (отображает отпечаток cert SSL для HTTPS 5986) \
`dir WSMan:\localhost\client` отобразить конфигурацию \
`winrm get winrm/config/service/auth` список всех конфигураций аутентификации WinRM (WSMan:\localhost\client\auth) \
`Set-Item -path wsman:\localhost\service\auth\basic -value $true` разрешить локальную аутентификацию \
`Set-PSSessionConfiguration -ShowSecurityDescriptorUI -Name Microsoft.PowerShell` добавить права доступа через дескриптор безопасности \
`Set-Item WSMan:\localhost\client\allowunencrypted $true` работать без шифрования \
`Set-Item WSMan:\localhost\client\TrustedHosts -Value "*" -force` добавить новый доверенный хост (для всех) в конфигурацию \
`net localgroup "Remote Management Users" "winrm" /add` добавить пользователя winrm (удалить /del) в локальную группу доступа "пользователи удаленного управления" (Local Groups - Remote Management Users)

# SMB

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

### Storage
`Get-Command -Module Storage` \
`Get-Disk` список логических дисков \
`Get-Partition` отобразить разделы на всех дисках \
`Get-Volume` список логичких разделов \
`Get-PhysicalDisk` список физических дисков \
`Initialize-Disk 1 –PartitionStyle MBR` инициализировать диск \
`New-Partition -DriveLetter D –DiskNumber 1 -Size 500gb` создать раздел (выделить все место -UseMaximumSize) \
`Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel Disk-D` форматировать раздел \
`Set-Partition -DriveLetter D -IsActive $True` сделать активным \
`Remove-Partition -DriveLetter D –DiskNumber 1` удалить раздел \
`Clear-Disk -Number 1 -RemoveData` очистить диск \
`Repair-Volume –driveletter C –Scan` Check disk \
`Repair-Volume –driveletter C –SpotFix` \
`Repair-Volume –driverletter C -Scan –Cimsession $CIMSession`

### iSCSI
`New-IscsiVirtualDisk -Path D:\iSCSIVirtualDisks\iSCSI2.vhdx -Size 20GB` создать динамический vhdx-диск (для фиксированного размера -UseFixed) \
`New-IscsiServerTarget -TargetName iscsi-target-2 -InitiatorIds "IQN:iqn.1991-05.com.microsoft:srv3.contoso.com"` создать Target \
`Get-IscsiServerTarget | fl TargetName, LunMappings` \
`Connect-IscsiTarget -NodeAddress "iqn.1995-05.com.microsoft:srv2-iscsi-target-2-target" -IsPersistent $true` подключиться инициатором к таргету \
`Get-IscsiTarget | fl` \
`Disconnect-IscsiTarget -NodeAddress ″iqn.1995-05.com.microsoft:srv2-iscsi-target-2-target″ -Confirm:$false` отключиться

# ComObject

`$wshell = New-Object -ComObject Wscript.Shell` \
`$wshell | Get-Member` \
`$link = $wshell.CreateShortcut("$Home\Desktop\Яндекс.lnk")` создать ярлык \
`$link.TargetPath = "https://yandex.ru"` куда ссылается (метод TargetPath объекта $link где хранится дочерний объект CreateShortcut) \
`$link.Save()` сохранить \
`(New-Object -ComObject wscript.shell).SendKeys([char]173)` включить/выключить звук

`$wshell.Exec("notepad.exe")` запустить приложение \
`$wshell.AppActivate("Блокнот")` развернуть запущенное приложение \
`sleep -Milliseconds 500` \
`$wshell.SendKeys("%")` ALT \
`$wshell.SendKeys("{ENTER}")` \
`$wshell.SendKeys("{DOWN}")` \
`$wshell.SendKeys("{DOWN}")` \
`$wshell.SendKeys("{ENTER}")` \
`Set-WinUserLanguageList -LanguageList en-us,ru -Force` изменить языковую раскладку клавиатуры \
`$wshell.SendKeys("login")`

`$wshell = New-Object -ComObject Wscript.Shell` \
`$output = $wshell.Popup("Выберите действие?",0,"Заголовок",4)` \
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

# WMI

### WMI/CIM (Windows Management Instrumentation/Common Information Model)	
`Get-WmiObjec -ComputerName localhost -Namespace root -class "__NAMESPACE" | select name,__namespace` отобразить дочернии Namespace (логические иерархические группы) \
`Get-WmiObject -List` отобразить все классы пространства имен "root\cimv2" (по умолчанию), свойства (описывают конфигурацию и текущее состояние управляемого ресурса) и их методы (какие действия позволяет выполнить над этим ресурсом) \
`Get-WmiObject -List | Where-Object {$_.name -match "video"}` поиск класса по имени, его свойств и методов \
`Get-WmiObject -ComputerName localhost -Class Win32_VideoController` отобразить содержимое свойств класса

`gwmi -List | where name -match "service" | ft -auto` если в таблице присутствуют Methods, то можно взаимодействовать {StartService, StopService} \
`gwmi -Class win32_service | select *` отобразить список всех служб и всех их свойств \
`Get-CimInstance Win32_service` обращается на прямую к "root\cimv2" \
`Get-CimInstance -ComputerName $srv Win32_OperatingSystem | select LastBootUpTime` время последнего включения \
`gwmi -ComputerName $srv -Class Win32_OperatingSystem | select LocalDateTime,LastBootUpTime` текущее время и время последнего включения \
`gwmi win32_service -Filter "name='Zabbix Agent'"` отфильтровать вывод по имени \
`(gwmi win32_service -Filter "name='Zabbix Agent'").State` отобразить конкретное свойство \
`gwmi win32_service -Filter "State = 'Running'"` отфильтровать запущенные службы \
`gwmi win32_service -Filter "StartMode = 'Auto'"` отфильтровать службы по методу запуска \
`gwmi -Query 'select * from win32_service where startmode="Auto"'` WQL-запрос (WMI Query Language) \
`gwmi win32_service | Get-Member -MemberType Method` отобразить все методы взаимодействия с описание применения (Delete, StartService) \
`(gwmi win32_service -Filter 'name="Zabbix Agent"').Delete()` удалить службу \
`(gwmi win32_service -Filter 'name="MSSQL$MSSQLE"').StartService()` запустить службу \
`gwmi Win32_OperatingSystem | Get-Member -MemberType Method` методы reboot и shutdown \
`(gwmi Win32_OperatingSystem -EnableAllPrivileges).Reboot()` используется с ключем повышения привелегий \
`(gwmi Win32_OperatingSystem -EnableAllPrivileges).Win32Shutdown(0)` завершение сеанса пользователя \
`gwmi -list -Namespace root\CIMV2\Terminalservices` \
`(gwmi -Class Win32_TerminalServiceSetting -Namespace root\CIMV2\TerminalServices).AllowTSConnections` \
`(gwmi -Class Win32_TerminalServiceSetting -Namespace root\CIMV2\TerminalServices).SetAllowTSConnections(1)` включить RDP \
`(Get-WmiObject win32_battery).estimatedChargeRemaining` заряд батареи в процентах
```
$srv = "localhost"
gwmi Win32_logicalDisk -ComputerName $srv | where {$_.Size -ne $null} | select @{
Label="Value"; Expression={$_.DeviceID}}, @{Label="AllSize"; Expression={
[string]([int]($_.Size/1Gb))+" GB"}},@{Label="FreeSize"; Expression={
[string]([int]($_.FreeSpace/1Gb))+" GB"}}, @{Label="Free%"; Expression={
[string]([int]($_.FreeSpace/$_.Size*100))+" %"}}
```
### NLA (Network Level Authentication)
`(gwmi -class "Win32_TSGeneralSetting" -Namespace root\cimv2\Terminalservices -Filter "TerminalName='RDP-tcp'").UserAuthenticationRequired` \
`(gwmi -class "Win32_TSGeneralSetting" -Namespace root\cimv2\Terminalservices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(1)` включить NLA \
`Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name SecurityLayer` отобразить значение (2) \
`Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name UserAuthentication` отобразить значение (1) \
`Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name SecurityLayer -Value 0` изменить значение \
`Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name UserAuthentication -Value 0` \
`REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters /v AllowEncryptionOracle /t REG_DWORD /d 2` отключить на клиентском компьютере проверку версии CredSSP, если на целевом комьютере-сервере не установлены обновления KB4512509 от мая 2018 года

# ActiveDirectory

### RSAT (Remote Server Administration Tools)
`DISM.exe /Online /add-capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0` \
`Add-WindowsCapability –online –Name Rsat.Dns.Tools~~~~0.0.1.0` \
`Add-WindowsCapability -Online -Name Rsat.DHCP.Tools~~~~0.0.1.0` \
`Add-WindowsCapability –online –Name Rsat.FileServices.Tools~~~~0.0.1.0` \
`Add-WindowsCapability -Online -Name Rsat.WSUS.Tools~~~~0.0.1.0` \
`Add-WindowsCapability -Online -Name Rsat.CertificateServices.Tools~~~~0.0.1.0` \
`Add-WindowsCapability -Online -Name Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0` \
`Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State` отобразить список установленных компанентов

### Import-Module ActiveDirectory
`$Session = New-PSSession -ComputerName $srv # -Credential $cred` \
`Export-PSsession -Session $Session -Module ActiveDirectory -OutputModule ActiveDirectory` экспортировать модуль из удаленной сесси (например, с DC) \
`Remove-PSSession -Session $Session` \
`Import-Module ActiveDirectory` \
`Get-Command -Module ActiveDirectory`

### LDAP (Lightweight Directory Access Protocol)
`$ldapsearcher = New-Object System.DirectoryServices.DirectorySearcher` \
`$d0 = $env:userdnsdomain` \
`$d0 = $d0 -split "\."` \
`$d1 = $d0[0]` \
`$d2 = $d0[1]` \
`$ldapsearcher.SearchRoot = "LDAP://OU=Domain Controllers,DC=$d1,DC=$d2"` \
`$ldapsearcher.Filter = "(objectclass=computer)"` \
`$dc = $ldapsearcher.FindAll().path`

`$usr = $env:username` cписок групп текущего пользователя \
`$ldapsearcher = New-Object System.DirectoryServices.DirectorySearcher` \
`$ldapsearcher.Filter = "(&(objectCategory=User)(samAccountName=$usr))"` \
`$usrfind = $ldapsearcher.FindOne()` \
`$groups = $usrfind.properties.memberof -replace "(,OU=.+)"` \
`$groups = $groups -replace "(CN=)"`

DC (Domain Component) - компонент доменного имени \
OU (Organizational Unit) - организационные подразделения (type), используются для упорядочения объектов \
Container - так же используется для упорядочения объектов, контейнеры в отличии от подраделений не могут быть переименованы, удалены, созданы или связаны с объектом групповой политики (Computers, Domain Controllers, Users) \
DN (Distinguished Name) — уникальное имя объекта и местоположение в лесу AD. В DN описывается содержимое атрибутов в дереве (путь навигации), требуемое для доступа к конкретной записи или ее поиска \
CN (Common Name) - общее имя

`(Get-ADObject (Get-ADRootDSE).DefaultNamingContext -Properties wellKnownObjects).wellKnownObjects` отобразить отобразить контейнеры по умолчанию \
`redircmp OU=Client Computers,DC=root,DC=domain,DC=local` изменить контейнер компьютеров по умолчанию \
`redirusr` изменить контейнер пользователей по умолчанию

### LAPS (Local Admin Password Management)
`Import-module AdmPwd.ps` импортировать модуль \
`Get-AdmPwdPassword -ComputerName NAME` посмотреть пароль \
`Reset-AdmPwdPassword -ComputerName NAME` изменить пароль \
`Get-ADComputer -Filter * -SearchBase "DC=$d1,DC=$d2" | Get-AdmPwdPassword -ComputerName {$_.Name} | select ComputerName,Password,ExpirationTimestamp | Out-GridView` \
`Get-ADComputer -Identity $srv | Get-AdmPwdPassword -ComputerName {$_.Name} | select ComputerName,Password,ExpirationTimestamp`

### Recycle Bin
Удаленные объекты хранятся в корзине AD в течении времени захоронения (определяется в атрибуте домена msDS-deletedObjectLifetime), заданном для леса. По умолчанию это 180 дней. Если данный срок прошел, объект все еще остается в контейнере Deleted Objects, но большинство его атрибутов и связей очищаются (Recycled Object). После истечения периода tombstoneLifetime (по умолчанию также 180 дней, но можно увеличить) объект полностью удаляется из AD автоматическим процессом очистки. \
`Get-ADForest domain.local` отобразить уровень работы леса \
`Set-ADForestMode -Identity domain.local -ForestMode Windows2008R2Forest -force` увеличить уровень работы леса \
`Enable-ADOptionalFeature –Identity "CN=Recycle Bin Feature,CN=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=domain,DC=local" –Scope ForestOrConfigurationSet –Target "domain.local"` включить корзину \
`Get-ADOptionalFeature "Recycle Bin Feature" | select-object name,EnabledScopes` если значение EnabledScopes не пустое, значит в домене корзина Active Directory включена \
`Get-ADObject -Filter 'Name -like "*tnas*"' -IncludeDeletedObjects` найти удаленную (Deleted: True) УЗ (ObjectClass: user) в AD \
`Get-ADObject -Filter 'Name -like "*tnas*"' –IncludeDeletedObjects -Properties *| select-object Name, sAMAccountName, LastKnownParent, memberOf, IsDeleted | fl` проверить значение атрибута IsDeleted, контейнер, в котором находился пользователе перед удалением (LastKnownParent) и список групп, в которых он состоял \
`Get-ADObject –filter {Deleted -eq $True -and ObjectClass -eq "user"} –includeDeletedObjects` вывести список удаленных пользователей \
`Restore-ADObject -Identity "3dc33c7c-b912-4a19-b1b7-415c1395a34e"` восстановить по значению атрибута ObjectGUID \
`Get-ADObject -Filter 'SAMAccountName -eq "tnas-01"' –IncludeDeletedObjects | Restore-ADObject` восстановить по SAMAccountName \
`Get-ADObject -Filter {Deleted -eq $True -and ObjectClass -eq 'group' -and Name -like '*Allow*'} –IncludeDeletedObjects | Restore-ADObject –Verbose` восстановить группу или компьютер

### thumbnailPhoto
`$photo = [byte[]](Get-Content C:\Install\adm.jpg -Encoding byte)` преобразовать файл картинки в массив байтов (jpeg/bmp файл, размером фото до 100 Кб и разрешением 96×96) \
`Set-ADUser support4 -Replace @{thumbnailPhoto=$photo}` задать значение атрибута thumbnailPhoto

### ADDomainController
`Get-ADDomainController` выводит информацию о текущем контроллере домена (LogonServer), который используется данным компьютером для аутентификации (DC выбирается при загрузке в соответствии с топологией сайтов AD) \
`Get-ADDomainController -Discover -Service PrimaryDC` найти контроллер с ролью PDC в домене \
`Get-ADDomainController -Filter * | ft HostName,IPv4Address,Name,Site,OperatingSystem,IsGlobalCatalog` список все DC, принадлежность к сайту, версии ОС и GC

При загрузке ОС служба NetLogon делает DNS запрос со списком контроллеров домена (к SRV записи _ldap._tcp.dc._msdcs.domain_), DNS возвращает список DC в домене с записью Service Location (SRV). Клиент делает LDAP запрос к DC для определения сайта AD по своему IP адресу. Клиент через DNS запрашивает список контроллеров домена в сайте (в разделе _tcp.sitename._sites...).

USN (Update Sequence Numbers) - счетчик номера последовательного обновления, который существует у каждого объекта AD. При репликации контроллеры обмениваются значениями USN, объект с более низким USN будет при репликации перезаписан объектом с более высоким USN. Находится в свойствах - Object (включить View - Advanced Features). Каждый контроллер домена содержит отдельный счетчик USN, который начинает отсчет в момент запуска процесса Dcpromo и продолжает увеличивать значения в течение всего времени существования контроллера домена. Значение счетчика USN увеличивается каждый раз, когда на контроллере домена происходит транзакция, это операции создания, обновления или удаления объекта.

`Get-ADDomainController -Filter * | % { # отобразить USN объекта на всех DC в домене` \
`Get-ADUser -Server $_.HostName -Identity support4 -Properties uSNChanged | select SamAccountName,uSNChanged` \
`}`

`dcpromo /forceremoval` принудительно выполнит понижение в роли контроллера домена до уровня рядового сервера. После понижения роли выполняется удаление всех ссылок в домене на этот контроллер. Далее производит включение сервера в состав домена, и выполнение обратного процесса, т.е. повышение сервера до уровня контроллера домена.

### ADComputer
`nltest /DSGETDC:$env:userdnsdomain` узнать на каком DC аудентифицирован хост (Logon Server) \
`nltest /SC_RESET:$env:userdnsdomain\srv-dc2.$env:userdnsdomain` переключить компьютер на другой контроллер домена AD вручную (The command completed successfully) \
`Get-ADComputer –Identity $env:computername -Properties PasswordLastSet` время последней смены пароля на сервере \
`Test-ComputerSecureChannel –verbose` проверить доверительные отношения с доменом (соответствует ли локальный пароль компьютера паролю, хранящемуся в AD) \
`Reset-ComputerMachinePassword -Credential domain\admin` принудительно обновить пароль \
`Netdom ResetPWD /Server:dc-01 /UserD:domain\admin /PasswordD:*` сбросить хэш пароля компьютера в домене (перезагрузка не требуется) \
`Search-ADAccount -AccountDisabled -ComputersOnly | select Name,LastLogonDate,Enabled` отобразить все отключенные компьютеры

`Get-ADComputer -Filter * -Properties * | select name` список всех компьютеров в домене (Filter), вывести все свойства (Properties) \
`Get-ADComputer -Identity $srv -Properties * | ft Name,LastLogonDate,PasswordLastSet,ms-Mcs-AdmPwd -Autosize` конкретного компьютера в AD (Identity) \
`Get-ADComputer -SearchBase "OU=Domain Controllers,DC=$d1,DC=$d2" -Filter * -Properties * | ft Name, LastLogonDate, distinguishedName -Autosize` поиск в базе по DN (SearchBase)

`(Get-ADComputer -Filter {enabled -eq "true"}).count` получить общее количество активных (незаблокированных) компьютеров \
`(Get-ADComputer -Filter {enabled -eq "true" -and OperatingSystem -like "*Windows Server 2016*"}).count` кол-во активных копьютеров с ОС WS 2016

`Get-ADComputer -Filter * -Properties * | select @{Label="Ping Status"; Expression={` \
`$ping = ping -n 1 -w 50 $_.Name` \
`if ($ping -match "TTL") {"Online"} else {"Offline"}` \
`}},` \
`@{Label="Status"; Expression={` \
`if ($_.Enabled -eq "True") {$_.Enabled -replace "True","Active"} else {$_.Enabled -replace "False","Blocked"}` \
`}}, Name, IPv4Address, OperatingSystem, @{Label="UserOwner"; Expression={$_.ManagedBy -replace "(CN=|,.+)"}` \
`},Created | Out-GridView`

### ADUser
`Get-ADUser -Identity support4 -Properties *` список всех атрибутов \
`Get-ADUser -Identity support4 -Properties DistinguishedName, EmailAddress, Description` путь DN, email и описание \
`Get-ADUser -Filter {(Enabled -eq "True") -and (mail -ne "null")} -Properties mail | ft Name,mail` список активных пользователей и есть почтовый ящик \
`Get-ADUser -Filter {SamAccountName -like "*"} | Measure-Object` посчитать кол-во всех аккаунтов (Count) \
`Get-ADUser -Filter * -Properties WhenCreated | sort WhenCreated | ft Name, whenCreated` дата создания \
`Get-ADUser -Identity support4 -property LockedOut | select samaccountName,Name,Enabled,Lockedout` \
`Enabled=True` учетная запись включена - да \
`Lockedout=False` учетная запись заблокирована (например, политикой паролей) - нет \
`Get-ADUser -Identity support4 | Unlock-ADAccount` разблокировать учетную запись \
`Disable-ADAccount -Identity support4` отключить учетную запись \
`Enable-ADAccount -Identity support4` включить учетную запись \
`Search-ADAccount -LockedOut` найти все заблокированные учетные записи \
`Search-ADAccount -AccountDisabled | select Name,LastLogonDate,Enabled` отобразить все отключенные учетные записи с временем последнего входа

`Get-ADUser -Identity support4 -Properties PasswordLastSet,PasswordExpired,PasswordNeverExpires` \
`PasswordLastSet` время последней смены пароля \
`PasswordExpired=False` пароль истек - нет \
`PasswordNeverExpires=True` срок действия пароля не истекает - да \
`Set-ADAccountPassword support4 -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "password" -Force -Verbose)` изменить пароль учетной записи \
`Set-ADUser -Identity support4 -ChangePasswordAtLogon $True` смена пароля при следующем входе в систему

`$day = (Get-Date).adddays(-90)` \
`Get-ADUser -filter {(passwordlastset -le $day)} | ft` пользователи, которые не меняли свой пароль больше 90 дней

`$day = (Get-Date).adddays(-30)` \
`Get-ADUser -filter {(Created -ge $day)} -Property Created | select Name,Created` Новые пользователи за 30 дней

`$day = (Get-Date).adddays(-360)` \
`Get-ADUser -Filter {(LastLogonTimestamp -le $day)} -Property LastLogonTimestamp | select Name,SamAccountName,@{n='LastLogonTimestamp';e={[DateTime]::FromFileTime($_.LastLogonTimestamp)}} | sort -Descending LastLogonTimestamp` пользователи, которые не логинились больше 360 дней. Репликация атрибута LastLogonTimestamp составляет от 9 до 14 дней. \
`| Disable-ADAccount $_.SamAccountName` заблокировать \
`-WhatIf` отобразить вывод без применения изменений

### ADGroupMember
`(Get-ADUser -Identity support4 -Properties MemberOf).memberof` список групп в которых состоит пользователь \
`Get-ADGroupMember -Identity "Domain Admins" | Select Name,SamAccountName` список пользователей в группе \
`Add-ADGroupMember -Identity "Domain Admins" -Members support5` добавить в группу \
`Remove-ADGroupMember -Identity "Domain Admins" -Members support5 -force` удалить из группы \
`Get-ADGroup -filter * | where {!($_ | Get-ADGroupMember)} | Select Name` отобразить список пустых групп (-Not)

### ADReplication
`Get-Command -Module ActiveDirectory -Name *Replication*` список всех командлетов модуля \
`Get-ADReplicationFailure -Target dc-01` список ошибок репликации с партнерами \
`Get-ADReplicationFailure -Target $env:userdnsdomain -Scope Domain` \
`Get-ADReplicationPartnerMetadata -Target dc-01 | select Partner,LastReplicationAttempt,LastReplicationSuccess,LastReplicationResult,LastChangeUsn` время последней и время успешной репликации с партнерами \
`Get-ADReplicationUpToDatenessVectorTable -Target dc-01` Update Sequence Number (USN) увеличивается каждый раз, когда на контроллере домена происходит транзакция (операции создания, обновления или удаления объекта), при репликации DC обмениваются значениями USN, объект с более низким USN при репликации будет перезаписан высоким USN.

`repadmin /replsummary` отображает время последней репликации на всех DC по направлению (Source и Destination) и их состояние с учетом партнеров \
`repadmin /showrepl $srv` отображает всех партнеров по реплкации и их статус для всех разделов Naming Contexts (DC=ForestDnsZones, DC=DomainDnsZones, CN=Schema, CN=Configuration) \
`repadmin /replicate $srv2 $srv1 DC=domain,DC=local ` выполнить репликацию с $srv1 на $srv2 только указанный раздела домена \
`repadmin /SyncAll /AdeP` запустить межсайтовую исходящую репликацию всех разделов от текущего сервера со всеми партнерами по репликации \
/A # выполнить для всех разделов NC \
/d # в сообщениях идентифицировать серверы по DN (вместо GUID DNS - глобальным уникальным идентификаторам) \
/e # межсайтовая синхронизация (по умолчанию синхронизирует только с DC текущего сайта) \
/P # извещать об изменениях с этого сервера (по умолчанию: опрашивать об изменениях) \
`repadmin /Queue $srv` отображает кол-во запросов входящей репликации (очередь), которое необходимо обработать (причиной может быть большое кол-во партнеров или формирование 1000 объектов скриптом) \
`repadmin /showbackup *` узнать дату последнего Backup

Error: 1722 - сервер rpc недоступен (ошибка отката репликации). Проверить имя домена в настройках сетевого адаптера, первым должен идти адрес DNS-сервера другого контроллера домена, вторым свой адрес. \
`Get-Service -ComputerName $srv | select name,status | ? name -like "RpcSs"` \
`Get-Service -ComputerName $srv -Name RpcSs -RequiredServices` зависимые службы \
Зависимые службы RPC: \
"Служба сведений о подключенных сетях" - должен быть включен отложенный запуск. Если служба срабатывает до "службы списка сетей", может падать связь с доменом (netlogon) \
"Центр распространения ключей Kerberos" \
"DNS-сервер" \
`nslookup $srv` \
`tnc $srv -p 135` \
`repadmin /retry` повторить попытку привязки к целевому DC, если была ошибка 1722 или 1753 (RPC недоступен)

`repadmin /showrepl $srv` \
`Last attempt @ 2022-07-15 10:46:01 завершена с ошибкой, результат 8456 (0x2108)` при проверки showrepl этого партнера, его ошибка: 8457 (0x2109) \
`Last success @ 2022-07-11 02:29:46` последний успех \
Когда репликация автоматически отключена, ОС записывает в DSA - not writable одно из четырех значений: \
`Path: HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NTDS\Parameters` \
`Dsa Not Writable` \
`#define DSA_WRITABLE_GEN 1` версия леса несовместима с ОС \
`#define DSA_WRITABLE_NO_SPACE 2` на диске, где размещена база данных Active Directory или файлы журналов (логи), недостаточно свободного места \
`#define DSA_WRITABLE_USNROLLBCK 4` откат USN произошел из-за неправильного отката базы данных Active Directory во времени (восстановление из снапшота) \
`#define DSA_WRITABLE_CORRUPT_UTDV 8` вектор актуальности поврежден на локальном контроллере домена

`dcdiag /Test:replications /s:dc-01` отображает ошибки репликации \
`dcdiag /Test:DNS /e /v /q` тест DNS \
`/a` проверка всех серверов данного сайта \
`/e` проверка всех серверов предприятия \
`/q` выводить только сообщения об ошибках \
`/v` выводить подробную информацию \
`/fix` автоматически исправляет ошибки \
`/test:` \
`Connectivity` проверяет регистрацию DC в DNS, выполняет тестовые LDAP и RPC подключения \
`NetLogons` проверка наличие прав на выполнение репликации \
`Services` проверяет, запущены ли на контроллере домена необходимые службы \
`Systemlog` проверяет наличие ошибок в журналах DC \
`FRSEvent` проверяет наличие ошибок в службе репликации файлов (ошибки репликации SYSVOL) \
`FSMOCheck` проверяет, что DC может подключиться к KDC, PDC, серверу глобального каталога \
`KnowsOfRoleHolders` проверяет доступность контроллеров домена с ролями FSMO \
`MachineAccount` проверяет корректность регистрации учетной записи DC в AD, корректность доверительных отношения с доменом

### ntdsutil

Перенос БД AD (ntds.dit): \
`Get-Acl C:\Windows\NTDS | Set-Acl D:\AD-DB` скопировать NTFS разрешения на новый каталог \
`Stop-Service -ComputerName uk-dc -name NTDS` остановить службу Active Directory Domain Services \
`ntdsutil` запустить утилиту ntdsutil \
`activate instance NTDS` выбрать активный экземпляр базы AD \
`files` перейдем в контекст files, в котором возможно выполнение операция с файлами базы ntds.dit \
`move DB to D:\AD-DB\` перенести базу AD в новый каталог (предварительно нужно его создать) \
`info` проверить, что БД находится в новом каталоге \
`move logs to D:\AD-DB\` переместим в тот же каталог файлы с журналами транзакций \
`quit` \
`Start-Service -ComputerName uk-dc -name NTDS`

Сброс пароля DSRM (режим восстановления служб каталогов):  \
`ntdsutil` \
`set dsrm password` \
`reset password on server NULL` \
новый пароль \
подтверждение пароля \
`quit` \
`quit`

Синхронизировать с паролем УЗ в AD: \
`ntdsutil` \
`set dsrm password` \
`sync from domain account dsrmadmin` \
`quit` \
`quit`

Ошибка 0x00002e2 при загрузке ОС. \
Загрузиться в режиме восстанавления WinRE (Windows Recovery Environment) - Startup Settings - Restart - DSRM (Directory Services Restore Mode) \
`reagentc /boottore # shutdown /f /r /o /t 0` перезагрузка в режиме WinRE - ОС на базе WinPE (Windows Preinstallation Environment), образ winre.wim находится на скрытом разделе System Restore \
На контроллере домена единственная локальная учетная запись — администратор DSRM. Пароль создается при установке роли контроллера домена ADDS на сервере (SafeModeAdministratorPassword). \
`ntdsutil` \
`activate instance ntds` \
`Files` \
`Info` \
`integrity` проверить целостность БД \
Ошибка: Failed to open DIT for AD DS/LDS instance NTDS. Error -2147418113 \
`mkdir c:\ntds_bak` \
`xcopy c:\Windows\NTDS\*.* c:\ntds_bak` backup содержимого каталога с БД \
`esentutl /g c:\windows\ntds\ntds.dit` проверим целостность файла \
Вывод: Integrity check completed. Database is CORRUPTED # ошибка, база AD повреждена \
`esentutl /p c:\windows\ntds\ntds.dit` исправить ошибки \
Вывод: Operation completed successfully in xx seconds. # нет ошибок \
`esentutl /g c:\windows\ntds\ntds.dit` проверим целостность файла \
Выполнить анализ семантики базы с помощью ntdsutil: \
`ntdsutil` \
`activate instance ntds` \
`semantic database analysis` \
`go` \
`go fixup` исправить семантические ошибки \
Сжать файл БД: \
`activate instance ntds` \
`files` \
`compact to C:\Windows\NTDS\TEMP` \
`copy C:\Windows\NTDS\TEMP\ntds.dit C:\Windows\NTDS\ntds.dit` заменить оригинальный файл ntds.dit \
`Del C:\Windows\NTDS\*.log` удалить все лог файлы из каталога NTDS

# ServerManager

`Get-Command *WindowsFeature*` source module ServerManager \
`Get-WindowsFeature -ComputerName "localhost"` \
`Get-WindowsFeature | where Installed -eq $True` список установленных ролей и компонентов \
`Get-WindowsFeature | where FeatureType -eq "Role"` отсортировать по списку ролей \
`Install-WindowsFeature -Name DNS` установить роль \
`Get-Command *DNS*` \
`Get-DnsServerSetting -ALL` \
`Uninstall-WindowsFeature -Name DNS`

### WSB (Windows Server Backup)
При создании backup DC через WSB, создается копия состояния системы (System State), куда попадает база AD (NTDS.DIT), объекты групповых политик, содержимое каталога SYSVOL, реестр, метаданные IIS, база AD CS, и другие системные файлы и ресурсы. Резервная копия создается через службу теневого копирования VSS. \
`Get-WindowsFeature Windows-Server-Backup` проверить установлена ли роль \
`Add-Windowsfeature Windows-Server-Backup –Includeallsubfeature` установить роль

`$path="\\$srv\bak-dc\dc-03\"` \
`[string]$TargetUNC=$path+(get-date -f 'yyyy-MM-dd')` \
`if ((Test-Path -Path $path) -eq $true) {New-Item -Path $TargetUNC -ItemType directory} # если путь доступен, создать новую директорию по дате` \
`$WBadmin_cmd = "wbadmin.exe START BACKUP -backupTarget:$TargetUNC -systemState -noverify -vssCopy -quiet" \
`# $WBadmin_cmd = "wbadmin start backup -backuptarget:$path -include:C:\Windows\NTDS\ntds.dit -quiet" # Backup DB NTDS` \
`Invoke-Expression $WBadmin_cmd`

### DNS
`$zone = icm $srv {Get-DnsServerZone} | select ZoneName,ZoneType,DynamicUpdate,ReplicationScope,SecureSecondaries,` \
`DirectoryPartitionName | Out-GridView -Title "DNS Server: $srv" –PassThru` \
`$zone_name = $zone.ZoneName` \
`if ($zone_name -ne $null) {` \
`icm $srv {Get-DnsServerResourceRecord -ZoneName $using:zone_name | sort RecordType | select RecordType,HostName, @{` \
`Label="IPAddress"; Expression={$_.RecordData.IPv4Address.IPAddressToString}},TimeToLive,Timestamp` \
`} | select RecordType,HostName,IPAddress,TimeToLive,Timestamp | Out-GridView -Title "DNS Server: $srv"` \
`}`

`Sync-DnsServerZone –passthru` синхронизировать зоны с другими DC в домене \
`Remove-DnsServerZone -Name domain.local` удалить зону \
`Get-DnsServerResourceRecord -ZoneName domain.local -RRType A` вывести все А-записи в указанной зоне \
`Add-DnsServerResourceRecordA -Name new-host-name -IPv4Address 192.168.1.100 -ZoneName domain.local -TimeToLive 01:00:00 -CreatePtr` создать А-запись и PTR для нее \
`Remove-DnsServerResourceRecord -ZoneName domain.local -RRType A -Name new-host-name –Force` удалить А-запись

`$DNSServer = "DC-01" \` \
`$DNSFZone = "domain.com"` \
`$DataFile = "C:\Scripts\DNS-Create-A-Records-from-File.csv"` \
`# cat $DataFile` \
`# "HostName;IP"` \
`# "server-01;192.168.1.10"` \
`$DNSRR = [WmiClass]"\\$DNSServer\root\MicrosoftDNS:MicrosoftDNS_ResourceRecord"` \
`$ConvFile = $DataFile + "_unicode"` \
`Get-Content $DataFile | Set-Content $ConvFile -Encoding Unicode` \
`Import-CSV $ConvFile -Delimiter ";" | ForEach-Object {` \
`$FQDN = $_.HostName + "." + $DNSFZone` \
`$IP = $_.HostIP` \
`$TextA = "$FQDN IN A $IP"` \
`[Void]$DNSRR.CreateInstanceFromTextRepresentation($DNSServer,$DNSFZone,$TextA)` \
`}`

### DHCP
`$mac = icm $srv -ScriptBlock {Get-DhcpServerv4Scope | Get-DhcpServerv4Lease} | select AddressState,` \
`HostName,IPAddress,ClientId,DnsRegistration,DnsRR,ScopeId,ServerIP | Out-GridView -Title "HDCP Server: $srv" –PassThru` \
`(New-Object -ComObject Wscript.Shell).Popup($mac.ClientId,0,$mac.HostName,64)`

`Add-DhcpServerv4Reservation -ScopeId 192.168.1.0 -IPAddress 192.168.1.10 -ClientId 00-50-56-C0-00-08 -Description "new reservation"`

### RDS
`Get-Command -Module RemoteDesktop` \
`Get-RDServer -ConnectionBroker $broker` список всех серверов в фермеы, указывается полное доменное имя при обращение к серверу с ролью RDCB \
`Get-RDRemoteDesktop -ConnectionBroker $broker` список коллекций \
`(Get-RDLicenseConfiguration -ConnectionBroker $broker | select *).LicenseServer` список серверов с ролью RDL \
`Get-RDUserSession -ConnectionBroker $broker` список всех активных пользователей \
`Disconnect-RDUser -HostServer $srv -UnifiedSessionID $id -Force` отключить сессию пользователя \
`Get-RDAvailableApp -ConnectionBroker $broker -CollectionName C03` список установленного ПО на серверах в коллекции \
`(Get-RDSessionCollectionConfiguration -ConnectionBroker $broker -CollectionName C03 | select *).CustomRdpProperty` use redirection server name:i:1 \
`Get-RDConnectionBrokerHighAvailability`

### DFSR
`dfsutil /root:\\domain.sys\public /export:C:\export-dfs.txt` экспорт конфигурации namespace root \
`dfsutil /AddFtRoot /Server:\\$srv /Share:public` на новой машине предварительно создать корень на основе домена \
`dfsutil /root:\\domain.sys\public /import:C:\export-dfs.txt /<verify /set` Import (перед импортом данных в существующий корень DFS, утилита создает резервную копию конфигурации корня в текущем каталоге, из которого запускается утилита dfsutil) \
`/verify` выводит изменения, которые будут внесены в процессе импорта, без применения \
`/set` меняет целевое пространство имен путем полной перезаписи и замены на конфигурацию пространства имен из импортируемого файла \
`/merge` импортирует конфигурацию пространства имен в дополнение к существующей конфигурации для слияния, параметры из файла конфигурации будут иметь больший приоритет, чем существующие параметры пространства имен

`Export-DfsrClone` экспортирует клонированную базу данных репликации DFS и параметры конфигурации тома \
`Get-DfsrCloneState` получает состояние операции клонирования базы данных \
`Import-DfsrClone` импортирует клонированную базу данных репликации DFS и параметры конфигурации тома

`net use x: \\$srv1\public\*` примонтировать диск \
`Get-DfsrFileHash x:\* | Out-File C:\$srv1.txt` забрать hash всех файлов диска в файл (файлы с одинаковыми хешами всегда являются точными копиями друг друга) \
`net use x: /d` отмонтировать \
`net use x: \\$srv2\public\*` \
`Get-DfsrFileHash x:\* | Out-File C:\$srv2.txt` \
`net use x: /d` \
`Compare-Object -ReferenceObject (Get-Content C:\$srv1.txt) -DifferenceObject (Get-Content C:\$srv2.txt) -IncludeEqual` сравнить содержимое файлов

`Get-DfsrBacklog -DestinationComputerName "fs-06" -SourceComputerName "fs-05" -GroupName "folder-rep" -FolderName "folder" -Verbose` получает список ожидающих обновлений файлов между двумя партнерами репликации DFS \
`Get-DfsrConnection` отображает группы репликации, участников и статус \
`Get-DfsReplicatedFolder` отображает имя и полный путь к папкам реликации в системе DFS \
`Get-DfsrState -ComputerName fs-06 -Verbose` состояние репликации DFS для члена группы \
`Get-DfsReplicationGroup` отображает группы репликации и их статус \
`Add-DfsrConnection` создает соединение между членами группы репликации \
`Add-DfsrMember` добавляет компьютеры в группу репликации \
`ConvertFrom-DfsrGuid` преобразует идентификаторы GUID в понятные имена в заданной группы репликации \
`Get-DfsrConnectionSchedule` получает расписание соединений между членами группы репликации \
`Get-DfsrGroupSchedule` извлекает расписание группы репликации \
`Get-DfsrIdRecord` получает записи ID для реплицированных файлов или папок из базы данных репликации DFS \
`Get-DfsrMember` получает компьютеры в группе репликации \
`Get-DfsrMembership` получает параметры членства для членов групп репликации \
`Get-DfsrPreservedFiles` получает список файлов и папок, ранее сохраненных репликацией DFS \
`Get-DfsrServiceConfiguration` получает параметры службы репликации DFS для членов группы \
`Grant-DfsrDelegation` предоставляет разрешения участникам безопасности для группы репликации \
`Revoke-DfsrDelegation` отменяет разрешения участников безопасности для группы репликации \
`New-DfsReplicationGroup` создает группу репликации \
`New-DfsReplicatedFolder` создает реплицированную папку в группе репликации \
`Remove-DfsrConnection` удаляет соединение между членами группы репликации \
`Remove-DfsReplicatedFolder` удаляет реплицированную папку из группы репликации \
`Remove-DfsReplicationGroup` удаляет группу репликации \
`Remove-DfsrMember` удаляет компьютеры из группы репликации \
`Restore-DfsrPreservedFiles` восстанавливает файлы и папки, ранее сохраненные репликацией DFS \
`Set-DfsrConnection` изменяет параметры соединения между членами группы репликации \
`Set-DfsrConnectionSchedule` изменяет параметры расписания соединений между членами группы репликации \
`Set-DfsReplicatedFolder` изменяет настройки реплицированной папки \
`Set-DfsReplicationGroup` изменяет группу репликации \
`Set-DfsrGroupSchedule` изменяет расписание группы репликации \
`Set-DfsrMember` изменяет информацию о компьютере-участнике в группе репликации \
`Set-DfsrMembership` настраивает параметры членства для членов группы репликации \
`Set-DfsrServiceConfiguration` изменяет параметры службы репликации DFS \
`Sync-DfsReplicationGroup` синхронизирует репликацию между компьютерами независимо от расписания \
`Suspend-DfsReplicationGroup` приостанавливает репликацию между компьютерами независимо от расписания \
`Update-DfsrConfigurationFromAD` инициирует обновление службы репликации DFS \
`Write-DfsrHealthReport` создает отчет о работоспособности репликации DFS \
`Write-DfsrPropagationReport` создает отчеты для тестовых файлов распространения в группе репликации \
`Start-DfsrPropagationTest` создает тестовый файл распространения в реплицированной папке

# PackageManagement

`Get-Package -ProviderName msi,Programs` список установленных программ
`[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12` включить использование протокол TLS 1.2 (если не отключены протоколы TLS 1.0 и 1.1) \
`Find-PackageProvider` поиск провайдеров \
`Install-PackageProvider PSGallery -force` установить источник \
`Install-PackageProvider Chocolatey -force` \
`Install-PackageProvider NuGet -force` \
`Get-PackageSource` источники установки пакетов \
`Set-PackageSource -Name PSGallery -Trusted` по умолчанию \
`Find-Package -Name *Veeam* -Source PSGallery` поиск пакетов с указанием источника \
`Install-Package -Name VeeamLogParser -ProviderName PSGallery -scope CurrentUser` \
`Get-Command *Veeam*` \
`Import-Module -Name VeeamLogParser` загрузить модуль \
`Get-Module VeeamLogParser | select -ExpandProperty ExportedCommands` отобразить список функций

### PS2EXE
`Install-Module ps2exe -Repository PSGallery` \
`Get-Module -ListAvailable` список всех модулей \
`-noConsole` использовать GUI, без окна консоли powershell \
`-noOutput` выполнение в фоне \
`-noError` без вывода ошибок \
`-requireAdmin` при запуске запросить права администратора \
`-credentialGUI` вывод диалогового окна для ввода учетных данных \
`Invoke-ps2exe -inputFile "$home\Desktop\WinEvent-Viewer-1.1.ps1" -outputFile "$home\Desktop\WEV-1.1.exe" -iconFile "$home\Desktop\log_48px.ico" -title "WinEvent-Viewer" -noConsole -noOutput -noError`

### NSSM
`$powershell_Path = (Get-Command powershell).Source` \
`$NSSM_Path = (Get-Command "C:\WinPerf-Agent\NSSM-2.24.exe").Source` \
`$Script_Path = "C:\WinPerf-Agent\WinPerf-Agent-1.1.ps1"` \
`$Service_Name = "WinPerf-Agent"` \
`& $NSSM_Path install $Service_Name $powershell_Path -ExecutionPolicy Bypass -NoProfile -f $Script_Path` создать Service \
`& $NSSM_Path start $Service_Name` запустить \
`& $NSSM_Path status $Service_Name` статус \
`$Service_Name | Restart-Service` перезапустить \
`$Service_Name | Get-Service` статус \
`$Service_Name | Stop-Service` остановить \
`& $NSSM_Path set $Service_Name description "Check performance CPU and report email"` изменить описание \
`& $NSSM_Path remove $Service_Name` удалить

### ThreadJob
`Install-Module -Name ThreadJob` \
`Get-Module ThreadJob -list` \
`(Start-ThreadJob {ping ya.ru}) | Out-Null` создать фоновую задачу \
`while ($True){` \
`$status = @((Get-Job).State)[-1]` отобразить статус последней [-1] фоновой задачи \
`if ($status -like "Completed"){` если Completed \
`Get-Job | Receive-Job` отобразить вывод, после каждого запроса результат удаляется (Get-Job).HasMoreData -eq $False \
`Get-Job | Remove-Job -Force` удалить все задачи \
`break` остановить цикл \
`}}` \
`Get-Job | Receive-Job -Keep` отобразить и не удалять вывод (-Keep) \
`(Get-Job).Information` отобразить результат всех заданий

# PowerCLI

`Install-Module -Name VMware.PowerCLI # -AllowClobber` установить модуль (PackageProvider: nuget) \
`Get-Module -ListAvailable VMware* | Select Name,Version` \
`Import-Module VMware.VimAutomation.Core` импортировать в сессию \
`Get-PSProvider | format-list Name,PSSnapIn,ModuleName` список оснасток Windows PowerShell

`Get-PowerCLIConfiguration` конфигурация подключения \
`Set-PowerCLIConfiguration -Scope AllUsers -InvalidCertificateAction ignore -confirm:$false` eсли используется самоподписанный сертификат, изменить значение параметра InvalidCertificateAction с Unset на Ignore/Warn \
`Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCeip $false` отключить уведомление сбора данных через VMware Customer Experience Improvement Program (CEIP)

`Read-Host –AsSecureString | ConvertFrom-SecureString | Out-File "$home\Documents\vcsa_password.txt"` зашифровать пароль и сохранить в файл \
`$esxi = "vcsa.domain.local"` \
`$user = "administrator@vsphere.local"` \
`$pass = Get-Content "$home\Documents\vcsa_password.txt" | ConvertTo-SecureString` прочитать пароль \
`$pass = "password"` \
`$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user ,$pass` \
`Connect-VIServer $esxi -User $Cred.Username -Password $Cred.GetNetworkCredential().password` подключиться, используя PSCredential ($Cred) \
`Connect-VIServer $esxi -User $user -Password $pass` подключиться, используя логин и пароль

`Get-Command –Module *vmware*` \
`Get-Command –Module *vmware* -name *get*iscsi*` \
`Get-IScsiHbaTarget` \
`Get-Datacenter` \
`Get-Cluster` \
`Get-VMHost` \
`Get-VMHost | select Name,Model,ProcessorType,MaxEVCMode,NumCpu,CpuTotalMhz,CpuUsageMhz,MemoryTotalGB,MemoryUsageGB` \
`Get-VMHostDisk | select VMHost,ScsiLun,TotalSectors`

`Get-Datastore` \
`Get-Datastore TNAS-vmfs-4tb-01` \
`Get-Datastore TNAS-vmfs-4tb-01 | get-vm` \
`Get-Datastore -RelatedObject vm-01` \
`(Get-Datastore TNAS-vmfs-4tb-01).ExtensionData.Info.GetType()` \
`(Get-Datastore TNAS-vmfs-4tb-01).ExtensionData.Info.Vmfs.Extent`

`Get-Command –Module *vmware* -name *disk*` \
`Get-VM vm-01 | Get-Datastore` \
`Get-VM vm-01 | Get-HardDisk` \
`Get-VM | Get-HardDisk | select Parent,Name,CapacityGB,StorageFormat,FileName | ft` \
`Copy-HardDisk` \
`Get-VM | Get-Snapshot` \
`Get-VM | where {$_.Powerstate -eq "PoweredOn"}` \
`Get-VMHost esxi-05 | Get-VM | where {$_.Powerstate -eq "PoweredOff"} | Move-VM –Destination (Get-VMHost esxi-06)`

`Get-VM | select Name,VMHost,PowerState,NumCpu,MemoryGB,` \
`@{Name="UsedSpaceGB"; Expression={[int32]($_.UsedSpaceGB)}},@{Name="ProvisionedSpaceGB"; Expression={[int32]($_.ProvisionedSpaceGB)}},` \
`CreateDate,CpuHotAddEnabled,MemoryHotAddEnabled,CpuHotRemoveEnabled,Notes`

`Get-VMGuest vm-01 | Update-Tools` \
`Get-VMGuest vm-01 | select OSFullName,IPAddress,HostName,State,Disks,Nics,ToolsVersion` \
`Get-VMGuest * | select -ExpandProperty IPAddress` \
`Restart-VMGuest -vm vm-01 -Confirm:$False` \
`Start-VM -vm vm-01 -Confirm:$False` \
`Shutdown-VMGuest -vm vm-01 -Confirm:$false`

`New-VM –Name vm-01 -VMHost esxi-06 –ResourcePool Production –DiskGB 60 –DiskStorageFormat Thin –Datastore TNAS-vmfs-4tb-01` \
`Get-VM vm-01 | Copy-VMGuestFile -Source "\\$srv\Install\Soft\Btest.exe" -Destination "C:\Install\" -LocalToGuest -GuestUser USER -GuestPassword PASS -force`

`Get-VM -name vm-01 | Export-VApp -Destination C:\Install -Format OVF` Export template (.ovf, .vmdk, .mf) \
`Get-VM -name vm-01 | Export-VApp -Destination C:\Install -Format OVA`

`Get-VMHostNetworkAdapter | select VMHost,Name,Mac,IP,@{Label="Port Group"; Expression={$_.ExtensionData.Portgroup}} | ft` \
`Get-VM | Get-NetworkAdapter | select Parent,Name,Id,Type,MacAddress,ConnectionState,WakeOnLanEnabled | ft`

`Get-Command –Module *vmware* -name *event*` \
`Get-VIEvent -MaxSamples 1000 | where {($_.FullFormattedMessage -match "power")} | select username,CreatedTime,FullFormattedMessage` \
`Get-logtype | select Key,SourceEntityId,Filename,Creator,Info` \
`(Get-Log vpxd:vpxd.log).Entries | select -Last 50`

`Get-Command –Module *vmware* -name *syslog*` \
`Set-VMHostSysLogServer -VMHost esxi-05 -SysLogServer "tcp://192.168.3.100" -SysLogServerPort 3515` \
`Get-VMHostSysLogServer -VMHost esxi-05`

# EMShell

`$srv_cas = "exchange-cas"` \
`$session_exchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$srv_cas/PowerShell/ # -Credential $Cred -Authentication Kerberos` \
`Get-PSSession` \
`Import-PSSession $session_exchange -DisableNameChecking` импортировать в текущую сессию

`Get-ExchangeServer | select name,serverrole,admindisplayversion,Edition,OriginatingServer,WhenCreated,WhenChanged,DataPath | ft` список всех серверов

`Get-ImapSettings` настройки IMAP \
`Get-ExchangeCertificate` список сертификатов \
`Get-ExchangeCertificate -Thumbprint "5CEC8544D4743BC279E5FEA1679F79F5BD0C2B3A" | Enable-ExchangeCertificate -Services  IMAP, POP, IIS, SMTP` \
`iisreset` \
`Get-ClientAccessService | fl identity, *uri*` настройки службы автообнаружения в Exchange 2016 \
`Get-ClientAccessService -Identity $srv | Set-ClientAccessService -AutoDiscoverServiceInternalUri https://mail.domain.ru/Autodiscover/Autodiscover.xml` изменить на внешний адрес \
`Get-OutlookAnywhere` OA позволяет клиентам Outlook подключаться к своим почтовым ящикам за пределами локальной сети (без использования VPN) \
`Get-WebServicesVirtualDirectory` \
`Get-OwaVirtualDirectory` \
`Get-ActiveSyncVirtualDirectory` \
`Get-OabVirtualDirectory` виртуальная директория автономной адресной книги \
`Get-OabVirtualDirectory -Server $srv | Set-OabVirtualDirectory -InternalUrl "https://mail.domain.ru/OAB" -ExternalUrl "https://mail.domain.ru/OAB"`

### Roles
MS (Mailbox) - сервер с БД почтовых ящиков и общих папок, отвечает только за их размещение и не выполняет маршрутизацию никаких сообщений. \
CAS (Client Access Server) - обработка клиентских подключений к почтовым ящикам, которые создаются клиентами Outlook Web Access (HTTP для Outlook Web App), Outlook Anywhere, ActiveSync (для мобильных устройств), интернет протоколы POP3 и IMAP4, MAPI для клиентов Microsoft Outlook. \
Hub Transort - ответвечает за маршрутизацию сообщений интернета и инфраструктурой Exchange, а также между серверами Exchange. Сообщения всегда маршрутизируются с помощью роли транспортного сервера-концентратора, даже если почтовые ящики источника и назначения находятся в одной базе данных почтовых ящиков. \
Relay - роль пограничного транспортного сервера (шлюз SMTP в периметре сети).

SCP (Service Connection Point) - запись прописывается в AD, при создание сервера CAS. Outlook запрашивает SCP, выбирает те, которые находятся в одном сайте с ним и по параметру WhenCreated – по дате создания, выбирая самый старый. \
Autodiscover. Outlook выбирает в качестве сервера Client Access тот, который прописан в атрибуте RPCClientAccessServer базы данных пользователя. Сведения о базе данных и сервере mailbox, на котором она лежит, берутся из AD.

### MessageTrackingLog
`Get-MessageTrackingLog -ResultSize Unlimited | select Timestamp,Sender,Recipients,RecipientCount,MessageSubject,Source,EventID,ClientHostname,ServerHostname,ConnectorId, @{Name="MessageSize"; Expression={[string]([int]($_.TotalBytes / 1024))+" KB"}},@{Name="MessageLatency"; Expression={$_.MessageLatency -replace "\.\d+$"}}` \
`Get-MessageTrackingLog -Start (Get-Date).AddHours(-24) -ResultSize Unlimited | where {[string]$_.recipients -like "*@yandex.ru"}` вывести сообщения за последние 24 часа, где получателем был указанный домен \
-Start "04/01/2023 09:00:00" -End "04/01/2023 18:00:00" - поиск по указанному промежутку времени \
-MessageSubject "Тест" - поиск по теме письма \
-Recipients "support4@domain.ru" - поиск по получателю \
-Sender - поиск по отправителю \
-EventID – поиск по коду события сервера (RECEIVE, SEND, FAIL, DSN, DELIVER, BADMAIL, RESOLVE, EXPAND, REDIRECT, TRANSFER, SUBMIT, POISONMESSAGE, DEFER) \
-Server – поиск на определенном транспортном сервере \
-messageID – трекинг письма по его ID

### Mailbox
`Get-Mailbox -Database "it2"` список почтовых серверов в базе данных \
`Get-Mailbox -resultsize unlimited | ? Emailaddresses -like "support4" | format-list name,emailaddresses,database,servername` какую БД, сервер и smtp-адреса использует почтовый ящик \
`Get-Mailbox -Database $db_name -Archive` отобразить архивные почтовые ящики

`Get-MailboxFolderStatistics -Identity "support4" -FolderScope All | select Name,ItemsInFolder,FolderSize` отобразить кол-во писем и размер в каждой папке \
`Get-MailboxStatistics "support4" | select DisplayName,LastLoggedOnUserAccount,LastLogonTime,LastLogoffTime,ItemCount,TotalItemSize,DeletedItemCount,TotalDeletedItemSize,Database,ServerName` общее кол-во писем, их размер, время последнего входа и выхода, имя сервера и БД \
`Get-Mailbox -Server s2 | Get-MailboxStatistics | where {$_.Lastlogontime -lt (get-date).AddDays(-30)} | Sort Lastlogontime -desc | ft displayname,Lastlogontime,totalitemsize` ящики, которые не использовались 30 и более дней

`Enable-Mailbox -Identity support9 -Database test_base` создать почтовый ящик для существующего пользователя в AD \
`New-Mailbox -Name $login -UserPrincipalName "$login@$domain" -Database $select_db -OrganizationalUnit $path -Password (ConvertTo-SecureString -String "$password" -AsPlainText -Force)` создать новый почтовый ящик без привязки к пользователю AD \
`Get-MailboxDatabase -Database $db_name | Remove-MailboxDatabase` удалить БД

`Set-MailBox "support4" -PrimarySmtpAddress support24@domain.ru -EmailAddressPolicyEnabled $false` добавить и изменить основной SMTP-адрес электронной почты для пользователя \
`Set-Mailbox -Identity "support4" -DeliverToMailboxAndForward $true -ForwardingSMTPAddress "username@outlook.com"` включить переадресацию почты (электронная почта попадает в почтовый ящик пользователя support4 и одновременно пересылается по адресу username@outlook.com)

### MoveRequest
`Get-Mailbox -Database $db_in | New-MoveRequest -TargetDatabase $db_out` переместить все почтовые ящики из одной БД в другую \
`New-MoveRequest -Identity $db_in -TargetDatabase $db_out` переместить один почтовый ящик \
`Get-MoveRequest | Suspend-MoveRequest` остановить запросы перемещения \
`Get-MoveRequest | Remove-MoveRequest` удалить запросы на перемещение \
`Get-MoveRequest | Get-MoveRequestStatistics` статус перемещения

Status: \
Cleanup - нужно подождать \
Queued - в очереди \
InProgress - в процессе \
Percent Complete - процент выполнения \
CompletionInProgress - завершение процесса \
Completed - завершено

`Remove-MoveRequest -Identity $db_name` завершить процесс перемещения (убрать статус перемещения с почтового ящика и очистить список перемещений) \
`Get-MailboxDatabase | Select Name, MailboxRetention` после перемещения ящиков, размер базы не изменится, полное удаление из базы произойдет, как пройдет количество дней, выставленное в параметре MailboxRetention \
`Set-MailboxDatabase -MailboxRetention '0.00:00:00' -Identity $db_name` изменить значение

### Archive
`Enable-Mailbox -Identity $name -Archive` включить архив для пользователя \
`Get-Mailbox $name | New-MoveReques –ArchiveOnly –ArchiveTargetDatabase DBArch` переместить архивный почтовый ящик в другую БД \
`Get-Mailbox $name | fl Name,Database,ArchiveDatabase` место расположения БД пользователя и БД его архива \
`Disable-Mailbox -Identity $name -Archive` отключить архив \
`Connect-Mailbox -Identity "8734c04e-981e-4ccf-a547-1c1ac7ebf3e2" -Archive -User $name -Database it2` подключение архива пользователя к указанному почтовому ящику \
`Get-Mailbox $name | Set-Mailbox -ArchiveQuota 20GB -ArchiveWarningQuota 19GB` настроить квоты хранения архива

### Quota
`Get-Mailbox -Identity $mailbox | fl IssueWarningQuota, ProhibitSendQuota, ProhibitSendReceiveQuota, UseDatabaseQuotaDefaults` отобразить квоты почтового ящика \
IssueWarningQuota — квота, при достижении которой Exchange отправит уведомление \
ProhibitSendQuota — при достижении будет запрещена отправка \
ProhibitSendReceiveQuota — при достижении будет запрещена отправка и получение \
UseDatabaseQuotaDefaults — используется ли квота БД или false - индвидиуальные \
`Set-Mailbox -Identity $mailbox -UseDatabaseQuotaDefaults $false -IssueWarningQuota "3 GB" -ProhibitSendQuota "4 GB" -ProhibitSendReceiveQuota "5 GB"` задать квоту для пользователя

`Get-MailboxDatabase $db_name | fl Name, *Quota` отобразить квоты наложенные на БД \
`Set-MailboxDatabase $db -ProhibitSendReceiveQuota "5 GB" -ProhibitSendQuota "4 GB" -IssueWarningQuota "3 GB"` настроить квоты на БД

### Database
`Get-MailboxDatabase -Status | select ServerName,Name,DatabaseSize` список и размер всех БД на всех MX-серверах \
`New-MailboxDatabase -Name it_2022 -EdbFilePath E:\Bases\it_2022\it_2022.edb -LogFolderPath G:\Logs\it_2022 -OfflineAddressBook "Default Offline Address List" -server exch-mx-01` создать БД \
`Restart-Service MSExchangeIS` \
`Get-Service | Where {$_ -match "exchange"} | Restart-Service` \
`Get-MailboxDatabase -Server exch-01` список баз данных на MX-сервере \
`New-MoveRequest -Identity "support4" -TargetDatabase it_2022` переместить почтовый ящик в новую БД \
`Move-Databasepath $db_name –EdbFilepath "F:\DB\$db_name\$db_name.edb" –LogFolderpath "E:\DB\$db_name\logs\"` переместить БД и транзакционные логи на другой диск \
`Set-MailboxDatabase -CircularLoggingEnabled $true -Identity $db_name` включить циклическое ведение журнала (Circular Logging), где последовательно пишутся 4 файла логов по 5 МБ, после чего первый лог-файл перезаписывается \
`Set-MailboxDatabase -CircularLoggingEnabled $false -Identity $db_name` отключить циклическое ведение журнала \
`Get-MailboxDatabase -Server "ukh-exch-mx-01" -Status | select EdbFilePath,LogFolderPath,LogFilePrefix` путь к БД, логам, имя текущего актуального лог-файла

### MailboxRepairRequest
`New-MailboxRepairRequest -Database it2 -CorruptionType ProvisionedFolder, SearchFolder, AggregateCounts, Folderview` запустить последовательный тест (в конкретный момент времени не доступен один почтовый ящик) и исправление ошибок на прикладном уровне \
`Get-MailboxRepairRequest -Database it2` прогресс выполнения \
Позволяет исправить: \
ProvisionedFolder – нарушения логической структуры папок \
SearchFolder – ошибки в папках поиска \
AggregateCounts – проверка и исправление информации о количестве элементов в папках и их размере \
FolderView – неверное содержимое, отображаемое представлениями папок

### eseutil
При отправке/получении любого письма Exchange сначала вносит информацию в транзакционный лог, и только потом сохраняет элемент непосредственно в базу данных. Размер одного лог файла - 1 Мб. Есть три способа урезания логов: DAG, Backup на базе Volume Shadow Copy, Circular Logging.

Ручное удаление журналов транзакций: \
`cd E:\MS_Exchange_2010\MailBox\Reg_v1_MailBoxes\` перейти в каталог с логами \
`ls E*.chk` узнать имя файла, в котором находится информация из контрольной точки фиксации журналов \
`eseutil /mk .\E18.chk` узнать последний файл журнала, действия из которого были занесены в БД Exchange \
`Checkpoint: (0x561299,8,16)` 561299 имя файла, который был последним зафиксирован (его информация уже в базе данных) \
Находим в проводнике файл E0500561299.txt, можно удалять все файлы журналов, которые старше найденного файла

Восстановление БД (если две копии БД с ошибкой): \
`Get-MailboxDatabaseCopyStatus -Identity db_name\* | Format-List Name,Status,ContentIndexState` \
Status            : FailedAndSuspended \
ContentIndexState : Failed \
Status            : Dismounted \
ContentIndexState : Failed

`Get-MailboxDatabase -Server ukh-exch-mx-01 -Status | fl Name,EdbFilePath,LogFolderPath` проверить расположение базы и транзакционных логов \
LogFolderPath - директория логов \
E18 - имя транкзакционного лога (из него читаются остальные логи) \
`dismount-Database db_name` отмантировать БД \
`eseutil /mh D:\MS_Exchange_2010\Mailbox\db_name\db_name.edb` проверить базу \
State: Dirty Shutdown - несогласованное состояние, означает, что часть транзакций не перенесена в базу, например, после того, как была осуществлена аварийная перезагрузка сервера. \
`eseutil /ml E:\MS_Exchange_2010\MailBox\db_name\E18` проверка целостности транзакционных логи, если есть логи транзакций и они не испорчены, то можно восстановить из них, из файла E18 считываются все логи, должен быть статус - ОК

Soft Recovery (мягкое восстановление) - необходимо перевести базу в состояние корректного отключения (Clear shutdown) путем записи недостающих файлов журналов транзакций в БД. \
`eseutil /R E18 /l E:\MS_Exchange_2010\MailBox\db_name\ /d D:\MS_Exchange_2010\Mailbox\db_name\db_name.edb` \
`eseutil /R E18 /a /i /l E:\MS_Exchange_2010\MailBox\db_name\ /d D:\MS_Exchange_2010\Mailbox\db_name\db_name.edb` если с логами что-то не так, можно попробовать восстановить базу игнорируя ошибку в логах \
`eseutil /mk D:\MS_Exchange_2010\Mailbox\db_name\db_name.edb` cостоянии файла контрольных точек \
`eseutil /g D:\MS_Exchange_2010\Mailbox\db_name\db_name.edb` проверка целостности БД \
`eseutil /k D:\MS_Exchange_2010\Mailbox\db_name\db_name.edb` проверка контрольных сумм базы (CRC)

Hard Recovery - если логи содержат ошибки и база не восстанавливается, то восстанавливаем базу без логов. \
`eseutil /p D:\MS_Exchange_2010\Mailbox\db_name\db_name.edb` \
/p - удалит поврежденные страницы, эта информация будет удалена из БД и восстановит целостность \
`esetuil /d D:\MS_Exchange_2010\Mailbox\db_name\db_name.edb` выполнить дефрагментацию (если был потерян большой объем данных, то может сильно снизиться производительность) \
После выполнения команд необходимо вручную удалить все файлы с расширением log в папке MDBDATA, перед попыткой смонтировать базу данных. \
`isinteg -s "db_name.edb" -test alltests` проверьте целостность базы данных \
`isinteg -s "server_name" -fix -test -alltests` если проверка будет провалена. Выполнять команду до тех пор, пока у всех ошибок не станет статус 0 или статус не перестанет меняться, иногда необходимо 3 прохода для достижения результата. \
`eseutil /mh D:\MS_Exchange_2010\Mailbox\db_name\db_name.edb | Select-String -Pattern "State:","Log Required:"` проверить статус \
State: Clear shutdown - успешный статус \
`Log Required` требуются ли файлы журналов, необходимые базе, чтобы перейти в согласованное состояние. Если база размонтирована корректно, то это значение будет равняться 0. \
`mount-Database -force db_name` примонтировать БД \
`Get-MailboxDatabase –Status db_name | fl Mounted` статус БД \
`New-MailboxRepairRequest -Database db_name -CorruptionType SearchFolder,AggregateCounts,ProvisionedFolder,FolderView` восстановление логической целостности данных \
После этого восстановить Index. \
Если индексы не восстанавливаются, но БД монтируется, то перенести почтовые ящики в новую БД.

Восстановление БД из Backup:

1-й вариант:
1. Отмантировать текущую БД и удалить или переименовать директорию с файлами текущей БД.
3. Восстановить в ту же директорию из Backup базу с логами.
4. Запустить мягкое восстановление БД (Soft Recovery).
5. Примониторвать.

2-й вариант:
1. Отмантировать и удалить текущую БД.
2. Восстановить БД с логами из Backup в любое место.
3. Запустить мягкое восстановление БД (Soft Recovery).
4. Создать новую БД.
5. Создать Recovery Database и смонтировать в нее восстановленную из бэкапа БД, скопировать из неё почтовые ящики в новую БД и переключить на них пользователей.
6. Если использовать Dial Tone Recovery, то так же перенести из временной БД промежуточные данные почтовых ящиков.

3-й вариант:
1. Восстановить целостность Soft Repair или Hard Recovery.
2. Создать новую БД. Указывать в свойствах: «база может быть перезаписана при восстановлении».
3. Если база была только что оздана и еще не была подмонтирована, то эта папка будет пуста, туда перемещаем базу из Backup, которая была обработана ESEUTIL вместе со всеми файлами. Указать имя .edb такое же, которое было при создании новой базы.
4. Монтируем базу.
5. Перенацеливаем ящики со старой (Mailbox_DB_02), неисправной базы, на новую базу (Mailbox_DB_02_02):
`Get-Mailbox -Database Mailbox_DB_02 | where {$_.ObjectClass -NotMatch '(SystemAttendantMailbox|ExOleDbSystemMailbox)'} | Set-Mailbox -Database Mailbox_DB_02_02`
6. Восстановление логической целостности данных:
`New-MailboxRepairRequest -Database "Mailbox_DB_02_02" -CorruptionType ProvisionedFolder, SearchFolder, AggregateCounts, Folderview`

### Dial Tone Recovery
`Get-Mailbox -Database "MailboxDB" | Set-Mailbox -Database "TempDB"` перенацелить ящики с одной БД (нерабочей) на другую (пустую) \
`Get-Mailbox -Database TempDB` отобразить почтовые ящики в БД TempDB \
`Restart-Service MSExchangeIS` перезапустить службу Mailbox Information Store (банка данных), иначе пользователи будут по-прежнему пытаться подключиться к старой БД \
`iisreset` \
`Get-Mailbox -Database "TempDB" | Set-Mailbox -Database "MailboxDB"` после восстановления старой БД, нужно переключить пользователей с временной БД обратно \
После этого сделать слияние с временной БД с помощью Recovery.

### Recovery database (RDB)
`New-MailboxDatabase –Recovery –Name RecoveryDB –Server $exch_mx –EdbFilePath "D:\TempDB\TempDB.edb" -LogFolderPath "D:\TempDB"` для переноса новых писем из временной БД в основную необходим только сам файл TempDB.edb со статусом Clean Shutdown, из нее необходимо создать служебную БД (ключ -Recovery) \
`Mount-Database "D:\TempDB\TempDB.edb"` примонтировать БД \
`Get-MailboxStatistics -Database RecoveryDB` \
`New-MailboxRestoreRequest –SourceDatabase RecoveryDB –SourceStoreMailbox support –TargetMailbox support` скопировать данные почтового ящика с DisplayName: support из RecoveryDB в почтовый ящик с псевдонимом support существующей базы. По умолчанию ищет в почтовой базе совпадающие LegacyExchangeDN либо проверяет совпадение адреса X500, если нужно восстановить данные в другой ящик, нужно указывать ключ -AllowLegacyDNMisMatch \
`New-MailboxRestoreRequest –SourceDatabase RecoveryDB –SourceStoreMailbox support –TargetMailbox support –TargetRootFolder "Restore"` скопировать письма в отдельную папку в ящике назначения (создается автоматически), возможно восстановить содержимое конкретной папки -IncludeFolders "#Inbox#" \
`Get-MailboxRestoreRequest | Get-MailboxRestoreRequestStatistics` статус запроса восстановления \
`Get-MailboxRestoreRequestStatistics -Identity support` \
`Get-MailboxRestoreRequest -Status Completed | Remove-MailboxRestoreRequest` удалить все успешные запросы

### Transport
`Get-TransportServer $srv_cas | select MaxConcurrentMailboxDeliveries,MaxConcurrentMailboxSubmissions,MaxConnectionRatePerMinute,MaxOutboundConnections,MaxPerDomainOutboundConnections,PickupDirectoryMaxMessagesPerMinute` настройки пропускной способности транспортного сервера \
MaxConcurrentMailboxDeliveries — максимальное количество одновременных потоков, которое может открыть сервер для отправки писем. \
MaxConcurrentMailboxSubmissions — максимальное количество одновременных потоков, которое может открыть сервер для получения писем. \
MaxConnectionRatePerMinute — максимальное возможная скорость открытия входящих соединений в минуту. \
MaxOutboundConnections — максимальное возможное количество соединений, которое может открыть Exchange для отправки. \
MaxPerDomainOutboundConnections — максимальное возможное количество исходящих соединений, которое может открыть Exchange для одного удаленного домена. \
PickupDirectoryMaxMessagesPerMinute — скорость внутренней обработки сообщений в минуту (распределение писем по папкам). \
`Set-TransportServer exchange-cas -MaxConcurrentMailboxDeliveries 21 -MaxConcurrentMailboxSubmissions 21 -MaxConnectionRatePerMinute 1201 -MaxOutboundConnections 1001 -MaxPerDomainOutboundConnections 21 -PickupDirectoryMaxMessagesPerMinute 101` изменить значения

`Get-TransportConfig | select MaxSendSize, MaxReceiveSize` ограничение размера сообщения на уровне траспорта (наименьший приоритет, после коннектора и почтового ящика). \
`New-TransportRule -Name AttachmentLimit -AttachmentSizeOver 15MB -RejectMessageReasonText "Sorry, messages with attachments over 15 MB are not accepted"` создать транспортное правило для проверки размера вложения

### Connector
`Get-ReceiveConnector | select Name,MaxMessageSize,RemoteIPRanges,WhenChanged` ограничения размера сообщения на уровне коннектора (приоритет ниже, чем у почтового ящика) \
`Set-ReceiveConnector ((Get-ReceiveConnector).Identity)[-1] -MaxMessageSize 30Mb` изменить размер у последнего коннектора в списке (приоритет выше, чем у траспорта) \
`Get-Mailbox "support4" | select MaxSendSize, MaxReceiveSize` наивысший приоритет \
`Set-Mailbox "support4" -MaxSendSize 30MB -MaxReceiveSize 30MB` изменить размер

`Set-SendConnector -Identity "ConnectorName" -Port 26` изменить порт коннектора отправки \
`Get-SendConnector "proxmox" | select port`

`Get-ReceiveConnector | select Name,MaxRecipientsPerMessage` по умолчанию Exchange принимает ограниченное количество адресатов в одном письме (200) \
`Set-ReceiveConnector ((Get-ReceiveConnector).Identity)[-1] -MaxRecipientsPerMessage 50` изменить значение \
`Set-ReceiveConnector ((Get-ReceiveConnector).Identity)[-1] -MessageRateLimit 1000` задать лимит обработки сообщений в минуту для коннектора

`Get-OfflineAddressbook | Update-OfflineAddressbook` обновить OAB \
`Get-ClientAccessServer | Update-FileDistributionService`

### PST
`New-MailboxExportRequest -Mailbox $name -filepath "\\$srv\pst\$name.PST" # -ContentFilter {(Received -lt "01/01/2021")} -Priority Highest/Lower # -IsArchive` выполнить экспорт из архива пользователя \
`New-MailboxExportRequest -Mailbox $name -IncludeFolders "#Inbox#" -FilePath "\\$srv\pst\$name.PST"` только папку входящие \
`New-MailboxImportRequest -Mailbox $name "\\$srv\pst\$name.PST"` импорт из PST \
`Get-MailboxExportRequest` статус запросов \
`Get-MailboxExportRequest -Status Completed | Remove-MailboxExportRequest` удалить успешно завершенные запросы \
`Remove-MailboxExportRequest -RequestQueue MBXDB01 -RequestGuid 25e0eaf2-6cc2-4353-b83e-5cb7b72d441f` отменить экспорт

### DistributionGroup
`Get-DistributionGroup` список групп рассылки \
`Get-DistributionGroupMember "!_Офис"` список пользователей в группе \
`Add-DistributionGroupMember -Identity "!_Офис" -Member "$name@$domain"` добавить в группу рассылки \
`Remove-DistributionGroupMember -Identity "!_Офис" -Member "$name@$domain" \
`New-DistributionGroup -Name "!_Тест" -Members "$name@$domain"` создать группу \
`Set-DistributionGroup -Identity "support4" -HiddenFromAddressListsEnabled $true (или Set-Mailbox)` скрыть из списка адресов Exchange

### Search
`Search-Mailbox -Identity "support4" -SearchQuery 'Тема:"Mikrotik DOWN"'` поиск писем по теме \
`Search-Mailbox -Identity "support4" -SearchQuery 'Subject:"Mikrotik DOWN"'`\
`Search-Mailbox -Identity "support4" -SearchQuery 'attachment -like:"*.rar"'`\
`Search-Mailbox -Identity "support4" -SearchQuery "отправлено: < 01/01/2020" -DeleteContent -Force` удаление писем по дате

Формат даты в зависимости от региональных настроек сервера: \
`20/07/2018` \
`07/20/2018` \
`20-Jul-2018` \
`20/July/2018`

### AuditLog
`Get-AdminAuditLogConfig` настройки аудита \
`Set-Mailbox -Identity "support4" -AuditOwner HardDelete` добавить логирование HardDelete писем \
`Set-mailbox -identity "support4" -AuditlogAgelimit 120` указать время хранения \
`Get-mailbox -identity "support4" | Format-list Audit*` данные аудита \
`Search-MailboxAuditLog -Identity "support4" -LogonTypes Delegate -ShowDetails -Start "2022-02-22 18:00" -End "2022-03-22 18:00"` просмотр логов \
`Search-AdminAuditLog -StartDate "02/20/2022" | ft CmdLetName,Caller,RunDate,ObjectModified -Autosize` поиск событий истории выполненых команд в журнале аудита Exchange

### Test
`Test-ServiceHealth` проверить доступность ролей сервера: почтовых ящиков, клиентского доступа, единой системы обмена сообщениями, траспортного сервера \
`$mx_srv_list | %{Test-MapiConnectivity -Server $_}` проверка подключения MX-серверов к БД \
`Test-MAPIConnectivity -Database $db` проверка возможности логина в базу \
`Test-MAPIConnectivity –Identity $user@$domain` проверка возможности логина в почтовый ящик \
`Test-ComputerSecureChannel` проверка работы службы AD \
`Test-MailFlow` результат тестового потока почты

### Queue
`Get-TransportServer | %{Get-Queue -Server $_.Name}` отобразить очереди на всех транспортных серверах \
`Get-Queue -Identity EXCHANGE-CAS\155530 | Format-List` подробная информация об очереди \
`Get-Queue -Identity EXCHANGE-CAS\155530 | Get-Message -ResultSize Unlimited | Select FromAddress,Recipients` отобразить список отправителей (FromAddress) и список получателей в очереди (Recipients) \
`Get-Message -Queue EXCHANGE-CAS\155530` отобразить индентификатор сообщений в конкретной очереди (сервер\очередь\идентификатор письма) \
`Resume-Message EXCHANGE-CAS\155530\444010` повторить отправку письма из очереди \
`Retry-Queue -Filter {Status -eq "Retry"}` принудительно повторить отправку всех сообщений c статусом "Повторить" \
`Get-Queue -Identity EXCHANGE-CAS\155530 | Get-Message -ResultSize unlimited | Remove-Message -WithNDR $False` очистить очередь \
`Get-transportserver EXCHANGE-CAS | Select MessageExpirationTimeout` отобразить время жизни сообщений в очереди (по умолчанию, 2 дня)

Error Exchange 452 4.3.1 Insufficient system resources - окончание свободного места на диске, на котором находятся очереди службы Exchange Hub Transport, за мониторинг отвечает компонент доступных ресурсов Back Pressure, который в том числе отслеживает свободное место на диске \
Порог Medium (90%) — перестать принимать по SMTP почту от внешних отправителей (почта от MAPI клиентов при этом обрабатывается) \
Порог High (99%) — обработка потока почты полностью прекращается \
Решение: очистить, например логи IIS (C:\inetpub\logs\LogFiles\W3SVC1), увеличить размер диска, отключить мониторинг Back Pressure (плохой вариант) или перенести транспортные очередь на другой диск достаточного объёма.

`Get-Service | ? name -like "MSExchangeTransport" | Stop-Service` остановить служу очереди \
`Rename-Item "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\data\Queue" "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\data\Queue_old"` очистить базу очереди \
`C:\Program Files\Microsoft\Exchange Server\V15\Bin\EdgeTransport.exe.config` конфигурационный файл, который содержит путь к бд с очередью (блок <appSettings> ключи <add key="QueueDatabasePath" value="$new_path" /> и QueueDatabaseLoggingPath) \
Для переноса БД, необходимо переместить существующие файлы базы данных Mail.que и Trn.chk (контрольные точки для отслеживания записи в логах) из исходного местоположения в новое. Переместите существующие файлы журнала транзакций Trn.log, Trntmp.log, Trn nnnn.log , Trnres00001.jrs, Trnres00002.jrs и Temp.edb из старого расположения в новое. tmp.edb — временный файл для проверки схемы самой базы, перености не нужно. \
После запуска службы транспорта удалить старую базу данных очереди и файлы журнала транзакций из старого расположения.

### Defrag
`Get-MailboxDatabase -Status | ft Name, DatabaseSize, AvailableNewMailboxSpace` \
DatabaseSize - текущий размер базы \
AvailableNewMailboxSpace - объём пустых страниц, пространство, которое можно освободить при дефрагментации \
(DatabaseSize — AvailableNewMailboxSpace) x 1,1 - необходимо дополнительно иметь свободного места не менее 110% от текущего размера базы (без учета пустых страниц) \
`cd $path` \
`Dismount-Database "$path\$db_name"` отмонтировать БД \
`eseutil /d "$path\$db_name.edb"` \
`Mount-Database "$path\$db"` примонтировать БД

### DAG (Database Availability Group)
`Install-WindowsFeature -Name Failover-Clustering -ComputerName EXCH-MX-01` основывается на технологии Windows Server Failover Cluster \
`New-DatabaseAvailabilityGroup -Name dag-01 -WitnessServer fs-05 -WitnessDirectory C:\witness_exchange1` создать группу с указанием файлового свидетеля для кворума \
Quorum - это процесс голосования, в котором для принятия решения нужно иметь большинство голосов, что бы сделать текущую копию базы данных активной. \
WitnessDirectory — используется для хранения данных файлового ресурса-свидетеля. \
`Set-DatabaseAvailabilityGroup dag-01 –DatabaseAvailabilityGroupIPAdress $ip` изменить ip-адрес группы \
`Get-DatabaseAvailabilityGroup` список всех групп \
`Get-DatabaseAvailabilityGroup -Identity dag-01` \
`Add-DatabaseAvailabilityGroupServer -Identity dag-01 -MailboxServer EXCH-MX-01` добавить первый сервер (все БД на серверах в DAG должны храниться по одинаковому пути) \
`Add-MailboxDatabaseCopy -Identity db_name -MailboxServer EXCH-MX-04` добавить копию БД \
`Get-MailboxDatabaseCopyStatus -Identity db_name\* | select Name,Status,LastInspectedLogTime` статус и время последнего копирования журнала транзакий

Status: \
Mounted - рабочая база \
Suspended - приостановлено копирование \
Healthy - рабочая пассивная копия \
ServiceDown - недоступна (выключен сервер) \
Dismounted - отмонтирована \
FailedAndSuspended - ошибка и приостановка копирования \
Resynchronizing - процесс синхронизация, где будет постепенно уменьшаться длина очереди \
CopyQueue Length - длина репликационной очереди копирования (0 - значит все изменения из активной базы реплицированы в пассивную копию)

`Resume-MailboxDatabaseCopy -Identity db_name\EXCH-MX-04` возобновить (Resume) или запустить копирование бд на EXCH-MX-04 (из статуса Suspended в Healthy) \
`Suspend-MailboxDatabaseCopy -Identity db_name\EXCH-MX-04` остановить копирование (в статус Suspended) \
`Update-MailboxDatabaseCopy -Identity db_name\EXCH-MX-04 -DeleteExistingFiles` обновить копию БД (сделать Full Backup) \
`Set-MailboxDatabaseCopy -Identity db_name\EXCH-MX-04 -ActivationPreference 1` изменить приоритет для активации копий БД (какую использовать, 1 – самое высокое значение) \
`Move-ActiveMailboxDatabase db_name -ActivateOnServer EXCH-MX-04 -MountDialOverride:None -Confirm:$false` включить копию БД в DAG (переключиться на активную копию) \
`Remove-MailboxDatabaseCopy -Identity db_name\EXCH-MX-04 -Confirm:$False` удалить копии пассивной базы в DAG-группе (у БД должно быть отключено ведение циклического журнала) \
`Remove-DatabaseAvailabilityGroupServer -Identity dag-01 -MailboxServer EXCH-MX-04 -ConfigurationOnly` удалить MX сервер из группы DAG \
`Import-Module FailoverClusters` \
`Get-ClusterNode EXCH-MX-04 | Remove-ClusterNode -Force` удалить отказавший узел из Windows Failover Cluster

`Get-DatabaseAvailabilityGroup | Get-DatabaseAvailabilityGroupHealth` мониторинг

### Index
`Get-MailboxDatabaseCopyStatus * | select name,status,ContentIndexState,ContentIndexErrorMessage,ActiveDatabaseCopy,LatestCopyBackupTime,CopyQueueLength` узнать состояние работы индксов БД и текст ошибки, на каком сервере активная копия БД, дата последней копии и текущая очередь \
`Get-MailboxDatabaseCopyStatus -Identity $db_name\* | Format-List Name,ContentIndexState` отобразить список всех копий конкретной БД на всех серверах, и статус их индексов, если у второго сервера статус Healthy, можно восстановить из него \
`Get-MailboxDatabaseCopyStatus -Identity $db_name\EXCH-MX-04 | Update-MailboxDatabaseCopy -SourceServer EXCH-MX-01 -CatalogOnly` восстановить БД из копии \
`cd %PROGRAMFILES%\Microsoft\Exchange Server\V14\Scripts` или v15 для Exchange 2016 \
`.\ResetSearchIndex.ps1 $db_name` скрипт восстановления индекса

`Get-MailboxDatabaseCopyStatus * | where {$_.ContentIndexState -eq "Failed" -or $_.ContentIndexState -eq "FailedAndSuspended"}` отобразить у какой БД произошел сбой работы (FailedAndSuspended) или индекса (ContentIndexState)

# TrueNAS

`import-Module TrueNas` \
`(Get-Module TrueNas).ExportedCommands` \
`Connect-TrueNasServer -Server tnas-01 -SkipCertificateCheck` \
`Get-TrueNasCertificate` настройки сертификата \
`Get-TrueNasSetting` настройки языка, time zone, syslog level и server, https port \
`Get-TrueNasUser` список пользователей \
`Get-TrueNasSystemVersion` характеристики (Physical Memory, Model, Cores) и Uptime \
`Get-TrueNasSystemAlert` snmp для оповещений \
`Get-TrueNasSystemNTP` список используемых NTP серверов \
`Get-TrueNasDisk` список разделов физического диска \
`Get-TrueNasInterface` сетевые интерфейсы \
`Get-TrueNasGlobalConfig` сетевые настройки \
`Get-TrueNasDnsServer` настроенные DNS-сервера \
`Get-TrueNasIscsiTarget` отобразить ID группы инициаторов использующих таргет, используемый portal, authentification и authen-method \
`Get-TrueNasIscsiInitiator` отобразить группы инициаторов \
`Get-TrueNasIscsiPortal` слушатель (Listen) и порт \
`Get-TrueNasIscsiExtent` список ISCSi Target (статус работы, путь) \
`Get-TrueNasPool` список pool (Id, Path, Status, Healthy) \
`Get-TrueNasVolume -Type FILESYSTEM` список pool файловых систем \
`Get-TrueNasVolume -Type VOLUME` список разделов в pool и их размер \
`Get-TrueNasService | ft` список служб и их статус \
`Start-TrueNasService ssh` запустить службу \
`Stop-TrueNasService ssh` остановить службу

# Veeam

`Set-ExecutionPolicy AllSigned` or Set-ExecutionPolicy Bypass -Scope Process \
`Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))` \
`choco install veeam-backup-and-replication-console` \
`Get-Module Veeam.Backup.PowerShell` \
`Get-Command -Module Veeam.Backup.PowerShell` or Get-VBRCommand \
`Connect-VBRServer -Server $srv -Credential $cred` or -User and -Password # - Port 9392 # default \
`Get-VBRJob` \
`Get-VBRCommand *get*backup*` \
`Get-VBRComputerBackupJob` \
`Get-VBRBackup` \
`Get-VBRBackupRepository` \
`Get-VBRBackupSession` \
`Get-VBRBackupServerCertificate` \
`Get-VBRRestorePoint` \
`Get-VBRViProxy`

# REST API

`$pars = Invoke-WebRequest -Uri $url` \
`$pars | Get-Member` \
`$pars.Content` \
`$pars.StatusCode -eq 200` \
`$pars.Headers` \
`$pars.ParsedHtml | Select lastModified` \
`$pars.Links | fl title,innerText,href` \
`$pars.Images.src` links on images \
`iwr $url -OutFile $path` download

`$pars = wget -Uri $url` \
`$pars.Images.src | %{` \
`$name = $_ -replace ".+(?<=/)"` \
`wget $_ -OutFile "$home\Pictures\$name"` \
`}` \
`$count_all = $pars.Images.src.Count` \
`$count_down = (Get-Item $path\*).count` \
`"Downloaded $count_down of $count_all files to $path"`

Methods: \
GET - Read \
POST - Create \
PATCH - Partial update/modify \
PUT - Update/replace \
DELETE - Remove

`https://veeam-11:9419/swagger/ui/index.html` \
`$Header = @{` \
`"x-api-version" = "1.0-rev2"` \
`}` \
`$Body = @{` \
`"grant_type" = "password"` \
`"username" = "$login"` \
`"password" = "$password"` \
`}` \
`$vpost = iwr "https://veeam-11:9419/api/oauth2/token" -Method POST -Headers $Header -Body $Body -SkipCertificateCheck` \
`$vtoken = (($vpost.Content) -split '"')[3]`

`$token = $vtoken | ConvertTo-SecureString -AsPlainText –Force` \
`$vjob = iwr "https://veeam-11:9419/api/v1/jobs" -Method GET -Headers $Header -Authentication Bearer -Token $token -SkipCertificateCheck`

`$Header = @{` \
`"x-api-version" = "1.0-rev1"` \
`"Authorization" = "Bearer $vtoken"` \
`}` \
`$vjob = iwr "https://veeam-11:9419/api/v1/jobs" -Method GET -Headers $Header -SkipCertificateCheck` \
`$vjob = $vjob.Content | ConvertFrom-Json`

`$vjob = Invoke-RestMethod "https://veeam-11:9419/api/v1/jobs" -Method GET -Headers $Header -SkipCertificateCheck` \
`$vjob.data.virtualMachines.includes.inventoryObject`

# IE

`$ie.document.IHTMLDocument3_getElementsByTagName("input")  | select name` получить имена всех Input Box \
`$ie.document.IHTMLDocument3_getElementsByTagName("button") | select innerText` получить имена всех Button \
`$ie.Document.documentElement.innerHTML` прочитать сырой Web Content (<input name="login" tabindex="100" class="input__control input__input" id="uniq32005644019429136" spellcheck="false" placeholder="Логин") \
`$All_Elements = $ie.document.IHTMLDocument3_getElementsByTagName("*")` забрать все элементы \
`$Go_Button = $All_Elements | ? innerText -like "go"` поиск элемента по имени \
`$Go_Button | select ie9_tagName` получить TagName (SPAN) для быстрого дальнейшего поиска \
`$SPAN_Elements = $ie.document.IHTMLDocument3_getElementsByTagName("SPAN")`
```
$ie = New-Object -ComObject InternetExplorer.Application
$ie.navigate("https://yandex.ru")
$ie.visible = $true
$ie.document.IHTMLDocument3_getElementByID("login").value = "Login"
$ie.document.IHTMLDocument3_getElementByID("passwd").value = "Password"
$Button_Auth = ($ie.document.IHTMLDocument3_getElementsByTagName("button")) | ? innerText -match "Войти"
$Button_Auth.Click()
$Result = $ie.Document.documentElement.innerHTML
$ie.Quit()
```
# Selenium

`.\nuget.exe install Selenium.WebDriver` \
`Copy-Item -Path .\WebDriver.dll -Destination $home\Documents\Selenium\` версия 4.9.0 для .NET 4.8 \
`Copy-Item -Path .\ChromeDriver.exe -Destination $home\Documents\Selenium\` скачать драйвер (113.0.5672.63) https://sites.google.com/chromium.org/driver/

`Choco Upgrade GoogleChrome` обновить Google Chrome \
`Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" | select DisplayName,DisplayVersion,InstallDate,InstallLocation` узнать версию и дату обновления
```
$path = "$env:temp\ChromeSetup.exe"
Invoke-WebRequest 'https://dl.google.com/chrome/install/latest/chrome_installer.exe'  -OutFile $path
Start-Process -FilePath $path -Args "/silent /install" -NoNewWindow -Wait
```
`$selenium.FindElements([OpenQA.Selenium.By]::CssSelector('button')) | select TagName,Text` отобразить все Button по TagName используя CSS selector \
`$selenium.FindElements([OpenQA.Selenium.By]::TagName('button'))` поиск по TagName \
`$selenium.FindElements([OpenQA.Selenium.By]::CssSelector('button')) | ? Text -match "Войти"` поиск Button по содержимому Text \
`$button = $selenium.FindElements([OpenQA.Selenium.By]::CssSelector('*')) | ? Text -like "Войти через Яндекс ID"` поиск во всех элементах по содержимому Text для получения нужного элемента (SPAN) для дальнейшего быстрого поиска

F12 (Dev Tools) - Ctrl+Shift+C - Copy selector/full XPath \
`$inputbox = $selenium.FindElements([OpenQA.Selenium.By]::CssSelector('#passp-field-login'))` \
`$inputbox = $selenium.FindElements([OpenQA.Selenium.By]::XPath("/html/body/div/div/div[2]/div[2]/div/div/div[2]/div[3]/div/div/div/div/form/div/div[2]/div[2]/div/div[2]/span/input"))` \
`$inputbox | gm -MemberType method`
```
$path = "$home\Documents\Selenium"
if (($env:Path -split ';') -notcontains $path) {
$env:Path += ";$path"
}
Import-Module "$path\WebDriver.dll"
$selenium_options = New-Object OpenQA.Selenium.Chrome.ChromeOptions
$selenium_options.AddArgument('start-maximized')
$selenium_options.AcceptInsecureCertificates = $True
$selenium = New-Object OpenQA.Selenium.Chrome.ChromeDriver($selenium_options)
# $selenium = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$selenium.Navigate().GoToURL('https://yandex.ru')
$selenium.FindElements([OpenQA.Selenium.By]::CssSelector('button'))[2].Click() # нажать на кнопку "Войти"
$button = $selenium.FindElements([OpenQA.Selenium.By]::CssSelector('SPAN')) | ? Text -like "Войти через Яндекс ID"
$button.Click()
($selenium.FindElements([OpenQA.Selenium.By]::CssSelector('Button')))[1].Click()
$inputbox = $selenium.FindElements([OpenQA.Selenium.By]::CssSelector('input')) | ? ComputedAccessibleRole -like "textbox"
$inputbox.Click()
$inputbox.Clear()
$inputbox.SendKeys("+79997772211")
$inputbox.Submit()
$selenium.Close()
$selenium.Quit()
```
### Convert Screenshot Base64 to Image
```
$Base64img = (($selenium.FindElements([OpenQA.Selenium.By]::CssSelector('#root > div > div.passp-page > div.passp-flex-wrapper > div > div > div.passp-auth-content > div.Header > div > a')))).GetScreenshot()
$Image = [Drawing.Bitmap]::FromStream([IO.MemoryStream][Convert]::FromBase64String($Base64img))
$Image.Save("$home\Desktop\YaLogo.jpg")
```
# Console API

`[Console] | Get-Member -Static` \
`[Console]::BackgroundColor = "Blue"`
```
do {
if ([Console]::KeyAvailable) {
$keyInfo = [Console]::ReadKey($true)
break
}
Write-Host "." -NoNewline
sleep 1
} while ($true)
Write-Host
$keyInfo

function Get-KeyPress {
param (
[Parameter(Mandatory)][ConsoleKey]$Key,
[System.ConsoleModifiers]$ModifierKey = 0
)
if ([Console]::KeyAvailable) {
$pressedKey = [Console]::ReadKey($true)
$isPressedKey = $key -eq $pressedKey.Key
if ($isPressedKey) {
$pressedKey.Modifiers -eq $ModifierKey
} else {
[Console]::Beep(1800, 200)
$false
}}}

Write-Warning 'Press Ctrl+Shift+Q to exit'
do {
Write-Host "." -NoNewline
$pressed = Get-KeyPress -Key Q -ModifierKey 'Control,Shift'
if ($pressed) {break}
sleep 1
} while ($true)
```
### Windows API 

`Add-Type -AssemblyName System.Windows.Forms` \
`[int][System.Windows.Forms.Keys]::F1`

`65..90 | % {"{0} = {1}" -f $_, [System.Windows.Forms.Keys]$_}`
```
function Get-ControlKey {
$key = 112
$Signature = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@
Add-Type -MemberDefinition $Signature -Name Keyboard -Namespace PsOneApi
[bool]([PsOneApi.Keyboard]::GetAsyncKeyState($key) -eq -32767)
}

Write-Warning 'Press F1 to exit'
do {
Write-Host '.' -NoNewline
$pressed = Get-ControlKey
if ($pressed) { break }
Start-Sleep -Seconds 1
} while ($true)
```
### [Clicker]
```
$cSource = @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
public class Clicker
{
//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx
[StructLayout(LayoutKind.Sequential)]
struct INPUT
{ 
    public int        type; // 0 = INPUT_MOUSE,
                            // 1 = INPUT_KEYBOARD
                            // 2 = INPUT_HARDWARE
    public MOUSEINPUT mi;
}
//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646273(v=vs.85).aspx
[StructLayout(LayoutKind.Sequential)]
struct MOUSEINPUT
{
    public int    dx ;
    public int    dy ;
    public int    mouseData ;
    public int    dwFlags;
    public int    time;
    public IntPtr dwExtraInfo;
}
//This covers most use cases although complex mice may have additional buttons
//There are additional constants you can use for those cases, see the msdn page
const int MOUSEEVENTF_MOVED      = 0x0001 ;
const int MOUSEEVENTF_LEFTDOWN   = 0x0002 ;
const int MOUSEEVENTF_LEFTUP     = 0x0004 ;
const int MOUSEEVENTF_RIGHTDOWN  = 0x0008 ;
const int MOUSEEVENTF_RIGHTUP    = 0x0010 ;
const int MOUSEEVENTF_MIDDLEDOWN = 0x0020 ;
const int MOUSEEVENTF_MIDDLEUP   = 0x0040 ;
const int MOUSEEVENTF_WHEEL      = 0x0080 ;
const int MOUSEEVENTF_XDOWN      = 0x0100 ;
const int MOUSEEVENTF_XUP        = 0x0200 ;
const int MOUSEEVENTF_ABSOLUTE   = 0x8000 ;
const int screen_length          = 0x10000 ;
//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646310(v=vs.85).aspx
[System.Runtime.InteropServices.DllImport("user32.dll")]
extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);
public static void LeftClickAtPoint(int x, int y)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
    input[0].mi.dy = y*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}
}
'@
```
`Add-Type -TypeDefinition $cSource -ReferencedAssemblies System.Windows.Forms,System.Drawing` \
`[Clicker]::LeftClickAtPoint(1900,1070)`

### [Audio]
```
Add-Type -Language CsharpVersion3 -TypeDefinition @"
using System.Runtime.InteropServices;
[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume {
// f(), g(), ... are unused COM method slots. Define these if you care
int f(); int g(); int h(); int i();
int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
int j();
int GetMasterVolumeLevelScalar(out float pfLevel);
int k(); int l(); int m(); int n();
int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
int GetMute(out bool pbMute);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice {
int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator {
int f(); // Unused
int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }
public class Audio {
static IAudioEndpointVolume Vol() {
var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
IMMDevice dev = null;
Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
IAudioEndpointVolume epv = null;
var epvid = typeof(IAudioEndpointVolume).GUID;
Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
return epv;
}
public static float Volume {
get {float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v;}
set {Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty));}
}
public static bool Mute {
get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
}
}
"@
```
`[Audio]::Volume = 0.50` \
`[Audio]::Mute = $true`

### Register-Event

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

# Excel
```
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
```
### Excel.Application.Open
```
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $false
$ExcelWorkBook = $excel.Workbooks.Open($path) # открыть xlsx-файл
$ExcelWorkBook.Sheets | select Name,Index # отобразить листы
$ExcelWorkSheet = $ExcelWorkBook.Sheets.Item(1) # открыть лист по номеру Index
1..100 | %{$ExcelWorkSheet.Range("A$_").Text} # прочитать значение из столбца А строки c 1 по 100
$Excel.Quit()
```
### ImportExcel
`Install-Module -Name ImportExcel` \
`$data | Export-Excel .\Data.xlsx` \
`$data = Import-Excel .\Data.xlsx`

`$data = ps` \
`$Chart = New-ExcelChartDefinition -XRange CPU -YRange WS -Title "Process" -NoLegend` \
`$data | Export-Excel .\ps.xlsx -AutoNameRange -ExcelChartDefinition $Chart -Show`

# XML
```
$xml = [xml](Get-Content $home\desktop\test.rdg) # прочитать содержимое XML-файла
$xml.load("$home\desktop\test.rdg") # открыть файл
$xml.RDCMan.file.group.properties.name # имена групп
$xml.RDCMan.file.group.server.properties # имена всех серверов
$xml.RDCMan.file.group[3].server.properties # список серверов в 4-й группе
($xml.RDCMan.file.group[3].server.properties | ? name -like ADIRK).Name = "New-Name" # изменить значение
$xml.RDCMan.file.group[3].server[0].properties.displayName = "New-displayName" 
$xml.RDCMan.file.group[3].server[1].RemoveAll() # удалить объект (2-й сервер в списке)
$xml.Save($file) # сохранить содержимое объекта в файла
```
`Get-Service | Export-Clixml -path $home\desktop\test.xml` экспортировать объект powershell в xml \
`Import-Clixml -Path $home\desktop\test.xml` импортировать объект xml в powershell \
`ConvertTo-Xml (Get-Service)`
```
if (Test-Path $CredFile) {
$Cred = Import-Clixml -path $CredFile
} elseif (!(Test-Path $CredFile)) {
$Cred = Get-Credential -Message "Enter credential"
if ($Cred -ne $null) {
$Cred | Export-CliXml -Path $CredFile
} else {
return
}
}
```
### XmlWriter (Extensible Markup Language)
```
$XmlWriterSettings = New-Object System.Xml.XmlWriterSettings
$XmlWriterSettings.Indent = $true # включить отступы
$XmlWriterSettings.IndentChars = "    " # задать отступ

$XmlFilePath = "$home\desktop\test.xml"
$XmlObjectWriter = [System.XML.XmlWriter]::Create($XmlFilePath, $XmlWriterSettings) # создать документ
$XmlObjectWriter.WriteStartDocument() # начать запись в документ

$XmlObjectWriter.WriteComment("Comment")
$XmlObjectWriter.WriteStartElement("Root") # создать стартовый элемент, который содержит дочерние объекты
    $XmlObjectWriter.WriteStartElement("Configuration") # создать первый дочерний элемент для BaseSettings
        $XmlObjectWriter.WriteElementString("Language","RU")
        $XmlObjectWriter.WriteStartElement("Fonts")   		# <Fonts>
            $XmlObjectWriter.WriteElementString("Name","Arial")
            $XmlObjectWriter.WriteElementString("Size","12")
        $XmlObjectWriter.WriteEndElement()               	# </Fonts>
    $XmlObjectWriter.WriteEndElement() # конечный элемент </Configuration>
$XmlObjectWriter.WriteEndElement() # конечный элемент </Root>

$XmlObjectWriter.WriteEndDocument() # завершить запись в документ
$XmlObjectWriter.Flush()
$XmlObjectWriter.Close()
```
### CreateElement
```
$xml = [xml](gc $home\desktop\test.xml)
$xml.Root.Configuration.Fonts
$NewElement = $xml.CreateElement("Fonts") # выбрать элемент куда добавить
$NewElement.set_InnerXML("<Name>Times New Roman</Name><Size>14</Size>") # Заполнить значениями дочерние элементы Fonts
$xml.Root.Configuration.AppendChild($NewElement) # добавить элемент новой строкой в Configuration (родитель Fonts)
$xml.Save("$home\desktop\test.xml")
```
### JSON (JavaScript Object Notation)
```
log =
{
   level = 7;
};

$log = [xml]"
<log>
   <level>7</level>
</log>"

$log = '
{
  "log": {
    "level": 7
  }
}' | ConvertFrom-Json
```
### YAML (Yet Another Markup Language)
```
Import-Module PSYaml
$network = "
network:
  ethernets:
    ens160:
      dhcp4: yes
      dhcp6: no
      nameservers:
        addresses: # [8.8.8.8, 1.1.1.1]
		  - 8.8.8.8
		  - 1.1.1.1
  version: 2
"
$Result = ConvertFrom-Yaml $network
$Result.Values.ethernets.ens160.nameservers
```
### HTML (HyperText Markup Language)
`Get-Process | select Name, CPU | ConvertTo-HTML -As Table > "$home\desktop\proc-table.html"` вывод в формате List (Format-List) или Table (Format-Table)

### PSWriteHTML
```
Import-Module PSWriteHTML
(Get-Module PSWriteHTML).ExportedCommands
Get-Service | Out-GridHtml -FilePath ~\Desktop\Get-Service-Out-GridHtml.html
```
### HtmlReport
```
Import-Module HtmlReport
$topVM = ps | Sort PrivateMemorySize -Descending | Select -First 10 | %{,@(($_.ProcessName + " " + $_.Id), $_.PrivateMemorySize)}
$topCPU = ps | Sort CPU -Descending | Select -First 10 | %{,@(($_.ProcessName + " " + $_.Id), $_.CPU)}
New-Report -Title "Piggy Processes" -Input {
New-Chart Bar "Top VM Users" -input $topVm
New-Chart Column "Top CPU Overall" -input $topCPU
ps | Select ProcessName, Id, CPU, WorkingSet, *MemorySize | New-Table "All Processes"
} > ~\Desktop\Get-Process-HtmlReport.html
```
### CSV (Comma-Separated Values)
`Get-Service | Select Name,DisplayName,Status,StartType | Export-Csv -path "$home\Desktop\Get-Service.csv" -Append -Encoding Default` экспортировать в csv (-Encoding UTF8) \
`Import-Csv "$home\Desktop\Get-Service.csv" -Delimiter ","` импортировать массив
```
$data = ConvertFrom-Csv @"
Region,State,Units,Price
West,Texas,927,923.71
$null,Tennessee,466,770.67
"@
```
# SQLite

`Install-Module MySQLite -Repository PSGallery` \
`$path = "$home\desktop\Get-Service.db"` \
`Get-Service | select  Name,DisplayName,Status | ConvertTo-MySQLiteDB -Path $path -TableName Service -force` \
`(Get-MySQLiteDB $path).Tables` \
`New-MySQLiteDB -Path $path` создать базу \
`Invoke-MySQLiteQuery -Path $path -Query "SELECT name FROM sqlite_master WHERE type='table';"` список всех таблиц в базе \
`Invoke-MySQLiteQuery -Path $path -Query "CREATE TABLE Service (Name TEXT NOT NULL, DisplayName TEXT NOT NULL, Status TEXT NOT NULL);"` создать таблицу \
`Invoke-MySQLiteQuery -Path $path -Query "INSERT INTO Service (Name, DisplayName, Status) VALUES ('Test', 'Full-Test', 'Active');"` добавить данные в таблицу \
`Invoke-MySQLiteQuery -Path $path -Query "SELECT * FROM Service"` содержимое таблицы \
`Invoke-MySQLiteQuery -Path $path -Query "DROP TABLE Service;"` удалить таблицу
```
$Service = Get-Service | select Name,DisplayName,Status
foreach ($S in $Service) {
$1 = $S.Name; $2 = $S.DisplayName; $3 = $S.Status;
Invoke-MySQLiteQuery -Path $path -Query "INSERT INTO Service (Name, DisplayName, Status) VALUES ('$1', '$2', '$3');"
}
```
### Database password
```
$Connection = New-SQLiteConnection -DataSource $path
$Connection.ChangePassword("password")
$Connection.Close()
Invoke-SqliteQuery -Query "SELECT * FROM Service" -DataSource "$path;Password=password"
```
# DSC

`Import-Module PSDesiredStateConfiguration` \
`(Get-Module PSDesiredStateConfiguration).ExportedCommands` \
`Get-DscLocalConfigurationManager`

`Get-DscResource` \
`Get-DscResource -Name File -Syntax` # https://learn.microsoft.com/ru-ru/powershell/dsc/reference/resources/windows/fileresource?view=dsc-1.1

`Ensure = Present` настройка должна быть включена (каталог должен присутствовать, процесс должен быть запущен, если нет – создать, запустить) \
`Ensure = Absent` настройка должна быть выключена (каталога быть не должно, процесс не должен быть запущен, если нет – удалить, остановить)
```
Configuration DSConfigurationProxy {
    Node uk-vproxy-01 {
        File CreateDir {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "C:\Temp"
        }
        Service StopW32time {
            Name = "w32time"
            State = "Stopped" # Running
        }
		WindowsProcess RunCalc {
            Ensure = "Present"
            Path = "C:\WINDOWS\system32\calc.exe"
            Arguments = ""
        }
        Registry RegSettings {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\MySoft"
            ValueName = "TestName"
            ValueData = "TestValue"
            ValueType = "String"
        }
#		WindowsFeature IIS {
#            Ensure = "Present"
#            Name = "Web-Server"
#        }
    }
}
```
`$Path = (DSConfigurationProxy).DirectoryName` \
`Test-DscConfiguration -Path $Path | select *` ResourcesInDesiredState - уже настроено, ResourcesNotInDesiredState - не настроено (не соответствует) \
`Start-DscConfiguration -Path $Path` \
`Get-Job` \
`$srv = "uk-vproxy-01"` \
`Get-Service -ComputerName $srv | ? name -match w32time # Start-Service` \
`icm $srv {Get-Process | ? ProcessName -match calc} | ft # Stop-Process -Force` \
`icm $srv {ls C:\ | ? name -match Temp} | ft # rm`

# Git

`git --version`
`git config --global user.name "Lifailon"` добавить имя для коммитов \
`git config --global user.email "lifailon@mail.com"` \
`git config --global --edit` \
`ssh-keygen -t rsa -b 4096 -с "lifailon@mail.com"` \
`Get-Service | where name -match "ssh-agent" | Set-Service -StartupType Automatic` \
`Get-Service | where name -match "ssh-agent" | Start-Service` \
`ssh-agent` \
`ssh-add C:\Users\Lifailon\.ssh\id_rsa` \
`cat ~\.ssh\id_rsa.pub | Set-Clipboard` copy to https://github.com/settings/keys \
`mkdir C:\Git; cd C:\Git` \
`git clone git@github.com:Lifailon/PowerShell-Commands` \
`cd PowerShell-Commands` \
`git grep powershell` поиск текста в файлах \
`git pull` синхронизировать изменения из хранилища \
`git status` отобразить статус изменений по файлам \
`git diff` отобразить изменения построчно \
`git add -A` добавить (проиндексировать) изменения \
`git commit -m "update files"` сохранить изменения с комментарием \
`git commit --amend -m "update files and creat new file"` изменить последний комментарий коммита \
`git push` синхронизировать локальные изменения с репозиторием \
`git branch test` создать новую ветку \
`git branch -d test` удалить ветку \
`git switch test` переключиться на другую ветку \
`git merge test` слияние текущей ветки (git branch) с указанной (test) \
`git diff test -- myFile.txt` сравнить файл текущей ветки с тем же файлом в указанной ветки test \
`git log --oneline --all` лог коммитов \
`git log --graph` коммиты и следование веток \
`git show d01f09dead3a6a8d75dda848162831c58ca0ee13` отобразить подробный лог по номеру коммита \
`git checkout filename` откатить изменения, если не было команды add \
`git checkout d01f09dead3a6a8d75dda848162831c58ca0ee13` переключить локальные файлы рабочей копии на указанный коммит (изменить HEAD на указанный коммит) \
`git reset HEAD filename` откатить изменения последнего индекса, если был add но не было commit, тем самым вернуться до последней зафиксированный версии (коммита) и потом выполнить checkout \
`git reset --mixed HEAD filename` изменения, содержащиеся в отменяемом коммите, не должны исчезнуть, они будут сохранены в виде локальных изменений в рабочей копии \
`git restore filename` отменить все локальные изменения в рабочей копии \
`git restore --source d01f09dead3a6a8d75dda848162831c58ca0ee13 filename` восстановить файл на указанную версию по хэшу индентификатора коммита \
`git revert HEAD --no-edit` отменить последний коммит, без указания комментария (события записываются в git log) \
`git reset --hard d01f09dead3a6a8d75dda848162831c58ca0ee13` удалить все коммиты до указанного (и откатиться до него)

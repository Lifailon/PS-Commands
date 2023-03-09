![Image alt](https://github.com/Lifailon/PowerShell-Commands/blob/rsa/Logo/PowerShell-Commands.png)

- [Object](#Object)
- [Regex](#Regex)
- [Items](#Items)
- [Application](#Application)
- [Network](#Network)
- [SMB](#SMB)
- [WinRM](#WinRM)
- [ComObject](#ComObject)
- [WMI](#WMI)
- [ActiveDirectory](#ActiveDirectory)
- [ServerManager](#ServerManager)
- [PackageManagement](#PackageManagement)
- [SQLite](#SQLite)
- [PowerCLI](#PowerCLI)
- [Veeam](#Veeam)

### Help
`Get-Command *Service*` поиск команды по имени \
`Get-Help Get-Service` синтаксис \
`Get-Service | Get-Member` отобразить Method (действия: Start, Stop), Property (объекты вывода: Status, DisplayName), Event (события объектов: Click) и Alias \
`Get-Alias ps` \
`Get-Verb` действия, утвержденные для использования в командах \
`Set-ExecutionPolicy Unrestricted` \
`Get-ExecutionPolicy`

# Object

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

`$object = New-Object –TypeName PSCustomObject -Property @{User = $env:username; Server = $env:computername}` предназначен для хранения объектов с произвольной структурой, где порядок их свойств может поменяться. Чтобы этого избежать, необходимо использовать дополнительный атрибут [ordered] \
`$object | Get-Member` \
`$object | Add-Member –MemberType NoteProperty –Name IP –Value "192.168.1.1"` добавить свойство или -MemberType ScriptMethod \
`$object.PsObject.Properties.Remove('User')` удалить свойство (столбец)

`$obj = @()` \
`$obj += [PSCustomObject]@{User = $env:username; Server = $env:computername}` медленный метод добавления, в каждой интерации перезаписывается массив и коллекция становится фиксированного размера (Collection was of a fixed size)

`Class CustomClass {` \
`[string]$User` \
`[string]$Server` \
`}` \
`$Class = New-Object -TypeName CustomClass` \
`$Class.User = "support"` \
`$Class.Server = "srv-01"`

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
`ps | Sort-Object -Descending CPU | select -first 10 ProcessName,` # сортировка по CPU, вывести первых 10 значений (-first) \
`@{Name="ProcessorTime"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}},` # затрачено процессорного времени в минутах \
`@{Name="Memory"; Expression={[string]([int]($_.WS / 1024kb))+"MB"}},` # делим байты на КБ \
`@{Label="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}}` # вычесть из текущего времени - время запуска, и удалить milisec

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
`$ip = "192.168.10.1"` \
`$ip -match "(\.\d{1,3})\.\d{1,2}"` True \
`$Matches` отобразить все подходящие переменные последнего поиска, которые входят и не входят в группы ()

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
`Get-ChildItem $path *.exe* -Recurse` отобразить содержимое каталога (Alias: ls/gci/dir) и дочерних каталогов (-Recurse) \
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
`Remove-Item -Recurse` рекурсивное удаление, без запроса подверждения если в каталоге находятся файлы (Alias: rm/del) \
`Remove-Item 'C:\test\*'` удаление файлов внутри каталога \
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

Размер всех дочерних директория в Mb (округлить до одного символа после запятой):
`ls (pwd).Path | %{` \
`$size = "{0:N1} Mb" -f ((ls $_.FullName -Recurse -Force | Measure-Object -Property Length -Sum).Sum / 1Mb)` \
`"$_.Name | $size"` \
`}`

### Filehash
`Get-Filehash -Algorithm SHA256 "$env:USERPROFILE\Documents\RSA.conf.txt"`

### Clipboard
`Set-Clipboard $srv` скопировать в буфер обмена \
`Get-Clipboard` вставить

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

### XML
`$CredFile = ".\cred.xml"` \
`try {` \
`$Cred = Import-Clixml -path $credFile` \
`}` \
`catch {` \
`$Cred = Get-Credential -Message "Enter credential"` \
`if ($Cred -ne $null) {` \
`$Cred | Export-CliXml -Path $credFile` \
`}` \
`else {return}` \
`}`

### CSV
`Get-Service | Select Name,DisplayName,Status,StartType | Export-Csv -path "$home\Desktop\Get-Service.csv" -Append -Encoding Default` экспортировать в csv (-Encoding UTF8) \
`Import-Csv "$home\Desktop\Get-Service.csv" -Delimiter ","` импортировать массив

### ConvertTo-HTML/JSON/XML
`Get-Process | select Name, CPU | ConvertTo-HTML -As Table > "$home\desktop\proc-table.html"` вывод в формате List (Format-List) или Table (Format-Table)

# Application

### Local User and Group
`Get-LocalUser` список пользователей \
`Get-LocalGroup` список групп \
`New-LocalUser "1C" -Password $Password -FullName "1C Domain"` создать пользователя \
`Set-LocalUser -Password $Password 1c` изменить пароль \
`Add-LocalGroupMember -Group "Administrators" -Member "1C"` добавить в группу Администраторов \
`Get-LocalGroupMember "Administrators"` члены группы

### EventLog
`Get-EventLog -List` отобразить все корневые журналы логов и их размер \
`Clear-EventLog Application` очистить логи указанного журнала \
`Get-EventLog -LogName Security -InstanceId 4624` найти логи по ID в журнале Security

`function Get-Log ($count=30,$hour=-3) {` # указать значения параметров по умолчанию \
`Get-EventLog -LogName Application -Newest $count | where-Object TimeWritten -ge (Get-Date).AddHours($hour)` # отобразить 30 новых событий за последние 3 часа \
`}` \
`Get-Log 10 -1` # передача параметров функции (если значения идут по порядку, то можно не указывать названия переменных)

### WinEvent
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

### Firewall-Manager
`Install-Module Firewall-Manager` \
`Export-FirewallRules -Name * -CSVFile $home\documents\fw.csv` -Inbound -Outbound -Enabled -Disabled -Allow -Block (фильтр правил для экспорта) \
`Import-FirewallRules -CSVFile $home\documents\fw.csv`

### Performance
`(Get-Counter -ListSet *).CounterSetName` вывести список всех доступных счетчиков производительности в системе \
`(Get-Counter -ListSet *memory*).Counter` все счетчики, включая дочернии, поиск по wildcard-имени \
`Get-Counter "\Memory\Available MBytes"` объем свободной оперативной памяти \
`Get-Counter -cn $srv "\LogicalDisk(*)\% Free Space"` % свободного места на всех разделах дисков \
`(Get-Counter "\Process(*)\ID Process").CounterSamples` \
`Get-Counter "\Processor(_Total)\% Processor Time" –ComputerName $srv -MaxSamples 5 -SampleInterval 2` 5 проверок каждые 2 секунды \
`Get-Counter "\Процессор(_Total)\% загруженности процессора" -Continuous` непрерывно \
`(Get-Counter "\Процессор(*)\% загруженности процессора").CounterSamples`

### Regedit
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

### Scheduled
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

### nslookup
`Resolve-DnsName ya.ru -Type MX` ALL,ANY,A,NS,SRV,CNAME,PTR,TXT(spf)

### route
`Get-NetRoute`

### netstat
`Get-NetTCPConnection -State Established,Listen | where LocalAddress -match "192.168"`

### Invoke-WebRequest
`$pars = iwr -Uri "https://losst.pro/"` \
`$pars | Get-Member` отобразить все методы \
`$pars.Content` содержимое страницы (Out-File url.html) \
`$pars.statuscode -eq 200` код ответа, запрос выполнен успешно \
`$pars.Headers` информация о сервере \
`$pars.Links | fl innerText, href` ссылки \
`$pars.Images.src` ссылки на изображения \
`iwr $url -OutFile $path` скачать файл

# WinRM

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
`$wshell.Exec("notepad.exe")` запустить приложение \
`$wshell.AppActivate('Блокнот')` открыть запущенное приложение \
`$wshell.SendKeys("HI")`

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

`$srv = "localhost"` \
`gwmi Win32_logicalDisk -ComputerName $srv | where {$_.Size -ne $null} | select @{` \
`Label="Value"; Expression={$_.DeviceID}}, @{Label="AllSize"; Expression={` \
`[string]([int]($_.Size/1Gb))+" GB"}},@{Label="FreeSize"; Expression={` \
`[string]([int]($_.FreeSpace/1Gb))+" GB"}}, @{Label="Free%"; Expression={` \
`[string]([int]($_.FreeSpace/$_.Size*100))+" %"}}`

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

`$Session = New-PSSession -ComputerName $srv` \
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

### LAPS (Local Admin Password Management)
`Get-ADComputer -Filter * -SearchBase "DC=$d1,DC=$d2" | Get-AdmPwdPassword -ComputerName {$_.Name} | select ComputerName,Password,ExpirationTimestamp > C:\pass.txt` \
`Get-ADComputer -Identity $srv | Get-AdmPwdPassword -ComputerName {$_.Name} | select ComputerName,Password,ExpirationTimestamp`

### ADComputer
`Get-ADDomainController -Filter * | ft HostName, IPv4Address, operatingsystem,site,IsGlobalCatalog,IsReadOnly` список DC в домене \
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

`$day = (Get-Date).adddays(-360)`
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
`Get-ADReplicationUpToDatenessVectorTable -Target dc-01` Update Sequence Number (USN) увеличивается каждый раз, когда на контроллере домена происходит транзакция (операции создания, обновления или удаления объекта), при репликации DC обмениваются значениями USN, объект с более низким USN при репликации будет перезаписан высоким USN. \
`Get-ADUser -server dc-01 -Identity support4 -Properties uSNChanged | select SamAccountName,uSNChanged` отобразить номер USN объета на конкретном DC

`repadmin /replsummary` отображает все DC, время последней репликации по направлению (Source и Destination) и их состояние с учетом партнеров \
`repadmin /showrepl dc-01` отображает всех партнеров DC по реплкации и их статус для всех разделов NC (Naming Contexts) разделов (DC=ForestDnsZones, DC=DomainDnsZones, CN=Schema, CN=Configuration) \
`repadmin /retry` повторить попытку привязки к целевому DC, если была ошибка 1722 или 1753 (RPC недоступен) \
`repadmin /replicate $srv2 $srv1 DC=$d1,DC=$d2` выполнить репликацию с $srv1 на $srv2 только указанный раздела \
`repadmin /SyncAll /AdeP` запустить межсайтовую исходящую репликацию всех разделов от текущего сервера со всеми партнерами по репликации \
`/A` выполнить для всех разделов NC \
`/d` в сообщениях идентифицировать серверы по DN (вместо GUID DNS - глобальным уникальным идентификаторам) \
`/e` межсайтовая синхронизация (по умолчанию синхронизирует только с DC текущего сайта) \
`/P` извещать об изменениях с этого сервера (по умолчанию: опрашивать об изменениях) \
`repadmin /Queue dc-01` отображает кол-во запросов входящей репликации (очередь), которое необходимо обработать (причиной может быть большое кол-во партнеров или формирование 1000 объектов скриптом) \
`repadmin /showbackup *` узнать дату последнего Backup \
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

# ServerManager

`Get-Command *WindowsFeature*` source module ServerManager \
`Get-WindowsFeature -ComputerName "localhost"` \
`Get-WindowsFeature | where Installed -eq $True` список установленных ролей и компонентов \
`Get-WindowsFeature | where FeatureType -eq "Role"` отсортировать по списку ролей \
`Install-WindowsFeature -Name DNS` установить роль \
`Get-Command *DNS*` \
`Get-DnsServerSetting -ALL` \
`Uninstall-WindowsFeature -Name DNS`

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
`(Get-RDSessionCollectionConfiguration -ConnectionBroker $broker -CollectionName C03 | select *).CustomRdpProperty` use redirection server name:i:1
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

`[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12` включить использование протокол TLS 1.2 (если не отключены протоколы TLS 1.0 и 1.1) \
`Find-PackageProvider` поиск провайдеров \
`Install-PackageProvider PSGallery -force` установить источник \
`Install-PackageProvider Chocolatey -force` \
`Install-PackageProvider NuGet -force` \
`Get-PackageSource` источники установки пакетов \
`Set-PackageSource -Name PSGallery -Trusted` по умолчанию \
`Find-Package -Name *Veeam* -Source PSGallery` поиск пакетов с указанием источника \
`Install-Package -Name VeeamLogParser -ProviderName PSGallery` установка пакета \
`Get-Command *Veeam*`

### PS2EXE
`Install-Module ps2exe -Repository PSGallery` \
`Get-Module -ListAvailable` список всех модулей \
`-noConsole` использовать GUI, без окна консоли powershell \
`-noOutput` выполнение в фоне \
`-noError` без вывода ошибок \
`-requireAdmin` при запуске запросить права администратора \
`-credentialGUI` вывод диалогового окна для ввода учетных данных \
`C:\Install\RDSA.exe -extract:"C:\Install\RDSA.ps1"` \
`Invoke-ps2exe -inputFile "$env:USERPROFILE\Desktop\WinEvent-Viewer-1.1.ps1" -outputFile "$env:USERPROFILE\Desktop\WEV-1.1.exe" -iconFile "$env:USERPROFILE\Desktop\log_48px.ico" -title "WinEvent-Viewer" -noConsole -noOutput -noError`

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
`Get-Job | Receive-Job -Keep` отобразить и не удалять вывод (-Keep)

# SQLite

`Install-Module -name MySQLite -Repository PSGallery` \
`$path = "$home\desktop\Get-Service.db"` \
`Get-Service | select  Name,DisplayName,Status | ConvertTo-MySQLiteDB -Path $path -TableName Service -force` \
`(Get-MySQLiteDB $path).Tables` \
`New-MySQLiteDB -Path $path` создать базу \
`Invoke-MySQLiteQuery -Path $path -Query "SELECT name FROM sqlite_master WHERE type='table';"` список всех таблиц в базе \
`Invoke-MySQLiteQuery -Path $path -Query "CREATE TABLE Service (Name TEXT NOT NULL, DisplayName TEXT NOT NULL, Status TEXT NOT NULL);"` создать таблицу \
`Invoke-MySQLiteQuery -Path $path -Query "INSERT INTO Service (Name, DisplayName, Status) VALUES ('Test', 'Full-Test', 'Active');"` добавить данные в таблицу \
`Invoke-MySQLiteQuery -Path $path -Query "SELECT * FROM Service"` содержимое таблицы \
`Invoke-MySQLiteQuery -Path $path -Query "DROP TABLE Service;"` удалить таблицу

`$Service = Get-Service | select Name,DisplayName,Status` \
`foreach ($S in $Service) {` \
`$1 = $S.Name; $2 = $S.DisplayName; $3 = $S.Status;` \
`Invoke-MySQLiteQuery -Path $path -Query "INSERT INTO Service (Name, DisplayName, Status) VALUES ('$1', '$2', '$3');"` \
`}`

`Install-Module PSSQLite` \
`$Connection = New-SQLiteConnection -DataSource $path` \
`$Connection.ChangePassword("password")` \
`$Connection.Close()` \
`Invoke-SqliteQuery -Query "SELECT * FROM Service" -DataSource "$path;Password=password"`

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

# Veeam

`Set-ExecutionPolicy AllSigned` or Set-ExecutionPolicy Bypass -Scope Process \
`Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))` \
`choco install veeam-backup-and-replication-console` \
`Get-Module Veeam.Backup.PowerShell` \
`Get-Command -Module Veeam.Backup.PowerShell` or Get-VBRCommand \
`Connect-VBRServer -Server $srv -Credential $cred` or -user and -password \
`Get-VBRJob` \
`Get-VBRCommand *get*backup*` \
`Get-VBRComputerBackupJob` \
`Get-VBRBackup` \
`Get-VBRBackupRepository` \
`Get-VBRBackupSession` \
`Get-VBRBackupServerCertificate` \
`Get-VBRRestorePoint` \
`Get-VBRViProxy` \
`https://veeam-11:9419/swagger/ui/index.html` RAST API

### Git
`git --version`
`git config --global user.name "Lifailon"` \
`ls ~\.ssh -force` \
`ssh-keygen -t rsa -b 4096` \
`Get-Service | where name -match "ssh-agent" | Set-Service -StartupType Automatic` \
`Get-Service | where name -match "ssh-agent" | Start-Service` \
`ssh-agent` \
`ssh-add C:\Users\Lifailon\.ssh\id_rsa` \
`cat ~\.ssh\id_rsa.pub | Set-Clipboard` \
`cd C:\git` \
`git clone git@github.com:Lifailon/PowerShell-Commands` \
`cd PowerShell-Commands` \
`git status` \
`git add -A` \
`git commit -m "test git"` \
`git push`

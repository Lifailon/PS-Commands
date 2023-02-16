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

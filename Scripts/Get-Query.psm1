function Get-Query {
    Param (
        $srv="localhost",
        $user="*"
    )
    # Создаем коллекцию - будущий объект
    $Users = New-Object System.Collections.Generic.List[System.Object]
        # Используем команду query с параметром user и именем удаленного сервера (забираем вывод в переменную)
        $query = query user /server:$srv
        # Проверяем, что перемення не пустая
        if ($null -ne $query) {
            # Перечитываем все строки
            $usr = $query[1..100]
            # Удаляем лишние пробелы
            $usr = $usr -replace "(^\s)|(^\>)"
            $usr = $usr -replace "\s{2,100}"," "
            # Формируем массив из полученого вывода, где каждая новая строка будет выступать элементом цикла
            $split1 = $usr -split "\n"
            # Отправляем массив в цикл
            foreach ($s in $split1) {
            # Формируем массив из слов разделенных пробелами
            $split2 = $s -split "\s"
            # Проверяем количество элементов в массиве строки
            if ($split2.Count -eq 6) {
                # Если длина 2-го элемента в массиве равна 4, значит сессия отключена
                if ($split2[2].Length -eq 4) {
                    $status = "Disconnect"
                }
                # Если 6 или 7 - активна (зависит от локализации)
                elseif (($split2[2].Length -eq 6) -or ($split2[2].Length -eq 7)) {
                    $status = "Active"
                }
                # Заполняем коллекцию значениями из массива строки
                $Users.Add([PSCustomObject]@{
                    User = $split2[0]
                    Session = $null
                    ID = $split2[1]
                    Status = $status
                    IdleTime = $split2[3]
                    LogonTime = $split2[4]+" "+$split2[5]
                })
            }
            if ($split2.Count -eq 7) {
                if ($split2[3].Length -eq 4) {
                    $status = "Disconnect"
                } 
                elseif (($split2[3].Length -eq 6) -or ($split2[3].Length -eq 7)) {
                    $status = "Active"
                }
                $Users.Add([PSCustomObject]@{
                    User = $split2[0]
                    Session = $split2[1]
                    ID = $split2[2]
                    Status = $status
                    IdleTime = $split2[4]
                    LogonTime = $split2[5]+" "+$split2[6]
                })
            }
        }
    }
    $Users
}

# Get-Query 192.168.3.100
# User      : lifailon
# Session   : rdp-tcp#34
# ID        : 1
# Status    : Active
# IdleTime  : 2:24
# LogonTime : 16.12.2023 11:11
# 
# 
# Get-Query 192.168.3.100
# User      : lifailon
# Session   :
# ID        : 1
# Status    : Disconnect
# IdleTime  : .
# LogonTime : 16.12.2023 11:11
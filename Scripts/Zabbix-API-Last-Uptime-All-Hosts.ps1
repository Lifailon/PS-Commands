$ip = "192.168.3.102"
$url = "http://$ip/zabbix/api_jsonrpc.php"
$token = "914ee100f4e8c4b68a70eab2a0a1fb153cfcd4905421d0ffacb82c20a57aa50e"

function ConvertFrom-UnixTime {
    param (
        $intime
    )
    $EpochTime = [DateTime]"1/1/1970"
    $TimeZone = Get-TimeZone
    $UTCTime = $EpochTime.AddSeconds($intime)
    $UTCTime.AddMinutes($TimeZone.BaseUtcOffset.TotalMinutes)
}

function ConvertTo-TimeSpan {
    param (
        $insec
    )
    $TimeSpan = [TimeSpan]::fromseconds($insec)
    "{0:dd' day 'hh\:mm\:ss}" -f $TimeSpan
}

### Получить список всех хостов (имя и id) 
$data = @{
    "jsonrpc"="2.0";
    "method"="host.get";
    "params"=@{
        "output"=@(
            "hostid";
            "host";
        );
    };
    "id"=2;
    "auth"=$token;
}
$hosts = (Invoke-RestMethod -Method POST -Uri $url -Body ($data | ConvertTo-Json) -ContentType "application/json").Result

### Получить id элемента данных по наименованию ключа для каждого хоста
$Collections = New-Object System.Collections.Generic.List[System.Object]
foreach ($h in $hosts) {
    $data = @{
        "jsonrpc"="2.0";
        "method"="item.get";
        "params"=@{
            "hostids"=@($h.hostid);
        };
        "auth"=$token;
        "id"=1;
    }
    $items = (Invoke-RestMethod -Method POST -Uri $url -Body ($data | ConvertTo-Json) -ContentType "application/json").Result
    $items_id = ($items | Where-Object key_ -match system.uptime).itemid
    if ($items_id -ne $null) {
        $Collections.Add([PSCustomObject]@{
            host = $h.host;
            hostid = $h.hostid;
            item_id_uptime = $items_id
        })
    }
}

### Получить всю историю элемента данных по его id для каждого хоста 
$Collections_output = New-Object System.Collections.Generic.List[System.Object]
foreach ($c in $Collections) {
    $data = @{
        "jsonrpc"="2.0";
        "method"="history.get";
        "params"=@{
            "hostids"=$c.hostid;
            "itemids"=$c.item_id_uptime;
        };
        "auth"=$token;
        "id"=1;
    }
    $items_data_uptime = (Invoke-RestMethod -Method POST -Uri $url -Body ($data | ConvertTo-Json) -ContentType "application/json").Result

    ### Convert Secconds To TimeSpan and DateTime
    $sec = $items_data_uptime.value
    $UpTime = ConvertTo-TimeSpan $sec[-1]
    
    ### Convert From Unix Time
    $time = $items_data_uptime.clock
    $GetDataTime = ConvertFrom-UnixTime $time[-1] 

    $Collections_output.Add([PSCustomObject]@{
        host = $c.host;
        hostid = $c.hostid;
        item_id_uptime = $c.item_id_uptime;
        GetDataTime = $GetDataTime
        UpTime = $UpTime
    })
}
$Collections_output | Format-Table
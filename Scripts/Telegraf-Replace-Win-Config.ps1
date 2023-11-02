$local_path    = "D:\Telegraf-Replace-Win-Config"
$remote_path   = "D:\Telegraf"
$csv           = Get-Content "$local_path\win-all-nt.csv"
$conf          = Get-Content "$local_path\telegraf.conf" -Raw -Encoding UTF8
$srv_name_list = ($csv | ConvertFrom-Csv -Delimiter ",").name
foreach ($srv in $srv_name_list) {
    #$srv = "tvsds-polit0110.delta.sbrf.ru"
    $session = New-PSSession $srv -ErrorAction Ignore
    if ($session) {
        Invoke-Command -Session $session {
            $name = (Get-WmiObject -Class Win32_ComputerSystem).Name+"."+(Get-WmiObject -Class Win32_ComputerSystem).Domain
            $local_conf  = "$using:remote_path\telegraf.conf"
            $remote_conf = $using:conf
            if (Test-Path $local_conf) {
                Write-Host "Telegraf path to $name - true" -ForegroundColor Green
                Get-Service telegraf | Stop-Service
                #(Get-Filehash -Algorithm SHA256 $local_conf).Hash
                $remote_conf | Out-File $local_conf -Encoding UTF8
                #(Get-Filehash -Algorithm SHA256 $local_conf).Hash
                Get-Service telegraf | Start-Service -ErrorAction Ignore
                $status = Get-Service telegraf | Select-Object
                if ($status.Status -eq "Stopped") {
                    Get-Service telegraf | Start-Service -ErrorAction Ignore
                    $status = $(Get-Service telegraf | Select-Object)
                }
                if ($status.Status -eq "Stopped") {
                    Write-Host "Telegraf service $($status.Status) to $($using:srv)" -ForegroundColor Red
                } else {
                    Write-Host "Telegraf service $($status.Status) to $($using:srv)" -ForegroundColor Green
                }
            } else {
                Write-Host "Telegraf path to $name - false" -ForegroundColor Red
            }
        }
        Disconnect-PSSession $session > $null
        Remove-PSSession $session > $null
    } else {
        Write-Host "Connect to $srv - false" -ForegroundColor Red
    }
}
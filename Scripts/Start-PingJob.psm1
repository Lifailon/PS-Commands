function Start-PingJob ($Network) {
$RNetwork = $Network -replace "\.\d{1,3}$","."
foreach ($4 in 1..254) {
$ip = $RNetwork+$4
# создаем задания, забираем 3-ю строку вывода и добавляем к выводу ip-адрес:
(Start-Job {"$using:ip : "+(ping -n 1 -w 50 $using:ip)[2]}) | Out-Null
}
while ($True){
$status_job = (Get-Job).State[-1] # забираем статус последнего задания
if ($status_job -like "Completed"){ # проверяем на выполнение (задания выполняются по очереди сверху вниз)
$ping_out = Get-Job | Receive-Job # если выполнен, забираем вывод всех заданий
Get-Job | Remove-Job -Force # удаляем задания
$ping_out
break # завершаем цикл
}}
}

# Start-PingJob -Network 192.168.3.0
# (Measure-Command {Start-PingJob -Network 192.168.3.0}).TotalSeconds # 60 Seconds
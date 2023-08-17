$Trigger = New-ScheduledTaskTrigger –AtLogon
$Action = New-ScheduledTaskAction -Execute "$home\Documents\DNS-Change-Tray-1.3.exe"
Register-ScheduledTask -TaskName "DNS-Change-Tray-Startup" -Trigger $Trigger -Action $Action -RunLevel Highest –Force
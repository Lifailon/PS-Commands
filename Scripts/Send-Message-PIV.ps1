$Username = "support@domain.local";
$Password = "password";
$SendTo = "admin@domain.ru";
$MailServer = "mail.domain.ru";
$HostName = $args[0];
$IPAddress = $args[1];
$PingStatus = $args[2];
$FailedOn = $args[3];

$message = new-object Net.Mail.MailMessage;
$message.From = $Username;
$message.To.Add($SendTo);
$message.Subject = "Ping Info View";
$message.Body = "Failed ping: `r`nHost Name: $HostName`r`nIP Address: $IPAddress`r`nPing Status: $PingStatus`r`nPing Time: $FailedOn";

$smtp = new-object Net.Mail.SmtpClient($MailServer, "25");
$smtp.EnableSSL = $true;
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$smtp.send($message);

# F9 - Advanced Options - Execute the following command on failed ping:
# Powershell.exe -executionpolicy remotesigned -File С:\Send-Message-PIV.ps1 "%HostName%" "%IPAddress%" "%LastPingStatus%" "%LastFailedOn%"
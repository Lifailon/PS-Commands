function Send-SMTP {
param (
[Parameter(Mandatory = $True)]$mess
)
$srv_smtp = "smtp.yandex.ru" 
$port = "587"
$from = "login1@yandex.ru" 
$to = "login2@yandex.ru" 
$user = "login1"
$pass = "password"
$subject = "Service status on Host: $hostname"
$Message = New-Object System.Net.Mail.MailMessage
$Message.From = $from
$Message.To.Add($to) 
$Message.Subject = $subject 
$Message.IsBodyHTML = $true 
$Message.Body = "<h1> $mess </h1>"
$smtp = New-Object Net.Mail.SmtpClient($srv_smtp, $port)
$smtp.EnableSSL = $true 
$smtp.Credentials = New-Object System.Net.NetworkCredential($user, $pass);
$smtp.Send($Message) 
}

# Send-SMTP $(Get-Service)
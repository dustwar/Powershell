$msolcred = get-credential

Send-MailMessage –From no-reply@jminsure.com –To dustinswarner@hotmail.com –Subject “Test Email” –Body “Test SMTP Relay Service” -SmtpServer smtp.office365.com -Credential $msolcred -UseSsl -Port 587
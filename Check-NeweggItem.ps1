#Script to get in stock status of product & send an alert via SMS with link to purchase

#Newegg product ID (add/modify as needed)
$G1 = "N82E16814125869"

#Using an in stock item for testing
#$Debug = "N82E16834319897"

#Created a Gmail account ahead of time which would send an email to the SMS address for my phone number
#Change $From and $To for your needs
$Cred = Get-Credential 
$From = "somegmailaccount@gmail.com"
$To = "##########@mms.provider.net"
$Subject = "GTX 1080 Alert"
$Body = "https://secure.newegg.com/Shopping/AddToCart.aspx?Submit=ADD&ItemList=" + $G1
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"

clear
Write-Host "Checking stock"

#Infinite loop - manually break (or set some break condition in the future)
While($True) {
    Write-Host '.'
    $Item = (Invoke-WebRequest -Uri "http://www.newegg.com/Product/Product.aspx?Item=$G1").Content

    If($Item | Select-String -Pattern "product_instock:\['1'\]" -Quiet) {
        Write-Host "IN STOCK - SENDING NOTIFICATION`n"
        Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $Cred
    }

    #Random sleep timer so as to not be hammering Newegg constantly with Invoke-WebRequest
    Start-Sleep -s (Get-Random -Minimum 15 -Maximum 30)
}
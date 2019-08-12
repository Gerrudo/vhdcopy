#
#blobupload_script
#

#
#Login to azure using service principle
#

#Install AzureRM if you don't already have it
#Install-Module -Name AzureRM -AllowClobber

$applicationId = "***YOURIDHERE***";

$securePassword = "***YOURPASSHERE***" | ConvertTo-SecureString -AsPlainText -Force

$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $applicationId, $securePassword

Connect-AzureRmAccount -ServicePrincipal -Credential $credential -TenantId "***YOURIDHERE***"

$getvault = Get-AzureKeyVaultSecret -VaultName '***YOURVAULTHERE***' -Name '***YOURNAMEHERE***' 

$backupkey = "https://example.blob.core.windows.net/backups" + $getvault.SecretValueText

$CurrentDateLogs = get-date -format "yyyy/MM/dd"

$path = "C:\BlobBackupLogs\$CurrentDateLogs _BlobBackupLogs.txt"

Start-Transcript -Path $path -Force

#AzCopy directory
C:\azcopy sync "C:\test" $backupkey --recursive=true

Write-Host "All files Copied to Blob"

Stop-Transcript

$CurrentDateMsg = get-date -format "dd/MM/yyyy HH:mm:ss"

#
# Discord POST
#

#Store webhook url
$webHookUrl = "https://discordapp.com/api/webhooks/***YOURKEYHERE***"

#Create embed array
[System.Collections.ArrayList]$embedArray = @()

#Store embed values
$title       = $env:COMPUTERNAME
$description = 'Azure Blob backup completed at: ' + $CurrentDateMsg 
$color       = '3722357'

#Create embed object
$embedObject = [PSCustomObject]@{

    title       = $title
    description = $description
    color       = $color

}

#Add embed object to array
$embedArray.Add($embedObject) | Out-Null

#Create the payload
$payload = [PSCustomObject]@{

    embeds = $embedArray

}

#Send over payload, converting it to JSON
Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'



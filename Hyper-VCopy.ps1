$CurrentDate = get-date -format "dd/MM/yyyy HH:mm:ss"

$CurrentDateLogs = get-date -format "yyyy/MM/dd HH:mm:ss"

$path = "C:\BackupLogs\$CurrentDateLogs.txt"

Start-Transcript -Path $path -Force

$sourceRoot = "D:\HyperV\VHDs"
$destinationRoot = "\\Poweredge\f\Hyper-V Copy\VHDs"

Copy-Item -Path $sourceRoot -Recurse -Destination $destinationRoot -Container -Force -Verbose

echo "All Files Copied to Hyper-V Copy"

Stop-Transcript

# Embed with title, description, and color

#Store webhook url
$webHookUrl = 'https://discordapp.com/api/webhooks/498468005072863233/RQLROSwcRnrrRzNDyLKPM6FYhSIuWOiKNr9t7qw-aHD7ZJGK5YhktDWHMs5_JW1bPI5r'

#Create embed array
[System.Collections.ArrayList]$embedArray = @()

#Store embed values
$title       = $env:COMPUTERNAME
$description = 'VHD backup completed at: ' + $CurrentDate 
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

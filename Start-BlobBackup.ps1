function Send-ToDiscord {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$webHookUrl,
        [Parameter(Mandatory)][string]$description
    )
    try {
        $payload = [PSCustomObject]@{
            title       = 'Backup Status'
            description = $description
            color       = "3722357"
        }

        Invoke-RestMethod -Uri $webHookUrl -Method Post -Body ($payload | ConvertTo-Json)
        Write-Host "Notification sent to Discord."
    }
    catch {
        throw "Failed sending notifation to Discord: $($PSItem.Exception.Message)"
    }
}
function Start-BlobBackup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$configPath
    )
    $config = (Get-Content $configPath | ConvertFrom-Json)
    try {
        Write-Host "Uploading Current File to Storage Account..."
        azcopy sync $config.path $config.blobSasUrl --recursive=true
        Write-Host "Upload Complete."
        Send-ToDiscord -webHookUrl $config.webHookUrl -description "Upload Complete."
    }
    catch {
        Send-ToDiscord -webHookUrl $config.webHookUrl -description "Error Uploading Current File to Storage Account: $($PSItem.Exception.Message)"
        throw "Error Uploading Current File to Storage Account: $($PSItem.Exception.Message)"
    }
}
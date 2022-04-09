function Send-ToDiscord{
    param (
        [Parameter(Mandatory)][string]$webHookUrl,
        [Parameter(Mandatory)][string]$description
    )
    try {
        $payload = [PSCustomObject]@{
            $title       = $env:COMPUTERNAME
            $description = $description
            $color       = "3722357"
        }
        Write-Host "Notification sent to Discord."
    }
    catch {
        throw "Failed sending notifation to Discord: $($PSItem.Exception.Message)"
    }
    Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json) -Method Post -ContentType 'application/json'
}
function Start-BlobUpload {
    param (
        [Parameter(Mandatory)][string]$config
    )
}
try {
    Write-Host "Uploading Current File to Storage Account..."
    $Context = New-AzStorageContext -StorageAccountName $config.storageAccountName -StorageAccountKey $config.storageAccountKey
    Set-AzStorageBlobContent -Container $config.containerName -File $config.path -Blob $config.blob -Context $Context -Force
    Write-Host "Upload Complete."
    Send-ToDiscord -webHookUrl $config.webHookUrl -description "Upload Complete."
}
catch {
    Send-ToDiscord -webHookUrl $config.webHookUrl -description "Error Uploading Current File to Storage Account: $($PSItem.Exception.Message)"
    throw "Error Uploading Current File to Storage Account: $($PSItem.Exception.Message)"
}
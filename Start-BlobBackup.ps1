$ErrorActionPreference = "Stop"

function Send-ToDiscord {
    param (
        [Parameter(Mandatory)][string]$webHookUrl,
        [Parameter(Mandatory)][PSCustomObject]$embedObject
    )
    try {
        $embedArray = @()
        $embedArray += ($embedObject)
        $payload = [PSCustomObject]@{
            embeds = $embedArray
        }
        Invoke-RestMethod -Uri $webHookUrl -ContentType "Application/Json" -Method Post -Body ($payload | ConvertTo-Json)
        Write-Host "Notification sent to Discord."
    }
    catch {
        throw "Failed sending notifation to Discord: $($PSItem.Exception.Message)"
    }
}

function Start-BlobBackup {
    param (
        [Parameter(Mandatory)][string]$configPath
    )
    $config = (Get-Content $configPath | ConvertFrom-Json)
    try {
        Write-Host "Uploading Current File to Storage Account..."
        $response = azcopy sync $config.path $config.blobSasUrl --recursive=true
        
        if ($LASTEXITCODE -ne 0) {
            throw $response
        }

        $embedObject = [PSCustomObject]@{
            color = "8311585"
            title = "YubiYubi Minecraft Server Backup Status"
            description = "Backup Complete for: $($config.path) $($response.Status)"
        }
        Write-Host "Backup Complete."
    }
    catch {
        $embedObject = [PSCustomObject]@{
            color = "13632027"
            title = "YubiYubi Minecraft Server Backup Status"
            description = "<@217741134363885568> Error Uploading $($config.path) to Storage Account: "+'```'+"$($PSItem.Exception.Message)"+'```'
        }
        Write-Warning "Upload Failed: $($PSItem.Exception.Message)"
    }
    Send-ToDiscord -webHookUrl $config.webHookUrl -embedObject $embedObject
}
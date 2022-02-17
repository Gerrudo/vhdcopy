function Start-Backup{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $source,
        [Parameter()]
        [string]
        $destination,
        [Parameter()]
        [string]
        $discordWebhookUri
    )
    try {
        Copy-Item -Path $source -Recurse -Destination $destination -Container -Force
        $payload = [PSCustomObject]@{
            $title       = $env:COMPUTERNAME
            $description = "Backup complete"
            $color       = "3722357"
        }
    }
    catch {
        Write-Error "Copy Failed with the following error: $($PSItem.Exception.Message)"
        $payload = [PSCustomObject]@{
            $title       = $env:COMPUTERNAME
            $description = "Backup failed: $($PSItem.Exception.Message)"
            $color       = "3722357" #should make this red that would be epic!!!!!!!! xD reddit poggers heccin doggo moment
        }
    }
    Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json) -Method Post -ContentType 'application/json'
}

function Start-Shutdown {
    <#
    .SYNOPSIS
    Module for shutdown and restart the computer at a specified time
    .DESCRIPTION
    Example:
    # Start-Shutdown -Time "18:00"
    # Start-Shutdown -Restart -Time "18:00"
    # Start-Shutdown -Cancel
    .LINK
    https://github.com/Lifailon/PS-Commands
    #>
    param(
        [string]$Time,
        [switch]$Restart,
        [switch]$Cancel
    )
    if ($Time) {
        $currentDateTime = Get-Date
        $shutdownTime = Get-Date $Time
        if ($shutdownTime -lt $currentDateTime) {
            $shutdownTime = $shutdownTime.AddDays(1)
        }
        $timeUntilShutdown = $shutdownTime - $currentDateTime
        $secondsUntilShutdown = [math]::Round($timeUntilShutdown.TotalSeconds)
    }
    if ($Cancel) {
        Start-Process -FilePath "shutdown.exe" -ArgumentList "/a"
    } elseif ($Restart) {
        Write-Host "The computer will restart after $($timeUntilShutdown.Hours) hours and $($timeUntilShutdown.Minutes) minutes."
        Start-Process -FilePath "shutdown.exe" -ArgumentList "/r", "/f", "/t", "$secondsUntilShutdown"
    } else {
        Write-Host "The computer will shutdown after $($timeUntilShutdown.Hours) hours and $($timeUntilShutdown.Minutes) minutes."
        Start-Process -FilePath "shutdown.exe" -ArgumentList "/s", "/f", "/t", "$secondsUntilShutdown"
    }
}
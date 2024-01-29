function Find-Process {
    param (
        $ProcessName
    )
    $PathSearchArray = @(
        "$env:SystemDrive\Program Files",
        "$env:SystemDrive\Program Files (x86)",
        "$env:HOMEPATH\AppData\Roaming",
        "$env:HOMEPATH\Documents"
    )
    foreach ($PathSearch in $PathSearchArray) {
        $ProcessPath = (Get-ChildItem $PathSearch | Where-Object Name -match $ProcessName).FullName
        if ($null -ne $ProcessPath) {
            break
        }
    }
    $ProcessNameExec = "$($ProcessName).exe"
    (Get-ChildItem $ProcessPath -Recurse | Where-Object Name -eq $ProcessNameExec).FullName
}

# Find-Process OpenHardwareMonitor # C:\Users\lifailon\Documents\OpenHardwareMonitor-0.9.6\OpenHardwareMonitor-0.9.6\OpenHardwareMonitor.exe
# Find-Process qbittorrent # C:\Program Files\qBittorrent\qbittorrent.exe
# Find-Process nmap # C:\Program Files (x86)\Nmap\nmap.exe
# Find-Process telegram # C:\Users\lifailon\AppData\Roaming\Telegram Desktop\Telegram.exe
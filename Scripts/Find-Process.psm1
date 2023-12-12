function Find-Process {
    param (
        $ProcessName
    )
    $ProcessPath = (Get-ChildItem "C:\Program Files" | Where-Object Name -match $ProcessName).FullName
    if ($null -eq $ProcessPath) {
        $ProcessPath = (Get-ChildItem "C:\Program Files (x86)" | Where-Object Name -match $ProcessName).FullName
    }
    if ($null -eq $ProcessPath) {
        $ProcessPath = (Get-ChildItem "C:\Users\lifailon\AppData\Roaming" | Where-Object Name -match $ProcessName).FullName
    }
    $ProcessNameExec = "$ProcessName"+".exe"
    (Get-ChildItem $ProcessPath -Recurse | Where-Object Name -eq $ProcessNameExec).FullName
}

# Find-Process qbittorrent # C:\Program Files\qBittorrent\qbittorrent.exe
# Find-Process nmap # C:\Program Files (x86)\Nmap\nmap.exe
# Find-Process telegram # C:\Users\lifailon\AppData\Roaming\Telegram Desktop\Telegram.exe
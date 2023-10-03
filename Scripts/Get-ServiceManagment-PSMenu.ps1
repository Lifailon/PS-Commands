### Var
$ServiceName = "*sshd*"		# formate wildcard (*)
$Server      = "localhost"	# default

$server_list = @(
"192.168.3.99",
"192.168.3.100"
)

### Console Size
# $size = $Host.UI.RawUI.WindowSize
# $size.Width = 30
# $size.Height = 25
# $Host.UI.RawUI.WindowSize = $size
# $title = $Host.UI.RawUI.WindowTitle
# $title = "Menu Service Start-Stop"
# $Host.UI.RawUI.WindowTitle = $title

### Module ps-menu
### Source: https://github.com/chrisseroka/ps-menu
function DrawMenu {
    param ($menuItems, $menuPosition, $Multiselect, $selection)
    $l = $menuItems.length
    for ($i = 0; $i -le $l;$i++) {
		if ($menuItems[$i] -ne $null){
			$item = $menuItems[$i]
			if ($Multiselect)
			{
				if ($selection -contains $i){
					$item = '[x] ' + $item
				}
				else {
					$item = '[ ] ' + $item
				}
			}
			if ($i -eq $menuPosition) {
				Write-Host "> $($item)" -ForegroundColor Green
			} else {
				Write-Host "  $($item)"
			}
		}
    }
}

function Toggle-Selection {
	param ($pos, [array]$selection)
	if ($selection -contains $pos){ 
		$result = $selection | where {$_ -ne $pos}
	}
	else {
		$selection += $pos
		$result = $selection
	}
	$result
}

function Menu {
    param ([array]$menuItems, [switch]$ReturnIndex=$false, [switch]$Multiselect)
    $vkeycode = 0
    $pos = 0
    $selection = @()
    if ($menuItems.Length -gt 0)
	{
		try {
			[console]::CursorVisible=$false #prevents cursor flickering
			DrawMenu $menuItems $pos $Multiselect $selection
			While ($vkeycode -ne 13 -and $vkeycode -ne 27) {
				$press = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown")
				$vkeycode = $press.virtualkeycode
				If ($vkeycode -eq 38 -or $press.Character -eq 'k') {$pos--}
				If ($vkeycode -eq 40 -or $press.Character -eq 'j') {$pos++}
				If ($vkeycode -eq 36) { $pos = 0 }
				If ($vkeycode -eq 35) { $pos = $menuItems.length - 1 }
				If ($press.Character -eq ' ') { $selection = Toggle-Selection $pos $selection }
				if ($pos -lt 0) {$pos = 0}
				If ($vkeycode -eq 27) {$pos = $null }
				if ($pos -ge $menuItems.length) {$pos = $menuItems.length -1}
				if ($vkeycode -ne 27)
				{
					$startPos = [System.Console]::CursorTop - $menuItems.Length
					[System.Console]::SetCursorPosition(0, $startPos)
					DrawMenu $menuItems $pos $Multiselect $selection
				}
			}
		}
		finally {
			[System.Console]::SetCursorPosition(0, $startPos + $menuItems.Length)
			[console]::CursorVisible = $true
		}
	}
	else {
		$pos = $null
	}

    if ($ReturnIndex -eq $false -and $pos -ne $null)
	{
		if ($Multiselect){
			return $menuItems[$selection]
		}
		else {
			return $menuItems[$pos]
		}
	}
	else 
	{
		if ($Multiselect){
			return $selection
		}
		else {
			return $pos
		}
	}
}

### Get-Menu
function Get-Menu ($server) {
	Write-Host
	$sn = $ServiceName -replace "\*"
	$menu = menu @("Get Services $sn", "Start Services $sn", "Stop Services $sn", "Restart Services $sn", "Select Server") -ReturnIndex
	if ($menu -eq 0) {
		Get-ServiceColor
		Get-Menu -server $server
	}
	elseif ($menu -eq 1) {
		Get-Service $ServiceName -ComputerName $server | Start-Service
		Get-ServiceColor
		Get-Menu -server $server
	}
	elseif ($menu -eq 2) {
		Get-Service $ServiceName -ComputerName $server | Stop-Service -Force
		Get-ServiceColor
		Get-Menu -server $server
	}
	elseif ($menu -eq 3) {
		Get-Service $ServiceName -ComputerName $server | Restart-Service -Force
		Get-ServiceColor
		Get-Menu -server $server
	}
	elseif ($menu -eq 4) {
		Write-Host
		$select_servers = menu $server_list
		$server         = $select_servers
		clear
		Get-Menu -server $server
	}
}

### Get-Service
function Get-ServiceColor {
	clear
	$services = Get-Service $ServiceName -ComputerName $server
	Write-Host
	foreach ($s in $services) {
		$name = $s.Name
		$stat = $s.Status
		if ($stat -eq "Running") {
			Write-Host "  $server " -NoNewline
			Write-Host "$stat " -ForegroundColor Green -NoNewline
			Write-Host "$Name"
		}
		elseif ($stat -eq "Stopped") {
			Write-Host "$stat " -ForegroundColor Red -NoNewline
			Write-Host "$Name"
		}
	}
	Write-Host
}

clear
Get-Menu -server $server
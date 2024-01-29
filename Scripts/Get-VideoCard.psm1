function Get-VideoCard {
    $VideoCard = Get-CimInstance Win32_VideoController | Select-Object @{
    Label="VideoCard"; Expression={$_.Name}}, @{Label="Display"; Expression={
    [string]$_.CurrentHorizontalResolution+"x"+[string]$_.CurrentVerticalResolution}}, 
    @{Label="vRAM"; Expression={($_.AdapterRAM/1Gb)}}
    $CollectionVC = New-Object System.Collections.Generic.List[System.Object]
    $VideoCard | ForEach-Object {
        $CollectionVC.Add([PSCustomObject]@{
            Model    = $_.VideoCard
            Display  = $_.Display
            VideoRAM = [string]$([int]$($_.vRAM))+" Gb"
        })
    }
    $CollectionVC
}
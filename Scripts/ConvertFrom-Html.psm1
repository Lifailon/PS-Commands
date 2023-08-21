function ConvertFrom-Html {
    param (
        [Parameter(ValueFromPipeline)]$url
    )
    $irm = Invoke-RestMethod $url
    $HTMLFile = New-Object -ComObject HTMLFile
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($irm)
    $HTMLFile.write($Bytes)
    ($HTMLFile.all | where {$_.tagname -eq "body"}).innerText
}

# $apache_status = "http://192.168.3.102/server-status"
# $apache_status | ConvertFrom-Html
function Get-WebCertificate ($srv) {
    $iwr = iwr $srv
    $status_code = $iwr.StatusCode
    $status = $iwr.BaseResponse.StatusCode
    $info = $iwr.BaseResponse.Server
    $spm = [System.Net.ServicePointManager]::FindServicePoint($srv)
    $date_end = $spm.Certificate.GetExpirationDateString()
    $cert_name = ($spm.Certificate.Subject) -replace "CN="
    $cert_owner = ((($spm.Certificate.Issuer) -split ", ") | where {$_ -match "O="}) -replace "O="
    $Collections = New-Object System.Collections.Generic.List[System.Object]
    $Collections.Add([PSCustomObject]@{
    Host = $srv;
    Server = $info;
    Status =  $status;
    StatusCode = $status_code;
    Certificate = $cert_name;
    Issued = $cert_owner;
    End = $date_end
    })
    $Collections
}
    
# Get-WebCertificate https://google.com
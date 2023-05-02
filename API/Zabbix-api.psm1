<# 
 .Synopsis
  Open a session to the zabbix server

 .Description
  Open a session to the zabbix server

 .Parameter PSCredential
  Credential to connect to zabbix server

 .Parameter IPAdress
  Accept IP adress and domain name

 .Parameter UseSSL
  Switch to use https, leave empty to use http

 .Example
   Connect-Zabbix -User admin -Password zabbix -IPAdress 10.0.0.1
   Connect to Zabbix server by IP adresse

 .Example
   Connect-Zabbix -User admin -Password zabbix -IPAdress zabbix.domain.lan -UseSSL
   Connect to Zabbix server by domain name with SSL
#>
Function Connect-Zabbix {
    Param (
        [Parameter(Mandatory=$True)]
        [PSCredential]$PSCredential
        ,
        [Parameter(Mandatory=$True)]
        [string]$IPAdress
        ,
        [Switch]$UseSSL
    )
    $Body = @{
	    jsonrpc = "2.0"
	    method = "user.login"
	    params = @{
		    user = $PSCredential.UserName
		    password = $PSCredential.GetNetworkCredential().Password
	    }
	    id = 1
	    auth = $null
    }

    $BodyJSON = ConvertTo-Json $Body

    Switch ($UseSSL.IsPresent) {
        $False {$Protocol = "http"}
        $True {$Protocol = "https"}
    }
    $URL = $Protocol+"://$IPAdress/zabbix"
    $Res = Invoke-RestMethod ("$URL/api_jsonrpc.php") -ContentType "application/json" -Body $BodyJSON -Method Post

    if (($Res | Get-Member | Select-Object -ExpandProperty Name) -contains "result") {
        #Connection successful
        $Global:ZabbixSession = $Res | Select-Object jsonrpc,@{Name="Session";Expression={$_.Result}},id,@{Name="URL";Expression={$URL}}
        Write-Host ("Successfuly connected to " + $URL)
    }
    else {
        #Connection error
        $Res.error
    }
}

<# 
 .Synopsis
  Get all host monitored from zabbix server

 .Description
  Get all host monitored from zabbix server

 .Parameter HostName
  To filter by name of the host

 .Parameter HostID
  To filter by id of the host

 .Example
   # Get all hosts managed by zabbix server
   Get-ZabbixHost

 .Example
   # Get info about Server1 host
   Get-ZabbixHost -HostName Server1

 .Example
   # Get info about 10123 ID
   Get-ZabbixHost -HostID 10123
#>
Function Get-ZabbixHost {
    Param (
        $HostName
        ,
        $HostID
    )
    $Body = @{
	    jsonrpc = $ZabbixSession.jsonrpc
	    method = "host.get"
	    params = @{
		    output = "extend"
            selectGroups = @(
                "groupid",
                "name"
            )
            selectParentTemplates = @(
                "templateid",
                "name"
            )
		    filter = @{
			    host = $HostName
		    }
            hostids = $HostID
	    }
	    id = $ZabbixSession.id
	    auth = $ZabbixSession.Session
    }

    $BodyJSON = ConvertTo-Json $Body
    $Res =  Invoke-RestMethod ($ZabbixSession.URL + "/api_jsonrpc.php") -ContentType "application/json" -Body $BodyJSON -Method Post

    if (($Res | Get-Member | Select-Object -ExpandProperty Name) -contains "result") {
        #Command successful
        $Res.result
    }
    else {
        #Command error
        $Res.error
    }
}

<# 
 .Synopsis
  Get all templates from zabbix server

 .Description
  Get all templates from zabbix server

 .Parameter TemplateName
  To filter by name of the template

 .Parameter TemplateID
  To filter by id of the template

 .Example
   # Get all templates from zabbix server
   $Session | Get-ZabbixTemplate

 .Example
   # Get info about Template1
   Get-ZabbixTemplate -TemplateName Template1

 .Example
   # Get info about 10001 ID
   Get-ZabbixTemplate -TemplateID 10001
#>
Function Get-ZabbixTemplate {
    Param (
        $TemplateName
        ,
        $TemplateID
    )
    $Body = @{
	    jsonrpc = $ZabbixSession.jsonrpc
	    method = "template.get"
	    params = @{
		    output = "extend"
		    selectHosts = "extend"
		    filter = @{
			    host = $TemplateName
		    }
            templateids = $TemplateID
	    }
	    id = $ZabbixSession.id
	    auth = $ZabbixSession.Session
    }

    $BodyJSON = ConvertTo-Json $Body
    $Res =  Invoke-RestMethod ($ZabbixSession.URL + "/api_jsonrpc.php") -ContentType "application/json" -Body $BodyJSON -Method Post

    if (($Res | Get-Member | Select-Object -ExpandProperty Name) -contains "result") {
        #Command successful
        $Res.result | Select-Object Name,TemplateID,@{Name="HostsMembers";Expression={$_.hosts.hostid}}
    }
    else {
        #Command error
        $Res.error
    }
}

<# 
 .Synopsis
  Get all groups from zabbix server

 .Description
  Get all groups from zabbix server

 .Parameter GroupName
  To filter by name of the group

 .Parameter GroupID
  To filter by id of the group

 .Example
   # Get all groups from zabbix server
   $Session | Get-ZabbixGroup

 .Example
   # Get info about Group1
   Get-ZabbixGroup -GroupName Group1

 .Example
   # Get info about 10001 ID
   Get-ZabbixGroup -GroupID 10001
#>
Function Get-ZabbixGroup {
    Param (
        $GroupName
        ,
        $GroupID
    )
    $Body = @{
	    jsonrpc = $ZabbixSession.jsonrpc
	    method = "hostgroup.get"
	    params = @{
		    output = "extend"
            selectHosts = @(
                "hostid",
                "host"
            )
		    filter = @{
			    name = $GroupName
		    }
        groupids = $GroupID
	    }
	    id = $ZabbixSession.id
	    auth = $ZabbixSession.Session
    }

    $BodyJSON = ConvertTo-Json $Body
	$Res =  Invoke-RestMethod ($ZabbixSession.URL + "/api_jsonrpc.php") -ContentType "application/json" -Body $BodyJSON -Method Post

    if (($Res | Get-Member | Select-Object -ExpandProperty Name) -contains "result") {
        #Command successful
        $Res.result
    }
    else {
        #Command error
        $Res.error
    }
}

<# 
 .Synopsis
  Create new host to monitor from zabbix server

 .Description
  Create new host to monitor from zabbix server

 .Parameter HostName
  HostName of the host as it will display on zabbix

 .Parameter IP
  IP adress to supervise the host

 .Parameter DNSName
  Domain name to supervise the host

 .Parameter Port
  Port to supervise the host

 .Parameter GroupID
  ID of the group where add the host

 .Parameter TemplateID
  ID of the template where add the host

 .Parameter MonitorByDNSName
  If used, domain name of the host will used to contact it

 .Example
   # Get all groups from zabbix server
   New-ZabbixHost -HostName Host1 -IP 10.0.0.1 -GroupID 8 -TemplateID 10001
#>
Function New-ZabbixHost {
    Param (
        [Parameter(Mandatory=$True)]
        [string]$HostName
        ,
        [string]$InterfaceType = 1
        ,
        [string]$InterfaceMain = 1
        ,
        [string]$IP
        ,
        [string]$DNSName
        ,
        [string]$Port = 10050
        ,
        [Parameter(Mandatory=$True)]
        [string]$GroupID
        ,
        $TemplateID
        ,
        [Switch]$MonitorByDNSName
    )

    Switch ($MonitorByDNSName.IsPresent) {
        $False {$ByDNSName = 1} # = ByIP
        $True {$ByDNSName = 0} # = ByDomainName
    }
    $Body = @{
        jsonrpc = $ZabbixSession.jsonrpc
        method = "host.create"
        params = @{
            host = $HostName
            interfaces = @(
                @{
                    type = $InterfaceType
                    main = $InterfaceMain
                    useip = $ByDNSName
                    ip = $IP
                    dns = $DNSName
                    port = $Port
                }
            )
            groups = @(
                @{
                    groupid = $GroupID
                }
            )
            templates = @(
                @{
                    templateid = $TemplateID
                }
            )
        }
        auth = $ZabbixSession.Session
        id = $ZabbixSession.id
    }

    $BodyJSON = ConvertTo-Json $Body -Depth 3
	$Res =  Invoke-RestMethod ($ZabbixSession.URL + "/api_jsonrpc.php") -ContentType "application/json" -Body $BodyJSON -Method Post

    if (($Res | Get-Member | Select-Object -ExpandProperty Name) -contains "result") {
        #Command successful
        $Res.result | Select-Object @{Name="hostids";Expression={$_.hostids[0]}}
    }
    else {
        #Command error
        $Res.error
    }
}

<# 
 .Synopsis
  Get all zabbix proxy

 .Description
  Get all zabbix proxy

 .Parameter HostName
  To filter by name of the proxy

 .Parameter ProxyId
  To filter by id of the proxy

 .Parameter WithHosts
  Switch to show hosts supervised by the proxy 

 .Example
   # Get all hosts managed by zabbix server
   Get-ZabbixProxy

 .Example
   # Get info about Server1 host
   Get-ZabbixProxy -HostName ZabbixProxy1
#>
Function Get-ZabbixProxy {
    Param (
        $HostName
        ,
        $ProxyId
        ,
        [Switch]$WithHosts
    )

    Switch ($WithHosts.IsPresent) {
        $False {$SelectHosts = $null} # = Without hosts
        $True {$SelectHosts = "extend"} # = With hosts
    }

    $Body = @{
	    jsonrpc = $ZabbixSession.jsonrpc
	    method = "proxy.get"
	    params = @{
		    output = "extend"
            selectInterface = "extend"
            proxyids = $ProxyId
		    filter = @{
			    host = $HostName
		    }
            selectHosts = $SelectHosts
	    }
	    id = $ZabbixSession.id
	    auth = $ZabbixSession.Session
    }

    $BodyJSON = ConvertTo-Json $Body
	$Res =  Invoke-RestMethod ($ZabbixSession.URL + "/api_jsonrpc.php") -ContentType "application/json" -Body $BodyJSON -Method Post

    if (($Res | Get-Member | Select-Object -ExpandProperty Name) -contains "result") {
        #Command successful
        $Res.result
    }
    else {
        #Command error
        $Res.error
    }
}

<# 
 .Synopsis
  Update the Zabbix proxy of a host

 .Description
  Update the Zabbix proxy of a host

 .Parameter HostID
  ID of the host you want to update

 .Parameter ProxyId
  ID of the Zabbix proxy which will supervise the host

 .Example
  The host with the ID 10266 will be supervised by Zabbix Server himself
  Set-ZabbixHostProxy -HostID 10266 -ProxyId 0

  .Example
  The host with the ID 10266 will be supervised by the Zabbix proxy with the ID 10267
  Set-ZabbixHostProxy -HostID 10266 -ProxyId 10267
#>
Function Set-ZabbixHostProxy {
    Param (
        [Parameter(Mandatory=$True)]
        [int]$HostID
        ,
        [Parameter(Mandatory=$True)]
        [int]$ProxyId
    )

    if ($HostID -eq 0) {
        Write-Error "Please enter a Host ID"
        break
    }

    $Body = @{
	    jsonrpc = $ZabbixSession.jsonrpc
	    method = "host.update"
	    params = @{
            hostid = $HostID
            proxy_hostid = $ProxyId
	    }
	    id = $ZabbixSession.id
	    auth = $ZabbixSession.Session
    }

    $BodyJSON = ConvertTo-Json $Body
	$Res =  Invoke-RestMethod ($ZabbixSession.URL + "/api_jsonrpc.php") -ContentType "application/json" -Body $BodyJSON -Method Post

    if (($Res | Get-Member | Select-Object -ExpandProperty Name) -contains "result") {
        #Command successful
        $Res.result
    }
    else {
        #Command error
        $Res.error
    }
}

Function Get-ZabbixItem {
    Param (
        [int]$HostID
        ,
        [int]$ItemID
        ,
        [string]$ItemName
        ,
        [Switch]$Debug
    )
    $Body = @{
	    jsonrpc = $ZabbixSession.jsonrpc
	    method = "item.get"
	    params = @{
		    output = "extend"
            hostids = $HostID
            itemids = $ItemID
		    search = @{
                #name = $ItemName
			    #key_ = "system"
		    }
            sortfield = "name"
	    }
	    id = $ZabbixSession.id
	    auth = $ZabbixSession.Session
    }

    $BodyJSON = ConvertTo-Json $Body
    Switch ($Debug.IsPresent) {
        $True {Write-Host $BodyJSON -ForegroundColor Yellow}
    }
	$Res =  Invoke-RestMethod ($ZabbixSession.URL + "/api_jsonrpc.php") -ContentType "application/json" -Body $BodyJSON -Method Post
    Switch ($Debug.IsPresent) {
        $True {Write-Host $Res -ForegroundColor Yellow}
    }
    if (($Res | Get-Member | Select-Object -ExpandProperty Name) -contains "result") {
        #Command successful
        $Res.result
    }
    else {
        #Command error
        $Res.error
    }
}

Function Get-ZabbixHostInterface {
    Param (
        $HostID
    )
    $Body = @{
	    jsonrpc = $ZabbixSession.jsonrpc
	    method = "hostinterface.get"
	    params = @{
		    output = "extend"
            hostids = $HostID
	    }
	    id = $ZabbixSession.id
	    auth = $ZabbixSession.Session
    }

    $BodyJSON = ConvertTo-Json $Body
    $Res =  Invoke-RestMethod ($ZabbixSession.URL + "/api_jsonrpc.php") -ContentType "application/json" -Body $BodyJSON -Method Post

    if (($Res | Get-Member | Select-Object -ExpandProperty Name) -contains "result") {
        #Command successful
        $Res.result |
            Select-Object *,@{Name="type_name";Expression={
                switch ($_.type) {
                    "1" {"agent"; break}
                    "2" {"snmp"; break}
                    "3" {"ipmi"; break}
                    "4" {"jmx"; break}
                }
            }}
    }
    else {
        #Command error
        $Res.error
    }
}

### Fonction non fonctionnelles ###
<#
Function Add-ZabbixHostInterface {
    Param (
        [string]$HostID,
        [ValidateRange(1,4)] 
        [int]$InterfaceType = 1,
        [ValidateSet("agent","snmp","ipmi","jmx")] 
        [string]$InterfaceTypeName,
        [string]$IP,
        [string]$DNSName,
        [switch]$MonitorByDNSName,
        [int]$InterfaceMain = 0
    )

    Switch ($MonitorByDNSName.IsPresent) {
        $False {$ByDNSName = 1} # = ByIP
        $True {$ByDNSName = 0} # = ByDomainName
    }

    Switch ($InterfaceTypeName) {
        "agent" {$InterfaceType = 1; break}
        "snmp"  {$InterfaceType = 2; break}
        "ipmi"  {$InterfaceType = 3; break}
        "jmx"   {$InterfaceType = 4; break}
    }

    Switch ($InterfaceType) {
        "1" {$Port = "10050"; break}
        "2" {$Port = "161"; break}
        "3" {$Port = "623"; break}
        "4" {$Port = "11162"; break}
    }

    $Body = @{
	    jsonrpc = $ZabbixSession.jsonrpc
	    method = "hostinterface.create"
	    params = @{
            hostids = $HostID
            dns = $DNSName
            ip = $IP
            main = $InterfaceMain
            port = $Port
            type = $InterfaceType
            useip = $ByDNSName
	    }
	    id = $ZabbixSession.id
	    auth = $ZabbixSession.Session
    }

    $BodyJSON = ConvertTo-Json $Body
    Write-Host $BodyJSON
    $Res =  Invoke-RestMethod ($ZabbixSession.URL + "/api_jsonrpc.php") -ContentType "application/json" -Body $BodyJSON -Method Post

    if (($Res | Get-Member | Select-Object -ExpandProperty Name) -contains "result") {
        #Command successful
        $Res.result
    }
    else {
        #Command error
        $Res.error
    }
}

Add-ZabbixHostInterface -HostID (Get-ZabbixHost -HostName hv1).hostid -InterfaceTypeName snmp -DNSName hv1-2.maison.lan -MonitorByDNSName -IP 127.0.0.1
Get-ZabbixHostInterface -HostID (Get-ZabbixHost -HostName hv1).hostid
#>
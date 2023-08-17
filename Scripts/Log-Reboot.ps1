$query = '
<QueryList>
    <Query Id="0" Path="System">
        <Select Path="System">
		    *[
			System[
			EventID=41 or
			EventID=1074 or
			EventID=1076 or
			EventID=6005 or
			EventID=6006 or
			EventID=6008 or
			EventID=6009 or
			EventID=6013
			]
			]
        </Select>
    </Query>
</QueryList>
'
Get-WinEvent -LogName System -FilterXPath $query
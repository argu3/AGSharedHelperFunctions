function Get-AGcsvToHashtable 
{
    param($csv,$key)
    $hash = @{}
    foreach($line in $csv)
    {
        $hash[$line.$key] = $line
    }
    return $hash
}

function Read-AGhost
{
    param(
        $NewLine = $false,
        [System.Nullable[System.ConsoleColor]]$backgroundcolor,
        [System.Nullable[System.ConsoleColor]]$foregroundcolor,
        $noColon = $false,
        [Parameter(Mandatory)]
        $prompt
    )
    $params = @{}
    
    foreach($key in $PSBoundParameters.keys)
    {
        if($key -ne "prompt" -AND $key -ne "NewLine" -AND $key -ne "noColon")
        {
            if($PSBoundParameters[$key] -ne $null)
            {
                $params[$key] = $PSBoundParameters[$key]
            }
        }
    }
    $params['NoNewLine'] = !$NewLine
    if(!$noColon){$prompt = "$($prompt):"}
	#write-host "you're in read-AGHost"
    write-host $prompt @params
    return Read-Host
}

function test-AGconnection
{
        param(
	    $Count = 1,
	    $Timeout = 100,
	    [Parameter(Mandatory)]
	    $computerName
    )

    $Filter = 'Address="{0}" and Timeout={1}' -f $ComputerName, $Timeout
    $out = Get-CIMInstance -Class Win32_PingStatus -Filter $Filter |
    Select-Object Address, ResponseTime, Timeout

    if($out.ResponseTime -ne $null)
    {
	    $true
    }
    else 
    {
	    $false
    }
}

function Change-AGRemotePathToLocal
{
    param(
        [Parameter(Mandatory)]
        $remotePath
    )
    if($remotePath.contains("$"))
    {
        if($remotePath.length - $remotePath.indexOf("$") -ge 2)
        {
            return $remotePath.Replace($remotePath.Substring(0,$remotePath.IndexOf("$")+2),"C:\")
        }
        elseif($remotePath.length - $remotePath.indexOf("$") -eq 1)
        {
            return $remotePath.Replace($remotePath.Substring(0,$remotePath.IndexOf("$")+2),"C:\")   
        }
    }
    Write-Host "No $, not a valid remote path"
    return $false
}

function Format-AGExcel
{
    param(
        [string]$delimeter = "`t",
        [Alias("h")]
        [switch]$help,
        #[Parameter("Mandatory")]
        $object
    )
    if($help)
    {
        "This function takes any object and formats it so it can be pasted directly into an excel or other tab-delimited spreadsheet." | Out-host
        "-object: takes any object" | Out-Host
        "-delimeter: takes a string to act as a delimeter. defaults to tab (`t)" | Out-Host 
        "-help: shows the help window" | out-host 
        "-h: alias of '-help'" | out-host
    }
    else
    {
        $returnVal = ""
        $first = $true
        foreach($o in $object)
        {
            if($first)
            {
                $first = $false
                foreach($property in $o.psobject.properties)
                {
                    $returnVal += ([string]$property.name) + "`t"
                }
            }
            $returnVal += "`n"
            foreach($property in $o.psobject.properties)
            {
                $returnVal += ([string]$property.value) + "`t"
            }
        }
        $returnVal | clip
    }
}

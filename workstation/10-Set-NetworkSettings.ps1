# Required Variables
$Data.RequiresRestart = $False
$NetworkData = $Data.Network
$ScriptName = $MyInvocation.MyCommand.Name

# Code
$AvailableInterface = (Get-NetIPInterface -AddressFamily IPv4 -ConnectionState Connected | Where-Object {$_.InterfaceAlias -match "Ethernet"} | Select -First 1)

if (-not $AvailableInterface)
{
    Write-Host "[!] $ScriptName`: Unable to find connected interfaces to set network information on." -ForegroundColor Red
}
else
{
    New-NetIPAddress -IPAddress $NetworkData.IPv4Address -PrefixLength $NetworkData.CIDRSubnetMask -ifIndex $AvailableInterface.ifIndex -DefaultGateway $NetworkData.Gateway -AddressFamily IPv4 | Out-Null
    Set-DnsClientServerAddress -InterfaceIndex $AvailableInterface.ifIndex -ServerAddresses $NetworkData.DNSServer | Out-Null
}




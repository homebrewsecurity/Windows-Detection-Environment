# Required Variables
$Data.RequiresRestart = $False
$DomainData = $Data.Domain
$ScriptName = $MyInvocation.MyCommand.Name

# Code
Add-Computer -DomainName $DomainData.DomainName -Credential (Get-Credential -Message "Enter the domain administrator credentials" -UserName "Administrator@$($Data.Domain)")

$Data.RequiresRestart = $True

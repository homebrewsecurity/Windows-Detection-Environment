# Required Variables
$RequiresRestart = $False
$DomainData = $Data.Domain
$ScriptName = $MyInvocation.MyCommand.Name

# Code
$IsInstalled = (Get-WindowsFeature 'AD-Domain-Services' | Where-Object {$_.InstallState -eq 'Installed'})

if ($IsInstalled)
{
    Write-Host "$ScriptName`: Active Directory services already installed." -ForegroundColor Yellow
}
else
{
    # Installs the feature and imports ADDSDeployment
    Install-WindowsFeature 'AD-Domain-Services' -IncludeManagementTools
    Import-Module ADDSDeployment

    # Promotes to DC and created forest
    Install-ADDSForest -DomainName $DomainData.DomainName -InstallDNS:$true

    $RequiresRestart = $True
}

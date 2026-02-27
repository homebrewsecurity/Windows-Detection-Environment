# Required Variables
$RequiresRestart = $False
$DomainData = $Data.Domain
$ScriptName = $MyInvocation.MyCommand.Name

# Code

# Installs the feature and imports ADDSDeployment
Install-WindowsFeature 'AD-Domain-Services' -IncludeManagementTools
Import-Module ADDSDeployment

# Promotes to DC and created forest
Install-ADDSForest -DomainName $DomainData.DomainName -InstallDNS:$true

$RequiresRestart = $True


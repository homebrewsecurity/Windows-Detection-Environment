# Required Variables
$RequiresRestart = $False
$IsDefault = $Data.IncludeDefaultConfiguration
$DomainData = $Data.Domain
$ScriptName = $MyInvocation.MyCommand.Name

# Code
if ($IsDefault)
{
    # Import AD Module
    Import-Module ActiveDirectory

    # Get DN data and move to drive location
    $RootDN = (Get-ADDomain).DistinguishedName
    cd "AD:\$RootDN"

    # Create new OU structure
    New-ADOrganizationalUnit -Name 'Production'
    New-ADOrganizationalUnit -Name 'New Objects'

    cd "OU=Production,$RootDN"
    New-ADOrganizationalUnit -Name 'Clients'
    New-ADOrganizationalUnit -Name 'Servers'
    New-ADOrganizationalUnit -Name 'Users'
    New-ADOrganizationalUnit -Name 'Groups'

    # Redirect computers to the New Objects OU
    redircmp.exe "OU=New Objects,$RootDN"

    # Create new central policy definitions store
    $DefaultPolicyPath = 'C:\Windows\PolicyDefinitions'
    $NewCentralStorePath = "C:\Windows\SYSVOL\sysvol\$($DomainData.DomainName)\Policies\PolicyDefinitions"
    if (Test-Path $DefaultPolicyPath)
    {
        Copy-Item -Recurse -Path $DefaultPolicyPath -Destination $NewCentralStorePath -Force
    }

    # Create new domain admin & user account
    New-ADUser -Name "StandardUser" -Enabled:$True -AccountPassword (ConvertTo-SecureString -AsPlainText "Password123" -Force)

    New-ADUser -Name "DomainAdmin" -Enabled:$True -AccountPassword (ConvertTo-SecureString -AsPlainText "Password123" -Force)
    Start-Sleep 1
    Add-ADGroupMember -Identity "Domain Admins" -Members "DomainAdmin"

    # Reset to scriptroot path
    cd "$PSScriptRoot\.."
}



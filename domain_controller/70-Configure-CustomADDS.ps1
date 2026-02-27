# Required Variables
$RequiresRestart = $False
$IsDefault = $Data.IncludeDefaultConfiguration
$DomainData = $Data.Domain
$ScriptName = $MyInvocation.MyCommand.Name

# Code
$IsInstalled = (Get-WindowsFeature 'AD-Domain-Services' | Where-Object {$_.InstallState -eq 'Installed'})

if ($IsDefault)
{
    # Import AD Module
    Import-Module ActiveDirectory

    # Get DN data and move to drive location
    $RootDN = (Get-ADDomain).DistinguishedName
    cd "AD:\$RootDN"

    # Create new OU structure
    New-ADOrganizationalUnit -Name 'Production' -ProtectFromAccidentalDeletion:$True
    New-ADOrganizationalUnit -Name 'New Objects' -ProtectFromAccidentalDeletion:$True

    cd "OU=Production,$RootDN"
    New-ADOrganizationalUnit -Name 'Clients' -ProtectFromAccidentalDeletion:$True
    New-ADOrganizationalUnit -Name 'Servers' -ProtectFromAccidentalDeletion:$True
    New-ADOrganizationalUnit -Name 'Users' -ProtectFromAccidentalDeletion:$True
    New-ADOrganizationalUnit -Name 'Groups' -ProtectFromAccidentalDeletion:$True

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

    $AdminUser = New-ADUser -Name "DomainAdmin" -Enabled:$True -AccountPassword (ConvertTo-SecureString -AsPlainText "Password123" -Force)
    Start-Sleep 1
    Add-ADGroupMember -Identity "Domain Admins" -Members $AdminUser
}
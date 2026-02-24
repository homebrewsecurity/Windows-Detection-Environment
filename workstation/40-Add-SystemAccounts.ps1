# Required Variables
$RequiresRestart = $False
$AccountData = $Data.Accounts
$ScriptName = $MyInvocation.MyCommand.Name

# Code

# Default Admin Account
if ($AccountData.DisableDefaultAdministratorAccount)
{
    Disable-LocalUser -Name "Administrator" -ErrorAction SilentlyContinue
}
else
{
    Enable-LocalUser -Name "Administrator" -ErrorAction Continue
}
$AccountData.Remove("DisableDefaultAdministratorAccount")

# Default Guest Account
if ($AccountData.DisableGuestAccount)
{
    Disable-LocalUser -Name "Guest" -ErrorAction SilentlyContinue
}
else
{
    Enable-LocalUser -Name "Guest" -ErrorAction Continue
}
$AccountData.Remove("DisableGuestAccount")

# Other Accounts
foreach ($User in $AccountData.GetEnumerator())
{
    $UserData = $User.Value
    New-LocalUser -Name $User.Name -AccountNeverExpires $UserData.AccountNeverExpires -Description $UserData.Description -Password $UserData.Password -PasswordNeverExpires $UserData.PasswordNeverExpires -ErrorAction Continue

    if ($UserData.LocalAdmin)
    {
        Add-LocalGroupMember -Group "Administrators" -Member $User -ErrorAction SilentlyContinue
    }
}
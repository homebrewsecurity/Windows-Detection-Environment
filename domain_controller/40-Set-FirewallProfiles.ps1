# Required Variables
$Data.RequiresRestart = $False
$FirewallProfileData = $Data.FirewallProfiles
$ScriptName = $MyInvocation.MyCommand.Name

# Code

foreach ($Profile in $FirewallProfileData.GetEnumerator())
{
    $Splat = $Profile.Value
    Set-NetFirewallProfile @Splat -Profile $Profile.Name -ErrorAction Continue
}

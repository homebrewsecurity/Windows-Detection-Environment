# Required Variables
$RequiresRestart = $False
$FirewallRuleData = $Data.FirewallRules
$ScriptName = $MyInvocation.MyCommand.Name

# Code
if ($FirewallRuleData.ClearDefaultRules)
{
    Get-NetFirewallRule -PolicyStore PersistentStore | Remove-NetFirewallRule
}
$FirewallRuleData.Remove("ClearDefaultRules")

foreach ($Rule in $FirewallRuleData.GetEnumerator())
{
    $Splat = $Rule.Value
    New-NetFirewallRule @Splat -ErrorAction SilentlyContinue
}
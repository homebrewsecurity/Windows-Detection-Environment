# Required Variables
$RequiresRestart = $False
$ComputerNameData = $Data.ComputerName
$ScriptName = $MyInvocation.MyCommand.Name

# Code
if (([System.Net.Dns]::GetHostName()) -ne $ComputerNameData)
{
    Rename-Computer $ComputerNameData
    $RequiresRestart = $True
}
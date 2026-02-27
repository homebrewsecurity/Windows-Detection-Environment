# Required Variables
$Data.RequiresRestart = $False
$ComputerNameData = $Data.ComputerName
$ScriptName = $MyInvocation.MyCommand.Name

# Code
if (([System.Net.Dns]::GetHostName()) -ne $ComputerNameData)
{
    Rename-Computer $ComputerNameData
    $Data.RequiresRestart = $True

}

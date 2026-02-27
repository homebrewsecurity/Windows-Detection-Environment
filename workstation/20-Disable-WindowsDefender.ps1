# Required Variables
$Data.RequiresRestart = $False
$DefenderData = $Data.DisableWindowsDefender
$ScriptName = $MyInvocation.MyCommand.Name

# Code
if ($DefenderData)
{
    # MpPreference Settings
    Set-MpPreference -DisableTamperProtection $True
    Set-MpPreference -DisableRealtimeMonitoring $True
    Set-MpPreference -DisableScriptScanning $True

    # Registry Key Settings
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\" -Name "DisableAntiSpyware" -PropertyType DWORD -value 0x1 -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\" -Name "DisableAntivirus" -PropertyType DWORD -value 0x1 -Force

    $Data.RequiresRestart = $True
}



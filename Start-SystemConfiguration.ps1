#Requires -RunAsAdministrator
#Requires -Version 5.1

# Parameters
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [String]$ScriptsFolder
)

###############################################################
###################       Setup        ########################
###############################################################

# Checks argument passed to $ScriptsFolder parameter

if (-not (Test-Path $ScriptsFolder))
{
    Write-Error "Unable to find $ScriptsFolder or it is inaccessible."
    Exit
}

# Variables

$Data = Import-PowerShellDataFile -Path "$ScriptsFolder\Settings.psd1" -ErrorAction Stop
$Scripts = (Get-ChildItem -Recurse $ScriptsFolder -Filter "*.ps1" | Sort-Object).FullName

# If scripts were already ran, avoid running them again
# This sets the list of actual executing scripts

$ExecutingScripts = @()
$LastScriptLogged = $False
if (Test-Path "$ScriptsFolder\LastScript.psd1")
{
    $LastScript = (Import-PowerShellDataFile "$ScriptsFolder\LastScript.psd1").LastScriptLocation
    foreach ($Script in $Scripts)
    {
        if ($Script -eq $LastScript)
        {
            $LastScriptLogged = $True
        }

        if ($LastScriptLogged -and ($Script -ne $LastScript))
        {
            $ExecutingScripts += $Script
        }
    }
}
else
{
    $ExecutingScripts = $Scripts
}

###############################################################
################### Orchestration Code ########################
###############################################################

foreach ($Script in $ExecutingScripts)
{
    # Announces execution
    Write-Host "[+] ORCHESTRATOR: $Script" -ForegroundColor Blue

    # Executes script
    & $Script

    # Sets the last script location data file
    $LastScriptDataFile = @"
@{
    LastScriptLocation = "$Script"
}
"@
    # Writes the last script location
    $LastScriptDataFile | Out-File -Force -FilePath "$ScriptsFolder\LastScript.psd1"

    # Restarts machine if required
    if ($Data.RequiresRestart)
    {
        Write-Host "[!] ORCHESTRATOR: Restarting computer in 10 seconds..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        Restart-Computer
    }
}

# Ends with successful message
Write-Host "[+] ORCHESTRATOR: Successfully ran all scripts." -ForegroundColor Green





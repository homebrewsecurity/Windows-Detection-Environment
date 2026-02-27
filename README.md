# Windows-Detection-Environment
This repository provides a PowerShell orchestration script along with a modular method of applying system configurations via psuedo infrastructure-as-code for the purpose of quickly deploying an isolated virtual Windows detection engineering environment. Scripts found in this repository are not intended for production use and should only be deployed in isolated lab environments. These scripts are not secure; users are responsible for the security, management, and oversight of their own systems and environments.

# Setup
Download the files as a zipped archive or clone the repository to your system. Create two virtual machines, one Windows 11 client and one Windows Server (at least 2022). Create an private virtual network and allocate an appropriately sized subnet. Assign both virtual machines' network interfaces to the same private network. An example topology is provided below.

<img width="744" height="385" alt="image" src="https://github.com/user-attachments/assets/71714be3-a5d0-4e15-88a3-bd7252ba1b38" />

Transfer a copy of the scripts to both machines once ISOs are installed. Open 'Settings.psd1' under both script folders and change configuration settings as necessary. Open an elevated PowerShell prompt to set the execution policy (default is 'Restricted'):

```Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine```

**WARNING: The above command is not a safe or recommended configuration for execution policies. Only use this command in a testing/lab environment.**

Navigate to the folder storing the Start-SystemConfiguration.ps1' script. Depending on which machine is being configured, run the script with the -ScriptFolders parameter.

For workstations:

```.\Start-SystemConfiguration.ps1 -ScriptsFolder .\workstation\```

For the domain controller:

```.\Start-SystemConfiguration.ps1 -ScriptsFolder .\domain_controller\```

The system will reboot on its own for certain configurations. After restarting, run the same command until a green orchestration message appears in the console. The script will remember the last script that was run and will not execute previously ran commands.

# Notes
I created this script to speed up the deployment of my own lab environment after realizing the number of times I repeated the setup. However, due to the modularity of the system, users can add in their own scripts under either the domain_controller or workstation folders by incrementing the number in the filename. The orchestration script will execute all .ps1 files in ascending order given the argument specified in the -ScriptsFolder parameter.

The script sets the system hostname, configures the network interfaces, adds standard firewall rules, and configures domain-specific settings. For domain controllers, additional steps are executed, including creating standard OUs, users, configuring the central store, and redirecting new computer objects to a New Objects OU.

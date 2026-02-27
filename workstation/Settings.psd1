<#
    AUTHOR
      - Logan Bennett
    NOTES
      - This configuration file is intended to be used with the correlating orchestration script
      - Set all values to your specifications, or run this as-is
      - DO NOT use in production environments; intended use is only for isolated lab testing. This configuration is highly insecure
#>

@{
    # Self-explanatory; sets the computername
    ComputerName = "dewrk01"

    # Network information
    Network = @{
        IPv4Address = "172.20.0.5"                                   # Default is 172.20.0.5/24
        CIDRSubnetMask = "24"                                        # Numerical values only, no / or subnet masks
        Gateway = "172.20.0.1"                                      # Default environment has no gateway; if you're using inetsim, set that machine's IP here. Otherwise, the Domain Controller is currently set at the gateway
        DNSServer = "172.20.0.10"                                    # Default is the ADDS set one in DE-ADDC (172.20.0.10)
    }

    # Windows Defender disablement
    DisableWindowsDefender = $True                                   # Set to $False if you'd like to keep Windows Defender enabled

    # Local accounts
    Accounts = @{
        # Set to $False if you don't want the default accounts to be disabled

        DisableGuestAccount = $True
        DisableDefaultAdministratorAccount = $True

        LocalAdmin = @{
            Password = "Password123"
            AccountNeverExpires = $True
            PasswordNeverExpires = $True
            Description = "This is the local administrator account for use in DE."
            LocalAdmin = $True
        }

        LocalUser = @{
            Password = "Password123"
            AccountNeverExpires = $True
            PasswordNeverExpires = $True
            Description = "This is the local non-privileged account for use in DE."
            LocalAdmin = $False
        }
    }

    # Domain information
    Domain = @{
        DomainName = "delab.local"                                         # Ensure you have proper DNS before assuming the domain name will resolve
    }

    # Firewall Profiles; all are splatted
    FirewallProfiles = @{
        Domain = @{
            Enabled = "True"
            DefaultInboundAction = "Block"
            DefaultOutboundAction = "Allow"
            AllowInboundRules = "True"
            AllowLocalFirewallRules = "True"
            AllowUserApps = "False"
            AllowUserPorts = "False"
            AllowUnicastResponseToMulticast = "True"
            NotifyOnListen = "False"
            EnableStealthModeForIPsec = "False"
            LogAllowed = "False"
            LogBlocked = "True"
            LogMaxSizeKilobytes = 32767
        }

        Private = @{
            Enabled = "True"
            DefaultInboundAction = "Block"
            DefaultOutboundAction = "Allow"
            AllowInboundRules = "True"
            AllowLocalFirewallRules = "True"
            AllowUserApps = "False"
            AllowUserPorts = "False"
            AllowUnicastResponseToMulticast = "True"
            NotifyOnListen = "False"
            EnableStealthModeForIPsec = "False"
            LogAllowed = "False"
            LogBlocked = "True"
            LogMaxSizeKilobytes = 32767
        }

        Public = @{
            Enabled = "True"
            DefaultInboundAction = "Block"
            DefaultOutboundAction = "Allow"
            AllowInboundRules = "True"
            AllowLocalFirewallRules = "True"
            AllowUserApps = "False"
            AllowUserPorts = "False"
            AllowUnicastResponseToMulticast = "True"
            NotifyOnListen = "False"
            EnableStealthModeForIPsec = "False"
            LogAllowed = "False"
            LogBlocked = "True"
            LogMaxSizeKilobytes = 32767
        }

    }

    # Firewall rules
    FirewallRules = @{

        ClearDefaultRules = $True                 # Set to $True to clear all Windows default firewall rules. $False to keep them.

        # Syntax of the rules follows PowerShell arguments for the New-NetFirewallRule
        SMB = @{
            Enabled = "True"
            DisplayName = "A_TCP_SMB"
            Profile = "Domain"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "TCP"
            LocalPort = "445"
        }

        RPCEM = @{
            Enabled = "True"
            DisplayName = "A_TCP_RPCEM"
            Profile = "Domain"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "TCP"
            LocalPort = "RPCEPMap"
        }

        RPCDyn = @{
            Enabled = "True"
            DisplayName = "A_TCP_RPCDyn"
            Profile = "Domain"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "TCP"
            LocalPort = "RPC"
        }

        ICMPEcho = @{
            Enabled = "True"
            DisplayName = "A_ICMP_8"
            Profile = "Domain"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "ICMPv4"
            ICMPType = 8
        }
    }

    <#
    # Tool installation selection; TODO
    DETools = @{
        InstallToolsManually = $False              # Set to $True to avoid this installation step if you'd like to install your own tools. Otherwise, orchestration will check for an inet connection and attempt to install tools

        ProcMon = $True
        ProcExplorer = $True
        InvokeAtomic = $True
        Cutter = $True
        x64dbg = $True
        Sysmon = $True                             # This sysmon configuration will use SwiftOnSecurity's configuration file for now (until I can upload my own custom configuration)
        Wireshark = $True
        NTObjectManager = $True                    # PowerShell module for exploring the Windows kernel and investigating security related artifacts
    }
    #>

}

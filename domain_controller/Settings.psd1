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
    ComputerName = "deaddc01"

    # Network information
    Network = @{
        IPv4Address = "172.20.0.10"                                   # Default is 172.20.0.5/24
        CIDRSubnetMask = "24"                                        # Numerical values only, no / or subnet masks
        Gateway = "0.0.0.0"                                      # Default environment has no gateway
        DNSServer = "208.67.222.222"                                    # Default is Cisco Umbrella DNS servers (safer than 8.8.8.8)
    }

    # Windows Defender disablement
    DisableWindowsDefender = $True                                   # Set to $False if you'd like to keep Windows Defender enabled

    # Domain information
    Domain = @{
        DomainName = "delab.local"                                         # Ensure you have proper DNS before assuming the domain name will resolve
    }

    # Domain-Controller Specific
    IncludeDefaultConfiguration = $True                             # This default configuration will do common tasks like redirect new objects to a New Objects OU, create my preferred OU structure, create a Domain Admin & Regular User account, and create a central store (for GPO)

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

        KerbTCP = @{
            Enabled = "True"
            DisplayName = "A_TCP_KRB"
            Profile = "Any"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "TCP"
            LocalPort = 88
        }

        KerbUDP = @{
            Enabled = "True"
            DisplayName = "A_UDP_KRB"
            Profile = "Any"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "UDP"
            LocalPort = 88
        }

        DNS = @{
            Enabled = "True"
            DisplayName = "A_UDP_DNS"
            Profile = "Any"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "UDP"
            LocalPort = 53
        }

        LDAPTCP = @{
            Enabled = "True"
            DisplayName = "A_TCP_LDAP"
            Profile = "Any"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "TCP"
            LocalPort = 389
        }

        LDAPUDP = @{
            Enabled = "True"
            DisplayName = "A_UDP_LDAP"
            Profile = "Any"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "UDP"
            LocalPort = 389
        }

        ADWS = @{
            Enabled = "True"
            DisplayName = "A_TCP_ADWS"
            Profile = "Domain"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "TCP"
            LocalPort = 9389
        }

        NTP = @{
            Enabled = "True"
            DisplayName = "A_UDP_NTP"
            Profile = "Domain"
            Direction = "Inbound"
            Action = "Allow"
            Protocol = "TCP"
            LocalPort = 123
        }
    }
}
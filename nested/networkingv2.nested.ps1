## First create the internal switch.
New-VMSwitch -SwitchName "IntSwitch" -SwitchType Internal
$switchAdapter = Get-NetAdapter | Where-Object {$_.ifAlias -eq "vEthernet (IntSwitch)"}
$ifIndex = $switchAdapter.ifIndex
New-NetIPAddress -IPAddress 192.168.10.1 -PrefixLength 24 -InterfaceIndex $ifIndex
# Configure the NAT.
New-NetNat -Name "myNATnet" -InternalIPInterfaceAddressPrefix 192.168.10.0/24
# Turn on PING
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
# Enable DNS
dism.exe /online /enable-feature /featurename:DNS-Server-Full-Role /featurename:DNS-Server-Tools
Add-DnsServerForwarder -IPAddress 10.50.10.50 -PassThru
Set-DnsClientServerAddress -InterfaceIndex $ifIndex -ServerAddresses ("192.168.10.1")
#Turn on DHCP
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerV4Scope -Name "DHCP Scope" -StartRange 192.168.10.10 -EndRange 192.168.10.250 -SubnetMask 255.255.255.0
Set-DhcpServerV4OptionValue -DnsServer 10.50.10.50 -DnsDomain test.local
Set-DhcpServerV4OptionValue -ScopeId 192.168.10.0 -Router 192.168.10.1
Restart-Service dhcpserver


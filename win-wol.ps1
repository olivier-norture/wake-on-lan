Param(
    [Parameter(Position=0, Mandatory=$true, HelpMessage="The MAC address of the target device in the format XX-XX-XX-XX-XX-XX.")]
    [Alias("mac", "m")]
    [ValidatePattern("^([0-9A-Fa-f]{2}[-]){5}([0-9A-Fa-f]{2})$")]
    [string]$MacAddress,
    
    [Parameter(Position=1, Mandatory=$true, HelpMessage="The hostname or IP address of the target device.")]
    [Alias("host", "h")]
    [string]$Hostname = "localhost"
)

# Convert the MAC address to a byte array
$macBytes = ($MacAddress.Split('-') | ForEach-Object { [Convert]::ToByte($_, 16) })

# Create a magic packet using the MAC address
$magicPacket = [byte[]]@(0,0,0,0,0,0) + ($macBytes * 16)

# Resolve the hostname to an IP address
$ipAddress = (Resolve-DnsName -Name $Hostname -Type A).IPAddress

# Send the magic packet to the target device
$udpClient = New-Object System.Net.Sockets.UdpClient
$udpClient.Send($magicPacket, $magicPacket.Length, $ipAddress, 9)
$udpClient.Close()
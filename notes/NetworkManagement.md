# Nomenclature

# 2 types
- ## Traditional names
- ## Predictive names

# Traditional names
- Theyre not persistent upon restart, lacks description, doesn't display the location nor the hardware that the NIC (network Interface Card) uses.
- wlan0, wlan1, eth0, eth1, lo


# Preditive names
- Persistent, descriptive.
- en, wl, ww
- #### For instance (enp2s0)
    - en: ethernet
    - p2: connected to the system bus at the position with id 2
    - s0: device 0


# Commands
## ifconfig
- `ifconfig`: lists all active network interfaces
- `ifconfig <network_inteface> {up, dow}`: activate or deactivate network interface
- `ifconfig <network_inteface> <ip>`: assign ip to that interface

## ip
- `ip a`: list all the ips and their address
- `ip route`: list all the kernel ip routes

## netstat
- `netstat -t`: list TCP connections
- `netstat -u`: list UDP connections
- `netstat -l`: list listening ports
- `netstat -p`: list the pid

## ping
- `ping -c<number_of_packets>`: specifies the number of packets to send (known as echo request) through the ICMP protocol


## traceroute
`traceroute <ip or domain>`: display the routes of the packets for the target host

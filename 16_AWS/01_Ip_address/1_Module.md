## IP Address  ?
It's nothing but a unique Identity of a Device on a Network
Every device that connects to a network (laptop, phone, server) needs an IP address.

## Types of IPs: Public and Private

### 1️ Public IP

- Assigned by ISP (Internet Service Provider)
- Unique globally
- Can be accessed from anywhere on the internet
- Used by ISPs(Jio, airtel, any cellular companies that provides) to give internet access to your home or office

###️ 2 Private IP

- Used inside a local network (home, office, cloud VPC)
- Cannot be accessed directly from the internet
- ISPs assign you a public IP, but inside your network, your devices have private IPs
- Solves the shortage of public IPs

### Private IP Ranges (RFC1918)
	ange								CIDR	Notes
	0.0.0.0 	– 10.255.255.255		/8		Large networks
	72.16.0.0 	– 172.31.255.255		/12		Medium networks
	92.168.0.0 – 192.168.255.255		/16		Small/home networks

### Check points 
If your IP falls in one of these ranges → private; otherwise → public
Public IP  → internet sees it
Private IP → used inside your network, translated by NAT at the router
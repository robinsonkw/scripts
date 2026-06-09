#!/bin/bash

# --- Configuration Variables ---
WAN_IFACE=""             # Physical interface connected to the modem/ISP
WAN_BRIDGE_NAME="br-wan" # Name for the dedicated WAN bridge

# --- Usage Function ---
usage() {
    echo "Usage: $0 <WAN_INTERFACE> [WAN_BRIDGE_NAME]"
    echo ""
    echo "  <WAN_INTERFACE>   : The physical interface name connected to the WAN/modem (e.g., eth0)."
    echo "  [WAN_BRIDGE_NAME] : (Optional) The name for the dedicated WAN Bridge (default: br-wan)."
    echo ""
    echo "This script creates a bridge for the OPNsense WAN interface."
    echo "The host OS will NOT have an IP address on this bridge."
    exit 1
}

# --- Argument Parsing ---
if [ "$#" -lt 1 ]; then
    usage
fi

WAN_IFACE=$1

if [ "$2" ]; then
    WAN_BRIDGE_NAME=$2
fi

echo "--- Dedicated WAN Bridge Configuration ---"
echo "WAN Bridge Name:    ${WAN_BRIDGE_NAME}"
echo "Physical WAN Port:  ${WAN_IFACE}"
echo "------------------------------------------"

# --- 1. Create the Master WAN Bridge Connection ---
echo "1. Creating master WAN bridge connection: ${WAN_BRIDGE_NAME}"
nmcli connection add type bridge con-name "${WAN_BRIDGE_NAME}" ifname "${WAN_BRIDGE_NAME}" || {
    echo "Error: Failed to create WAN bridge connection."
    exit 1
}

# --- 2. Add the WAN Interface as a Slave Port ---
echo "2. Adding WAN interface (${WAN_IFACE}) as slave port: ${WAN_IFACE}-wan-slave"
nmcli connection add type ethernet con-name "${WAN_IFACE}-wan-slave" ifname "${WAN_IFACE}" master "${WAN_BRIDGE_NAME}" connection.autoconnect no || {
    echo "Error: Failed to add WAN slave connection."
    exit 1
}

# --- 3. Configure the WAN Bridge (VERY IMPORTANT) ---
echo "3. Configuring ${WAN_BRIDGE_NAME} for Firewall Pass-Through."
# The host OS MUST NOT have an IP address on the WAN bridge, 
# as the OPNsense VM needs to receive the WAN IP (DHCP or Static).
nmcli connection modify "${WAN_BRIDGE_NAME}" ipv4.method disabled ipv6.method disabled

# --- 4. Clean up Old WAN Connection (if it existed) ---
echo "4. Deactivating and deleting old connection profile for ${WAN_IFACE}..."
# The physical interface can't have its own IP once it's a bridge port.
# If the connection profile doesn't exist, this will harmlessly fail.
nmcli connection down "${WAN_IFACE}" 2>/dev/null
nmcli connection delete "${WAN_IFACE}" 2>/dev/null

# --- 5. Activate Connections ---
echo "5. Activating the new WAN bridge connection: ${WAN_BRIDGE_NAME}"
nmcli connection up "${WAN_BRIDGE_NAME}"

echo "------------------------------------------"
echo "✅ WAN Bridge Setup Complete! Next Steps:"
echo "1. Verify bridge status: nmcli device show ${WAN_BRIDGE_NAME}"
echo "2. In your virtualization manager (e.g., virt-manager), give the OPNsense VM:"
echo "   - **NIC 1 (WAN):** Connect to the device **${WAN_BRIDGE_NAME}**"
echo "   - **NIC 2 (LAN):** Connect to the device **br-virt** (or whatever you named your internal bridge)"

#!/bin/bash

# --- Configuration Variables ---
BRIDGE_NAME="br-virt"     # Default name for the virtualization bridge
LAN_IFACE=""             # Physical interface connected to the LAN (e.g., eth0)

# --- Usage Function ---
usage() {
    echo "Usage: $0 <LAN_INTERFACE> [BRIDGE_NAME]"
    echo ""
    echo "  <LAN_INTERFACE> : The physical interface name connected to the LAN (e.g., eth0)."
    echo "  [BRIDGE_NAME]   : (Optional) The name for the new Virtualization Bridge (default: br-virt)."
    echo ""
    echo "This script converts the LAN_INTERFACE into a slave port for the BRIDGE_NAME."
    echo "The existing IP configuration of LAN_INTERFACE will be moved to the BRIDGE_NAME."
    exit 1
}

# --- Argument Parsing ---
if [ "$#" -lt 1 ]; then
    usage
fi

LAN_IFACE=$1

if [ "$2" ]; then
    BRIDGE_NAME=$2
fi

echo "--- Virtualization Bridge Configuration ---"
echo "Bridge Name:        ${BRIDGE_NAME}"
echo "Physical LAN Port:  ${LAN_IFACE}"
echo "-------------------------------------------"

# --- 1. Get Current IP Configuration from LAN Interface ---
# We need to preserve the current networking configuration of the host.
echo "1. Fetching current network configuration from ${LAN_IFACE}..."
IP_INFO=$(nmcli -t -f ipv4.method,ipv4.addresses,ipv4.gateway,ipv4.dns connection show "${LAN_IFACE}")
if [ $? -ne 0 ]; then
    echo "Error: Could not find connection profile for '${LAN_IFACE}'. Ensure it exists and is active."
    exit 1
fi

IP_METHOD=$(echo "${IP_INFO}" | awk 'NR==1 {print $1}')
IP_ADDRESSES=$(echo "${IP_INFO}" | awk 'NR==2 {print $1}')
IP_GATEWAY=$(echo "${IP_INFO}" | awk 'NR==3 {print $1}')
IP_DNS=$(echo "${IP_INFO}" | awk 'NR==4 {print $1}' | tr ',' ' ')

if [ -z "${IP_METHOD}" ]; then
    echo "Error: Failed to retrieve network configuration. Cannot proceed."
    exit 1
fi

echo "   -> Method: ${IP_METHOD}, Addresses: ${IP_ADDRESSES}, Gateway: ${IP_GATEWAY}"

# --- 2. Create the Master Bridge Connection ---
echo "2. Creating master bridge connection: ${BRIDGE_NAME}"
nmcli connection add type bridge con-name "${BRIDGE_NAME}" ifname "${BRIDGE_NAME}" || {
    echo "Error: Failed to create bridge connection."
    exit 1
}

# --- 3. Add the LAN Interface as a Slave Port ---
echo "3. Adding LAN interface (${LAN_IFACE}) as slave port: ${LAN_IFACE}-virt-slave"
# Set autoconnect off for the slave, as the bridge should control it.
nmcli connection add type ethernet con-name "${LAN_IFACE}-virt-slave" ifname "${LAN_IFACE}" master "${BRIDGE_NAME}" connection.autoconnect no || {
    echo "Error: Failed to add LAN slave connection."
    exit 1
}

# --- 4. Configure the Bridge IP Settings (Transferring Host IP) ---
echo "4. Transferring Host IP configuration to bridge: ${BRIDGE_NAME}"

# Apply the retrieved IP method and settings to the new bridge connection
nmcli connection modify "${BRIDGE_NAME}" ipv4.method "${IP_METHOD}" \
    ipv4.addresses "${IP_ADDRESSES}" \
    ipv4.gateway "${IP_GATEWAY}" \
    ipv4.dns "${IP_DNS}"

# --- 5. Clean up Old LAN Connection ---
echo "5. Deactivating and deleting old connection profile for ${LAN_IFACE}..."
# The physical interface can't have its own IP once it's a bridge port.
nmcli connection down "${LAN_IFACE}"
nmcli connection delete "${LAN_IFACE}"

# --- 6. Activate Connections ---
echo "6. Activating the new bridge connection: ${BRIDGE_NAME}"
nmcli connection up "${BRIDGE_NAME}"

echo "-------------------------------------------"
echo "✅ Virtualization Bridge Setup Complete! Details:"
echo "Host IP is now managed by the ${BRIDGE_NAME} interface."
echo "Virtual machines should connect their virtual NICs to the '${BRIDGE_NAME}' device."
nmcli device show "${BRIDGE_NAME}"

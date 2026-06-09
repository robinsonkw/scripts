#!/bin/bash

# --- Configuration ---
# Define the list of packages you want to install.
# Separate package names with spaces.
REQUIRED_PACKAGES="vim-enhanced qemu-kvm virt-install virt-manager libvirt"

# --- Main Logic ---

echo "Starting system maintenance script..."
echo "-------------------------------------"

# 1. Check if the current user is root (UID 0)
# $EUID is a special shell variable that holds the effective user ID.
if [ "$EUID" -ne 0 ]; then
  echo "❌ This script must be run as root."
  echo "Please use 'sudo ./script_name.sh' or switch to the root user."
  exit 1
fi

echo "✅ Root user detected. Proceeding with updates and package installation."

# 2. Run dnf update
echo ""
echo "## 🚀 Running DNF System Update..."
# -y flag automatically answers yes to prompts.
if dnf update -y; then
  echo "--- DNF Update Complete ---"
  
  # 3. Install defined packages
  echo ""
  echo "## 📦 Installing Required Packages: ${REQUIRED_PACKAGES}"
  # Check if the package list is not empty before attempting installation
  if [ -n "$REQUIRED_PACKAGES" ]; then
    if dnf install -y $REQUIRED_PACKAGES; then
      echo "--- DNF Package Installation Complete ---"
      echo ""
      echo "✅ Script finished successfully. System updated and packages installed."
    else
      echo "--- DNF Package Installation Failed ---"
      echo ""
      echo "❌ ERROR: One or more packages failed to install."
      exit 1
    fi
  else
    echo "⚠️ WARNING: The REQUIRED_PACKAGES list is empty. Skipping package installation."
  fi
  
else
  echo "--- DNF Update Failed ---"
  echo ""
  echo "❌ ERROR: DNF system update failed. Aborting."
  exit 1
fi

echo "-------------------------------------"


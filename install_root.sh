#!/bin/sh
# Install files that need root permissions.

set -euo pipefail

# Chromium policy
install --directory \
    --owner root --group root \
    /etc/chromium/policies/managed/
ln -sr ~/.config/misc/chrome.json \
    /etc/chromium/policies/managed/policy.json

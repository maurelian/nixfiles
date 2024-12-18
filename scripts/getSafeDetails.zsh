#!/bin/zsh

# Usage `getSafeDetails <safe-address> [cast call options]`
# All `cast call` options are passed to `cast call` commands. The one
# exception is when we do ENS lookups, in which case we ignore cast flags
# and always use the latest block with a mainnet RPC URL. This is done by
# assuming a `MAINNET_RPC_URL` env var is set.

local safe=$1
shift # Shift the first argument off so "$@" contains any additional arguments

local threshold owners nonce

# Ensure compatibility with both bash and zsh for arrays.
# In zsh, arrays start at 1 by default and it handles word splitting differently.
# Setting KSH_ARRAYS makes array indexing start at 0 in zsh, similar to bash,
# and we disable it at the end of the function.
if [[ -n "$ZSH_VERSION" ]]; then
  setopt localoptions ksharrays
fi

nonce=$(cast call "$safe" "nonce()(uint256)" "$@")
threshold=$(cast call "$safe" "getThreshold()(uint256)" "$@")
owners=$(cast call "$safe" "getOwners()(address[])" "$@" | tr -d '[]' | tr ',' '\n')

# Convert string to array.
# This works in both bash and zsh without needing to change IFS.
local ownersArray=()
while IFS= read -r line; do
  ownersArray+=("$line")
done <<< "$owners"

echo "Current Nonce:    $nonce"
echo "Threshold:        $threshold"
echo "Number of Owners: ${#ownersArray[@]}"

# Lookup each owner address
for address in "${ownersArray[@]}"; do
  address="${address#"${address%%[![:space:]]*}"}"  # remove leading whitespace
  ownerName=$(cast lookup-address "$address" -r "$MAINNET_RPC_URL" 2>/dev/null)
  if [[ -n $ownerName ]]; then
    echo "  $address $ownerName"
  else
    echo "  $address"
  fi
done

# If previously set KSH_ARRAYS for zsh, unset it to revert back to normal zsh behavior
if [[ -n "$ZSH_VERSION" ]]; then
  unsetopt ksharrays
fi


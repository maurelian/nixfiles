# Ethereum helper methods
# source this in your .bashrc or .zshrc file with `. ~/.ethrc`
{
  interface = ''
    if [[ $1 == 0x* ]]; then
      cast interface "$1" -c ''${2:-mainnet} --etherscan-api-key ''${3:-$ETHERSCAN_API_KEY}
    else
      cast interface <(forge inspect "$1" abi)
    fi
  '';
  checksum =''
    cast --to-checksum-address "$1"
  '';
}

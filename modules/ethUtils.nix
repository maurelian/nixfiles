# Ethereum helper methods
# source this in your .bashrc or .zshrc file with `. ~/.ethrc`
{
  interface = ''
    if string match -q "0x*" $argv[1]
        cast interface "$argv[1]" -c $ETH_RPC_URL --etherscan-api-key $ETHERSCAN_API_KEY
    else
        cast interface (forge inspect "$argv[1]" abi | psub)
    end
  '';
  checksumAddr =''
    cast --to-checksum-address "$1"
  '';
}

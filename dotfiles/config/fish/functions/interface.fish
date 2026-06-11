function interface
    if string match -q "0x*" $argv[1]
        cast interface "$argv[1]" -c $ETH_RPC_URL --etherscan-api-key $ETHERSCAN_API_KEY
    else
        cast interface (forge inspect "$argv[1]" abi | psub)
    end
end

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


//Deploy Mock when we are on a local anvil chain
//We keep track of contract address across different chains
//For example Sepolia EHT/USD or Mainnet EHT/USD keep different adresses

import {Script} from "forge-std/Script.sol";
import{MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig{
    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS=8;
    int256 public constant INITIAL_PRICE=2000e8;
    struct NetworkConfig{
        address priceFeed; //EHT/USD price feed address
    } 
    constructor(){
        if (block.chainid==11155111){
            activeNetworkConfig=getSepoliaEthConfig();
        
            else {
                activeNetworkConfig=getOrCreateAnvilEthConfig();

            }
        }
                
                
            

        
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory sepoliaConfig=NetworkConfig({priceFeed:
        0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;

    }
    function getOrCreateAnvilEthConfig() public pure returns (NetworkConfig memory){
        if activeNetworkConfig.priceFeed !=address(0){
            return activeNetworkConfig();
        }
        //DEPLOY Mock
        //Return Mock Address
        vm.startBroadcast();
        MockV3Aggregator mockFeedPrice=new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig=NetworkConfig({priceFeed:address(mockPriceFeed)
        });
        return anvilConfig;
        
        

    }


}
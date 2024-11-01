// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";

import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 private constant MOCK_DECIMALS = 8;
    int256 private constant MOCK_INITIAL_ANSWER = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public ActiveConfig;

    constructor() {
        if (block.chainid == 11155111) {
            ActiveConfig = getSepholiaConfig();
        }else if(block.chainid == 1){
            ActiveConfig = getMainNetConfig();
        }else {
            ActiveConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepholiaConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
    }

    function getMainNetConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            });
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (ActiveConfig.priceFeed != address(0)) {
            return ActiveConfig;
        }

        MockV3Aggregator mockV3Aggregator;
        vm.startBroadcast();
        mockV3Aggregator = new MockV3Aggregator(MOCK_DECIMALS, MOCK_INITIAL_ANSWER);
        vm.stopBroadcast();
        return NetworkConfig({priceFeed: address(mockV3Aggregator)});
    }
}

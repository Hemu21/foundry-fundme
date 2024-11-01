// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
//0x694AA1769357215DE4FAC081bf1f309aDC325306
library PriceConverter {
    function getPrice(AggregatorV3Interface _priceFeed) public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(_priceFeed);
        (, int256 value,,,) = priceFeed.latestRoundData();
        return uint256(value * 1e10);
    }

    function convert(uint256 _amount, AggregatorV3Interface _priceFeed) internal view returns(uint256){
        uint256 value = getPrice(_priceFeed);
        return uint256((value * _amount)/1e18);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

error FundMe__NotOwner();
error FundMe__FailedWithdraw();
error FundMe__InsufficentFund();

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    using PriceConverter for uint256;

    address[] private s_funders;
    mapping(address => uint256) private s_fundsData;
    uint256 public constant MINIMUM_USD = 5e18;
    address private immutable i_owner;
    AggregatorV3Interface internal s_priceFeed;

    constructor(address _priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function fund() public payable {
        if (msg.value.convert(s_priceFeed) < MINIMUM_USD)
            revert FundMe__InsufficentFund();
        s_fundsData[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function getVersions() public view returns (uint256) {
        return AggregatorV3Interface(s_priceFeed).version();
    }

    function FundersCount() public view returns (uint256) {
        return s_funders.length;
    }

    function balance(address _address) public view returns (uint256) {
        return uint256(_address.balance).convert(s_priceFeed);
    }

    function getValue(uint256 _amount) public view returns (uint256) {
        return _amount.convert(s_priceFeed);
    }

    function withdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for (uint256 i = 0; i < fundersLength; i++) {
            address _address = s_funders[i];
            s_fundsData[_address] = 0;
        }
        s_funders = new address[](0);
        (bool status, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!status) revert FundMe__FailedWithdraw();
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function getFunders(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getFundersFund(address _address) external view returns (uint256) {
        return s_fundsData[_address];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}

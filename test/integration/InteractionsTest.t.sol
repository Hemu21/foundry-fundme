// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/IntractionFundMe.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address immutable USER = makeAddr("USER");
    uint256 constant INITIAL_BALANCE = 10 ether;
    uint256 constant SEND_MIN_AMOUNT = 0.000001 ether;
    uint256 constant SEND_AMOUNT = 2 ether;

    function setUp() external {
        DeployFundMe depmloyFundMe = new DeployFundMe();
        fundMe = depmloyFundMe.run();
        vm.deal(USER, INITIAL_BALANCE);
    }

    function testFundandWithdraw() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));
        assertEq(fundMe.FundersCount(), 1);
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        assertEq(fundMe.FundersCount(), 0);
    }
}

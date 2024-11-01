// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address immutable USER = makeAddr("USER");
    uint256 constant INITIAL_BALANCE = 10 ether;
    uint256 constant SEND_MIN_AMOUNT = 0.000001 ether;
    uint256 constant SEND_AMOUNT = 2 ether;
    function setUp() external {
        DeployFundMe depmloyFundMe = new DeployFundMe();
        fundMe = depmloyFundMe.run();
        vm.deal(USER,INITIAL_BALANCE);
    }

    function testMinimumUSD() public view {
        uint256 MINIMUM_USD = 5e18;
        assertEq(fundMe.MINIMUM_USD(), MINIMUM_USD);
    }

    function testOwner() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testVersion() public view {
        if(block.chainid == 11155111) {
            assertEq(fundMe.getVersions(), 4);
        }else if(block.chainid == 1){
            assertEq(fundMe.getVersions(), 6);
        }else{
            assertEq(fundMe.getVersions(), 0);
        }
    }

    function testFailSendZeroAmount() public {
        vm.prank(USER);
        vm.expectRevert("FundMe__InsufficentFund");
        fundMe.fund();
    }

    function testMinimumAmountSendFail() public{
        vm.startPrank(USER);
        vm.expectRevert();
        fundMe.fund{value: SEND_MIN_AMOUNT}();
        vm.stopPrank();
    }

    function testFundSuccess() public {
        uint256 startingBalance = USER.balance;
        vm.prank(USER);
        fundMe.fund{value: SEND_AMOUNT}();
        uint256 endingBalance = USER.balance;
        assertEq(startingBalance - endingBalance, SEND_AMOUNT);
    }

    modifier funder {
        vm.prank(USER);
        fundMe.fund{value:SEND_AMOUNT}();
        _;
    }

    function testOnlyOwnerWithdraw() public funder {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testFundInitialBalance() public view {
        assertEq(address(fundMe).balance, 0);
    }

    function testWithdrawSuccess() public funder {
        assertEq(address(fundMe).balance, SEND_AMOUNT);
        address owner = fundMe.getOwner();
        vm.prank(owner);
        fundMe.withdraw();
        testFundInitialBalance();
    }

    function testAddFunders() public funder {
        assertEq(fundMe.FundersCount(), 1);
        assertEq(fundMe.getFunders(0), USER);
        assertEq(fundMe.getFundersFund(USER), SEND_AMOUNT);
    }


    function testArrayFundsWithdraw() public funder {
        uint160 addressLength = 10;
        uint160 initalValue = 1;
        for(uint160 i=initalValue;i<addressLength;i++) {
            hoax(address(i),SEND_AMOUNT);
            fundMe.fund{value:SEND_AMOUNT}();
        }
        
        assertEq(fundMe.FundersCount(), addressLength);
        assertEq(address(fundMe).balance, SEND_AMOUNT*addressLength);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        testFundInitialBalance();
    }

    function testBalance() public funder {
        assertEq(fundMe.balance(address(fundMe)), fundMe.getValue(SEND_AMOUNT));
    }

}
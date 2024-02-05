// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import{FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMe is Test {
  FundMe fundMe;
  address USER= makeADDr("user");
  uint constant SEND_VALUE=1ether;
  uint constant STARTING_BALANCE=10 ether;
  uint constant GAS_PRICE=1;
  function setUp() external{
      //fundMe =new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
      DeployFundMe deployFundMe=new DeployFundMe();
      fundMe=deployFundMe.run();
      vm.deal(USER,STARTING_BALANCE);

    }
  function testminimumDollarIsFive() public{
      assertEq (fundMe.MINIMUM_USD(),5e18);

  }
  function testOwnerIsMsgSender() public{
    
    assertEq(fundMe.i_owner(),msg.sender);
  }
  function testPriceFeedVersionIsAccurate() public{
        uint version=FundMe.getVersion();
        assertEq(version,4);


  }

  function testFundFailWithoutEnoughETH() public{
    vm.expectRevert();
    fundMe.fund();
  }

  function testFundUpdatesFundedDataStructure() public{
    vm.prank(USER);
    fundMe.fund{value:SEND_VALUE}();
    uint amountFunded=fundMe.getAddressToAmountFunded(USER);
    assertEq(amountFunded,SEND_VALUE);
  }
  function testAddsFunderToArrayOfFunders public{
    vm.prank(USER);
    fundMe.fund{value:SEND_VALUE}();
    address.funder=fundMe.GetFunder();
    assertEq(funder,USER);
  }
  modifier funded() {
    vm.prank(USER);
    fundMe.fund{value:SEND_VALUE}();
    _;
    
  }
  function testonlyOwnercanWithdraw() public funded{
    vm.prank(USER);
    fundMe.fund{value:SEND_VALUE}();
    vm.expectRevert();
    vm.prank(USER);
    fundMe.withdraw;

  }
  function testWithdrawWithASingleFunder{
    //Arrange
    uint startingOwnerBalance=fundMe.getOwner().balance;
    uint startingFundMeBalance= address(fundMe).balance;

    //Act
    
    vm.prank(fundMe.getOwner());
    fundMe.withdraw;//we are testing withdraw that s why in the Act Section
    
    //Assert-utverjdat
    uint endingOwnerBalance=fundMe.getOwner().balance;
    uint endingFundMeBalance=address(fundMe).balance;
    assertEq(endingFundMeBalance,0);
    assertEq(startingFundMeBalance+startingOwnerBalance,endingOwnerBalance);



  }
  function testWithdrawFromMultipleFunders() public funded{
    //Arrange
    uint160 numberOfFunders=10;
    uint160 startingFundersIndex=1;
    for( uint160 i=startingFundersIndex;i<numberOfFunders.i++){
      //vm.prank-new address
      //vm.deal-new address
      //fund the fundMe
      hoax(address (i),SEND_VALUE);
      fundMe.fund{value:SEND_VALUE}();
    }
    uint startingOwnerBalance=FundMe.getOwner().balance;
    uint startingFundMeBalance=address(fundMe).balance;

    //Act
    //vm.prank(fundMe.getOwner());
    //fundMe.withdraw;//we are testing withdraw that s why in the Act Section
    //he 2 above mentioned we can write this way:
    vm.startPrank(fundMe.getOwner());
    fundMe.withdraw;//we are testing withdraw that s why in the Act Section
    vm.stopPrank;

    //Assert
    assert(address(fundMe).balance==0);
    assert(startingFundMeBalance+startingOwnerBalance==fundMe.getOwner().balance);

  }

}
// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.30;

// import {Test, console} from "forge-std/Test.sol";
// import {RebaseToken} from "../src/RebaseToken.sol";
// import {Vault} from "../src/Vault.sol";
// import {RebaseTokenScript} from "../script/RebaseTokenScript.s.sol";

// contract RebaseTokenTest is Test {
//     RebaseToken rebaseToken;
//     Vault vault;
//     RebaseTokenScript rebaseTokenScript;
//     address USER = makeAddr("user");

//     function setUp() external {
//         rebaseTokenScript = new RebaseTokenScript();
//         (rebaseToken, vault) = rebaseTokenScript.run();
//     }

//     function testDepositLinear(uint256 _amount) public {
//         _amount = bound(_amount, 1e5, type(uint96).max);
//         vm.startPrank(USER);
//         vm.deal(USER, _amount);
//         vault.deposit{value: _amount}();
//         uint256 startingBalance = rebaseToken.balanceOf(USER);
//         console.log("starting Balance is ", startingBalance);
//         vm.warp(block.timestamp + 1 hours);
//         uint256 middelBalance = rebaseToken.balanceOf(USER);
//         assertGt(middelBalance, startingBalance);
//         vm.warp(block.timestamp + 1 hours);
//         uint256 endBalance = rebaseToken.balanceOf(USER);
//         assertGt(endBalance, startingBalance);
//         assertEq(endBalance - middelBalance, middelBalance - startingBalance);
//         vm.stopPrank();
//     }

//     function testRedeemstrightAway(uint256 _amount) public {
//     _amount = bound(_amount, 1e5, type(uint96).max);

//     vm.startPrank(USER);
//     vm.deal(USER, _amount);

//     // Deposit to vault
//     vault.deposit{value: _amount}();

//     // Check balance after deposit
//     uint256 balance = rebaseToken.balanceOf(USER);
//     console.log("User balance after deposit:", balance);
//     require(balance > 0, "User has zero token balance after deposit");

//     // Redeem the actual balance
//     vault.redeem(balance);

//     // Ensure balance is zero after redeem
//     vm.stopPrank();
// }

// }

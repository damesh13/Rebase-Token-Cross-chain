// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/RebaseToken.sol";
import "../src/Vault.sol";

contract VaultAndRebaseTokenTest is Test {
    RebaseToken rebaseToken;
    Vault vault;

    address user = address(1);
    address anotherUser = address(2);

    function setUp() public {
        // Deploy rebase token and vault
        rebaseToken = new RebaseToken();
        vault = new Vault(IRebaseToken(address(rebaseToken)));

        // Grant vault mint and burn role
        rebaseToken.grantRole(address(vault));

        // Label for better debugging
        vm.label(user, "User");
        vm.label(anotherUser, "AnotherUser");
    }

    function testDepositMintsToken() public {
        vm.deal(user, 1 ether);
        vm.prank(user);
        vault.deposit{value: 1 ether}();

        uint256 balance = rebaseToken.balanceOf(user);
        assertEq(balance, 1 ether, "User should have received RBT after deposit");
    }

    function testRedeemBurnsTokenAndSendsEthBack() public {
        vm.deal(user, 1 ether);

        vm.prank(user);
        vault.deposit{value: 1 ether}();

        vm.prank(user);
        vault.redeem(1 ether);

        assertEq(user.balance, 1 ether, "User should have received ETH back");
        assertEq(rebaseToken.balanceOf(user), 0, "User's token balance should be 0");
    }

    function testRedeemMaxBurnsAll() public {
        vm.deal(user, 2 ether);

        vm.prank(user);
        vault.deposit{value: 2 ether}();

        vm.prank(user);
        vault.redeem(type(uint256).max); // Redeem max

        assertEq(user.balance, 2 ether, "User should receive full ETH");
        assertEq(rebaseToken.balanceOf(user), 0, "Token balance should be 0");
    }

    function testSetInterestRateDecreases() public {
        // New interest rate must be lower
        rebaseToken.setInterestRate(4e10);
        assertEq(rebaseToken.getInterestRate(), 4e10);
    }

    function testRevertIfInterestRateIncreases() public {
        vm.expectRevert();
        rebaseToken.setInterestRate(6e10); // Should revert since 6e10 > default 5e10
    }

    function testTransferCarriesInterestRate() public {
        vm.deal(user, 1 ether);
        vm.prank(user);
        vault.deposit{value: 1 ether}();

        vm.prank(user);
        rebaseToken.transfer(anotherUser, 0.5 ether);

        assertEq(
            rebaseToken.getInterestRate(anotherUser),
            rebaseToken.getInterestRate(user),
            "Interest rate should be copied"
        );
    }
}

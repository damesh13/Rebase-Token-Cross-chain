// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {RebaseToken} from "../src/RebaseToken.sol";
import {Vault} from "../src/Vault.sol";
import {IRebaseToken} from "../src/Interfaces/IRebaseToken.sol";

contract RebaseTokenScript is Script {
    error RebaseTokenScript__TransferFailed();

    RebaseToken private rebaseToken;
    Vault private vault;
    IRebaseToken private i_rebaseToken;

    address private OWNER = makeAddr("owner");
    address public USER = makeAddr("user");

    function run() external returns (RebaseToken, Vault) {
        vm.startPrank(OWNER);
        vm.deal(OWNER, 10 ether);
        rebaseToken = new RebaseToken();
        i_rebaseToken = IRebaseToken(address(rebaseToken));
        vault = new Vault(i_rebaseToken);
        rebaseToken.grantRole(address(vault));
        (bool success,) = payable(address(vault)).call{value: 1e18}("");
        require(success, RebaseTokenScript__TransferFailed());
        vm.stopPrank();
        return (rebaseToken, vault);
    }
}

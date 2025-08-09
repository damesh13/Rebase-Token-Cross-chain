// SPDX-License_Identifier: MIT
// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

/////////////////
// version
////////////////
pragma solidity ^0.8.24;

///////////////
// imports
////////////////
import {RebaseToken} from "./RebaseToken.sol";
import {IRebaseToken} from "./Interfaces/IRebaseToken.sol";
////////////////
// interfaces, libraries, contracts
////////////////

contract Vault {
    ////////////////
    // errors
    ////////////////
    error Vault__TransferFailed();
    ////////////////
    // Type declarations
    ////////////////

    ////////////////
    // State variables
    ////////////////
    IRebaseToken private immutable i_rebaseToken;

    ////////////////
    // Events
    ////////////////
    event deposited(address indexed user, uint256 amount);
    event Redeemed(address indexed _user, uint256 _amount);
    ////////////////
    // Modifiers
    ////////////////

    ////////////////
    // Functions
    ////////////////

    ////////////////
    // constructor
    ////////////////
    constructor(IRebaseToken _rebasetoken) {
        i_rebaseToken = _rebasetoken;
    }
    ////////////////
    // receive function (if exists)
    ////////////////

    receive() external payable {}
    ////////////////
    // fallback function (if exists)
    ////////////////

    ////////////////
    // external
    ////////////////
    function deposit() external payable {
        uint256 interestRate = i_rebaseToken.getInterestRate();
        i_rebaseToken.mint(msg.sender, msg.value,interestRate);
        emit deposited(msg.sender, msg.value);
    }

    function redeem(uint256 _amount) external {
    uint256 principal = i_rebaseToken.balanceOf(msg.sender);

    if (_amount == type(uint256).max) {
        _amount = principal;
    }

    i_rebaseToken.burn(msg.sender, _amount);

    (bool success, ) = payable(msg.sender).call{value: _amount}("");
    if (!success) revert Vault__TransferFailed();

    emit Redeemed(msg.sender, _amount);
}


    ////////////////
    // public
    ////////////////

    ////////////////
    // internal
    ////////////////

    ////////////////
    // private
    ////////////////

    ////////////////
    // internal & private view & pure functions
    ////////////////

    ////////////////
    // external & public view & pure functions
    ////////////////
    function getRebaseTokenContractAddress() external view returns (address) {
        return address(i_rebaseToken);
    }
}

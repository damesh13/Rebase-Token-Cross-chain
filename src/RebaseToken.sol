// SPDX-License-Identifier: MIT
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
/////////////////
// imports
////////////////

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
////////////////////////////////////
// interfaces, libraries, contracts
///////////////////////////////////

contract RebaseToken is ERC20, Ownable, AccessControl {
    ////////////////
    // errors
    ////////////////
    error RebaseToken__InterestRateShouldBeDecreasing(uint256 s_interestRate, uint256 _interestRate);

    ////////////////
    // Type declarations
    ////////////////

    ////////////////
    // State variables
    ////////////////
    uint256 private constant PRECISION_FACTOR = 1e18;
    bytes32 private constant MINT_AND_BURN_ROLE = keccak256("MINT_AND_BURN_ROLE");
    uint256 private s_interestRate = 5e10;
    mapping(address => uint256) private s_userInterestRate;
    mapping(address => uint256) private s_userLastUpdatedTimestamp;

    ////////////////
    // Events
    ////////////////
    event NewInterestRateSet(uint256 s_interestRate);

    ////////////////
    // Modifiers
    ////////////////

    ////////////////
    // Functions
    ////////////////

    ////////////////
    // constructor
    ////////////////
    constructor() ERC20("Rebase Token", "RBT") Ownable(msg.sender) {}
    ////////////////
    // receive function (if exists)
    ////////////////

    ////////////////
    // fallback function (if exists)
    ////////////////

    ////////////////
    // external
    ////////////////
    function setInterestRate(uint256 _interestRate) external onlyOwner {
        if (_interestRate > s_interestRate) {
            revert RebaseToken__InterestRateShouldBeDecreasing(s_interestRate, _interestRate);
        }
        s_interestRate = _interestRate;
        emit NewInterestRateSet(s_interestRate);
    }

    function mint(address _user, uint256 _amount,uint256 _userInterestRate) external onlyRole(MINT_AND_BURN_ROLE) {
        if (balanceOf(_user) > 0) {
            _mintAccruedInterest(_user);
        }
        s_userInterestRate[_user] = _userInterestRate;
        s_userLastUpdatedTimestamp[_user] = block.timestamp;
        _mint(_user, _amount);
    }

    function burn(address _user, uint256 _amount) external onlyRole(MINT_AND_BURN_ROLE) {
        _mintAccruedInterest(_user);
        _burn(_user, _amount);
    }

    function grantRole(address _user) external onlyOwner {
        _grantRole(MINT_AND_BURN_ROLE, _user);
    }
    ////////////////
    // public
    ////////////////

    function balanceOf(address _user) public view override returns (uint256) {
        uint256 principal = super.balanceOf(_user);
        uint256 multiplier = _calculateUserAccmulatedInterestSinceLastUpdate(_user);
        return (principal * multiplier) / PRECISION_FACTOR;
    }

    function transfer(address _user, uint256 _amount) public override returns (bool) {
        _mintAccruedInterest(msg.sender);
        _mintAccruedInterest(_user);
        if (_amount == type(uint256).max) {
            _amount = balanceOf(msg.sender);
        }
        if (balanceOf(_user) == 0) {
            s_userInterestRate[_user] = s_userInterestRate[msg.sender];
        }
        return super.transfer(_user, _amount);
    }

    function transferFrom(address _from, address _to, uint256 _amount) public override returns (bool) {
        _mintAccruedInterest(_from);
        _mintAccruedInterest(_to);
        if (_amount == type(uint256).max) {
            _amount = balanceOf(_from);
        }
        if (balanceOf(_to) == 0) {
            s_userInterestRate[_to] = s_userInterestRate[msg.sender];
        }
        return super.transfer(_to, _amount);
    }
    ////////////////
    // internal
    ////////////////

    function _mintAccruedInterest(address _user) internal {
        uint256 previousPrincipal = super.balanceOf(_user);
        uint256 updatedBalance = balanceOf(_user);
        uint256 interestToMint = updatedBalance - previousPrincipal;

        if (interestToMint > 0) {
            _mint(_user, interestToMint);
        }

        s_userLastUpdatedTimestamp[_user] = block.timestamp;
    }

    function _calculateUserAccmulatedInterestSinceLastUpdate(address _user)
        internal
        view
        returns (uint256 linearInterestMultiplier)
    {
        uint256 timepassed = block.timestamp - s_userLastUpdatedTimestamp[_user];
        uint256 rate = s_userInterestRate[_user];
        linearInterestMultiplier = PRECISION_FACTOR + (rate * timepassed);
    }

    ////////////////
    // private
    ////////////////

    ////////////////
    // internal & private view & pure functions
    ////////////////

    ////////////////
    // external & public view & pure functions
    ////////////////
    function getInterestRate(address _user) external view returns (uint256 interestRate) {
        return s_userInterestRate[_user];
    }

    function getPrincipleBalanceOf(address _user) external view returns (uint256) {
        return super.balanceOf(_user);
    }

    function getInterestRate() public view returns (uint256) {
        return s_interestRate;
    }
}

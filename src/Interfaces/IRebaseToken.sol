// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IRebaseToken {
    function mint(address _user, uint256 _amount,uint256 userInterestRate) external;
    function burn(address _user, uint256 _amount) external;
    function balanceOf(address _user) external view returns (uint256);
    function getInterestRate() external view returns(uint256);
    function getUserIntrestRate(address user) external view returns (uint256);

}

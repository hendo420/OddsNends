//"SPDX-License-Identifier: UNLICENSED"

pragma solidity 0.7.4;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract faucet {

    address public tokenAddress;
    mapping(address => uint) paidTime;
    uint frequency = 1 hours;
    address owner;
    
    constructor (address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }

    function tapFaucet() public {
        require(paidTime[msg.sender] <= block.timestamp-frequency);
        paidTime[msg.sender] = block.timestamp;
        uint _amount = IERC20(tokenAddress).balanceOf(address(this)) / 100;
        IERC20(tokenAddress).transfer(msg.sender, _amount);
    }
    
    function emptyFaucet() public {
        require(msg.sender == owner);
        uint _amount = IERC20(tokenAddress).balanceOf(address(this));
        IERC20(tokenAddress).transfer(msg.sender, _amount);
    }
}
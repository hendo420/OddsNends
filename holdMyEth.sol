pragma solidity 0.7.4;

contract holdMyEth {
 
    receive() external payable {
        
    }
 
    function refund()public {
        msg.sender.transfer(address(this).balance);
    }
 
    
}
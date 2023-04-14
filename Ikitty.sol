pragma solidity ^0.6.0;


contract Ikitty {
    function getKitty(uint256 _id)
        external
        view
        returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    ) {    
        
    }
    
    
    function giveBirth(uint256 _matronId)
        external
        returns(uint256)
    {

    }
    
    function isPregnant(uint256 _kittyId)
        public
        view
        returns (bool)
    {

    }
    
}
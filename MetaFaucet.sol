pragma solidity 0.7.4;
//SPDX-License-Identifier: UNLICENSED
 
library AddressUtils {
    function isContract(address addr) internal view returns (bool) {
        // for accounts without code, i.e. `keccak256('')`:
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        bytes32 codehash;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            codehash := extcodehash(addr)
        }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

library SafeMath {
    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

interface ERC165 {
    /**
   * @notice Query if a contract implements an interface
   * @param _interfaceId The interface identifier, as specified in ERC-165
   * @dev Interface identification is specified in ERC-165. This function
   * uses less than 30,000 gas.
   */
    function supportsInterface(bytes4 _interfaceId)
        external
        view
        returns (bool);
}

interface ERC721Events {
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function mint(address account, uint256 amount) external;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Uniswap{
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
    function removeLiquidityETH( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function WETH() external pure returns (address);
}

interface IERC721 {
    function balanceOf(address _owner) external view returns (uint256 _balance);
    function ownerOf(uint256 _tokenId) external view returns (address _owner);
    //   function exists(uint256 _tokenId) external view returns (bool _exists);


    function approve(address _to, uint256 _tokenId) external;
    function getApproved(uint256 _tokenId)
        external
        view
        returns (address _operator);

    function setApprovalForAll(address _operator, bool _approved) external;
    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);

    function transferFrom(address _from, address _to, uint256 _tokenId)
        external;


    function safeTransferFrom(address _from, address _to, uint256 _tokenId)
        external;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata _data
    ) external;

}

contract MetaFaucet is IERC721, ERC721Events {
    // LIBRARIES /////////////////////////////////////////////////////////////////////////
    using AddressUtils for address;
    using SafeMath for uint256;
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    uint internal COIN = 10**18;
    address public tokenAddress;
    
    mapping (address => uint256) public ownershipTokenCount;
    mapping (uint256 => address) public tokenIndexToOwner;
    mapping (uint256 => address) public tokenIndexToApproved;
    mapping (address => mapping(address => bool)) public operatorApprovals;
    
    function balanceOf(address _owner) public view override returns (uint256 count) {
        return ownershipTokenCount[_owner];
    }
    
    function ownerOf(uint256 _tokenId) external view override returns (address _owner){
        _owner = tokenIndexToOwner[_tokenId];
    }
    
    function approve(address _to, uint256 _tokenId) external override{
        require(tokenIndexToOwner[_tokenId] == msg.sender);
        tokenIndexToApproved[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function getApproved(uint256 _tokenId) external view override returns (address _operator){
        _operator = tokenIndexToApproved[_tokenId];
    }    

    function setApprovalForAll(address _to, bool _approved) external override{
        require(_to != msg.sender);
        operatorApprovals[msg.sender][_to] = _approved;
        emit ApprovalForAll(msg.sender, _to, _approved);
    }  
    
    function isApprovedForAll(address _owner, address _to) external view override returns (bool){
        return operatorApprovals[_owner][_to];
    }
    
    function transferFrom(address _from, address _to, uint256 _tokenId) external override{
        require(_to != address(0) || _from != address(0));
        require(tokenIndexToApproved[_tokenId] == msg.sender || operatorApprovals[_from][msg.sender] == true || tokenIndexToOwner[_tokenId] == msg.sender);
        _transferFrom(_from, _to, _tokenId);
    }
    
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external override{
        require(AddressUtils.isContract(_to) == false);
        require(_to != address(0) || _from != address(0));
        require(tokenIndexToApproved[_tokenId] == msg.sender || operatorApprovals[_from][msg.sender] == true || tokenIndexToOwner[_tokenId] == msg.sender);
        _transferFrom(_from, _to, _tokenId);
    }
    
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external override{
        require(AddressUtils.isContract(_to) == false);
        require(_to != address(0) || _from != address(0));
        require(tokenIndexToApproved[_tokenId] == msg.sender || operatorApprovals[_from][msg.sender] == true || tokenIndexToOwner[_tokenId] == msg.sender);
        _transferFrom(_from, _to, _tokenId);
    }
    
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        tokenIndexToOwner[_tokenId] = _to;
        ownershipTokenCount[_from] = ownershipTokenCount[_from].sub(1);
        ownershipTokenCount[_to] = ownershipTokenCount[_to].add(1);
        delete tokenIndexToApproved[_tokenId];
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////
    
    Token[] tokens;
    
    struct Token{
        uint timeStamp;
        uint faucetNumber;
        uint tap;
    }
    
    mapping (uint => uint) public faucetValue;
    //mapping (uint => bool) public faucetAvalable;
    mapping (uint => uint) public currentFaucetId;
    
    function mint(uint _faucetNumber) internal returns (uint tokenId){
        //faucetAvalable[_faucetNumber] = false;
        tokenId = tokens.length;
        Token memory _token = Token({
            timeStamp: block.timestamp,
            faucetNumber: _faucetNumber,
            tap: 0
        });
        currentFaucetId[_faucetNumber] = tokenId;
        tokenIndexToOwner[tokenId] = msg.sender; 
        ownershipTokenCount[msg.sender] = ownershipTokenCount[msg.sender].add(1);
        tokens.push(_token);
    }
    
    uint maturity = 7 hours;
    
    function createFaucet(uint _faucetNumber, uint _tokenValue) public {
        require(currentFaucetId[_faucetNumber] == 0 || tokens[currentFaucetId[_faucetNumber]].timeStamp.add(maturity) <= block.timestamp);
        if(faucetValue[_faucetNumber] == 0) {
            faucetValue[_faucetNumber] = 1*COIN;
        } else {
            faucetValue[_faucetNumber] = random(faucetValue[_faucetNumber], faucetValue[_faucetNumber].add(faucetValue[_faucetNumber].mul(20).div(100)));
        }
        mint(_faucetNumber);
    }
    
    
    function random(uint min, uint max) public view returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % max.sub(min);
        randomnumber = randomnumber + min;
        return randomnumber;
    }
    
    function tapFaucet(uint _faucetId) public {
        require(tokenIndexToOwner[currentFaucetId[_faucetId]] == msg.sender);
        uint timestamp = block.timestamp.sub(tokens[currentFaucetId[_faucetId]].timeStamp);
        if(tokens[currentFaucetId[_faucetId]].timeStamp <= 1 hours) {
            require(timestamp >= 50 minutes);
            require(tokens[currentFaucetId[_faucetId]].tap == 0);
            tokens[currentFaucetId[_faucetId]].tap++;
            IERC20(tokenAddress).transfer(msg.sender, faucetValue[_faucetId].div(7));
        } else {
            if(tokens[currentFaucetId[_faucetId]].timeStamp <= 2 hours) {
                require(timestamp >= 1 hours + 50 minutes);
                require(tokens[currentFaucetId[_faucetId]].tap <= 1);
                tokens[currentFaucetId[_faucetId]].tap++;
                IERC20(tokenAddress).transfer(msg.sender, faucetValue[_faucetId].div(7));
            } else {
                if(tokens[currentFaucetId[_faucetId]].timeStamp <= 3 hours) {
                    require(timestamp >= 2 hours + 50 minutes);
                    require(tokens[currentFaucetId[_faucetId]].tap <= 2);
                    tokens[currentFaucetId[_faucetId]].tap++;
                    IERC20(tokenAddress).transfer(msg.sender, faucetValue[_faucetId].div(7));
                } else {
                    if(tokens[currentFaucetId[_faucetId]].timeStamp <= 4 hours) {
                        require(timestamp >= 3 hours + 50 minutes);
                        require(tokens[currentFaucetId[_faucetId]].tap <= 3);
                        tokens[currentFaucetId[_faucetId]].tap++;
                        IERC20(tokenAddress).transfer(msg.sender, faucetValue[_faucetId].div(7));
                    } else {
                        if(tokens[currentFaucetId[_faucetId]].timeStamp <= 5 hours) {
                            require(timestamp >= 4 hours + 50 minutes);
                            require(tokens[currentFaucetId[_faucetId]].tap <= 4);
                            tokens[currentFaucetId[_faucetId]].tap++;
                            IERC20(tokenAddress).transfer(msg.sender, faucetValue[_faucetId].div(7));
                        } else {
                            if(tokens[currentFaucetId[_faucetId]].timeStamp <= 6 hours) {
                                require(timestamp >= 5 hours + 50 minutes);
                                require(tokens[currentFaucetId[_faucetId]].tap <= 5);
                                tokens[currentFaucetId[_faucetId]].tap++;
                                IERC20(tokenAddress).transfer(msg.sender, faucetValue[_faucetId].div(7));
                            } else {
                                if(tokens[currentFaucetId[_faucetId]].timeStamp <= 7 hours) {
                                    require(timestamp >= 6 hours + 50 minutes);
                                    require(tokens[currentFaucetId[_faucetId]].tap <= 6);
                                    tokens[currentFaucetId[_faucetId]].tap++;
                                    IERC20(tokenAddress).transfer(msg.sender, faucetValue[_faucetId].div(7));
                                }
                            }
                        }
                    }
                }
            }
        }
        

    }
    
}


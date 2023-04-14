pragma solidity 0.7.4;
//SPDX-License-Identifier: UNLICENSED

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

contract bitter {
    using SafeMath for uint256;
/*    
    Token[] tokens;
    
    struct Token{   
        
    }
*/

mapping (address => address) public account;

    function registerUser(string memory _name, string memory _picture, string memory _description) public returns(address) {
        require(account[msg.sender] == address(0));//you only get one account
        userAccount userId = new userAccount(msg.sender, _name, _picture, _description); 
        account[msg.sender] = address(userId); 
        return account[msg.sender];
    }
}

contract userAccount {
    
    using SafeMath for uint256;
    
    address public userAddress;
    string public name;
    string public picture;
    string public description;
    
    constructor (address _userAddress, string memory _name, string memory _picture, string memory _description) {
        userAddress = _userAddress;
        name = _name;
        picture = _picture;
        description = _description;
    }
    
    Post[] posts;
    
    struct Post{ 
        uint timeStamp;
        string picture;
        string description;
    }
    
    function privatePost(string memory _picture, string memory _description) public returns(uint postId) {
        postId = posts.length;
        totalSupply = totalSupply.add(1);
pragma solidity 0.7.4;
//SPDX-License-Identifier: UNLICENSED

 
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

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Uniswap{
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
    function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
    function removeLiquidityETH( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function WETH() external pure returns (address);
}

contract Arb {
    using SafeMath for uint256;
    
    address internal UNIROUTER         = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address internal  UNIFACTORY           = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    
    function weth() public view returns(address _weth) {
        _weth = Uniswap(UNIROUTER).WETH();
    }
    
    function getPair(address tokenA, address tokenB) public view returns (address pair) {
        pair = Uniswap(UNIROUTER).getPair(tokenA, tokenB);
    }
    
    function getLPbalance(address tokenA, address tokenB) public view returns (uint balanceA, uint balanceB) {
        address pool = getPair(tokenA, tokenB);
        balanceA = IERC20(tokenA).balanceOf(pool);
        balanceB = IERC20(tokenB).balanceOf(pool);
    }
   
    function getPrices(address tokenA, address tokenB) public view returns (uint priceA) {
        (uint balanceA, uint balanceB) = getLPbalance(tokenA, tokenB);
        priceA = balanceB/balanceA;
        //priceB = balanceA/balanceB;
    }
    
    //tokenA WEth, tokenB DAI, tokenC TST
    function compare(address tokenA, address tokenB, address tokenC) public view returns (bool) {
        uint priceA = getPrices(tokenA, tokenB);
        //priceA = 1000DAI = 1ETH
        uint priceB = getPrices(tokenC, tokenB);
        //priceB = 500DAI = 1TST
        uint priceC = getPrices(tokenA, tokenC);
        //priceC = 0.5ETH = 1TST
        if(priceB/priceC >= priceA){
            //BC pair is higher price than A
        }
        
        
        if(priceB/priceA >= priceC) {
            //BA pair is higher price than C
        }
    
        

    }
    
}
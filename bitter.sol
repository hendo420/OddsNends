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
        Post memory _post = Post({
            timeStamp: block.timestamp,
            picture: _picture,
            description: _description
        });
        posts.push(_post);
    }
    
    function getPost(uint _postId) public view returns ( uint _timeStamp, string memory _picture, string memory _description){
        Post storage _post = posts[_postId];
        _timeStamp = _post.timeStamp;
        _picture = _post.picture;
        _description = _post.description;
    }
    
    function deletePost(uint _postId) public {
        posts[_postId].timeStamp = 0;
        totalSupply = totalSupply.sub(1);
        //delete posts[_postId];
    }
    
    uint public totalSupply = 0; 
/*    
    function totalSupply() external view returns (uint _total){
        _total = postSupply;
    }
*/    
    function userPosts() external view returns(uint256[] memory ownerTokens) {
        uint256 totalTokens = posts.length;
        if (totalTokens == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](totalSupply);
            uint256 resultIndex = 0;
            uint256 tokenId;
            for (tokenId = 0; tokenId < totalTokens; tokenId++) {
                if (posts[tokenId].timeStamp != 0) {
                    result[resultIndex] = tokenId;
                    resultIndex++;
                }
            }
            return result;
        }
    }
    
}
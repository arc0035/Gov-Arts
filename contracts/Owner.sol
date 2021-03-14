pragma solidity ^0.4.25;


contract Owner{
    
    address public owner;
    
    constructor() internal{
        owner = msg.sender;
        emit TransferOwnership(address(0), msg.sender);
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner, "You are not owners");
        _;
    }
    
    event TransferOwnership(address indexed from, address indexed to);
    
    function transferOwnership(address _to) external onlyOwner(){
        address old = owner;
        owner = _to;
        emit TransferOwnership(old, _to);
    }
    
}
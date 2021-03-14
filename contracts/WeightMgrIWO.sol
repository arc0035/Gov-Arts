pragma solidity ^0.4.25;

import "./WeightMgr.sol";
import "./Owner.sol";
import "./SafeMath.sol";

/**
 * There is a agency responding for this weights (just like Token && ICO)
 * 
 * 
 **/
contract WeightMgrIWO is WeightMgr, Owner{
    
    using SafeMath for uint256;
    
    /**
     * Fields
     **/
    string public name;
    uint256 public totalSupply;
    
    /**
     * Events
     **/
    event Transfer(address indexed from, address indexed to,  uint256 amount);
    
    /**
     * Functions
     * 
     **/
    constructor(string _name) public{
        name = _name;
    }
    

    
    function mint(address _to, uint256 _amount) public onlyOwner{
        weights[_to] = weights[_to].add(_amount);
        totalSupply = totalSupply.add(_amount);
        emit Transfer(address(0), _to, _amount);
    } 
    
    function transfer(address _to, uint256 _amount) public{
        weights[_to] = weights[_to].add(_amount);
        weights[msg.sender] = weights[msg.sender].sub(_amount);
        emit Transfer(msg.sender, _to, _amount);
    } 
    
    function burn(address _to, uint256 _amount) public onlyOwner{
        weights[_to] = weights[_to].sub(_amount);
        totalSupply = totalSupply.sub(_amount);
        emit Transfer(_to, address(0), _amount);
    } 
}







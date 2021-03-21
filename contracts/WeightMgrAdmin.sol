pragma solidity ^0.4.25;

import "./WeightMgr.sol";
import "./Owner.sol";
import "./SafeMath.sol";

/**
 * There is a adminstrator assigning weight for everyone.
 * 
 * 
 **/
contract WeightMgrAdmin is WeightMgr, Owner{
    
    using SafeMath for uint256;
    
    /**
     * Events
     **/
    event SetWeight(address indexed to,  address indexed by, uint256 amount);
    
    /**
     * Functions
     * 
     **/
    
    
    function setWeight(address _to, uint256 _amount) public onlyOwner{
        weights[_to] = weights[_to].add(_amount);
        emit SetWeight( _to, msg.sender, _amount);
    } 

    function delegate(address from, address _delegatee) public onlyOwner{
        _delegate(from, _delegatee);
    }
}







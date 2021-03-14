pragma solidity ^0.4.25;

/**
 * Interface for managing weights 
 * 
 * 
 */
contract WeightMgr{
    mapping(address=>uint256) internal weights;
    
    function weightOf(address _address) public view returns(uint256){
        return weights[_address];
    }
    
}
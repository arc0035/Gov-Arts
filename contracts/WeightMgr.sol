pragma solidity ^0.4.25;

/**
 * Interface for managing weights 
 * 
 * 
 */
contract WeightMgr{
    mapping(address=>uint256) internal weights;
    mapping(address=>address) internal delegates;
    mapping(address=>uint256) internal dWeights;
    
    event Delegate(address from, address to, address old, uint amount);
    
    function weightOf(address _address) public view returns(uint256){
        return weights[_address];
    }
    
    function _delegate(address _from, address _delegatee) internal{
        require(_delegatee != address(0), "empty delegatee");
        address oldDelegatee = delegates[_from];
        require(oldDelegatee != _delegatee, "already delegate to this delegatee");
        delegates[_from] = _delegatee;
        
        uint weight = weights[_from];
        dWeights[_delegatee] += weight;
        
        if(oldDelegatee != address(0)){
           dWeights[oldDelegatee] -= weight;
        }
        emit Delegate(_from, _delegatee, oldDelegatee, weight);
    }
}


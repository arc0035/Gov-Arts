pragma solidity ^0.4.25;

import "./WeightMgr.sol";
import "./SafeMath.sol";

/**
 * There is a agency responding for this weights (just like Token && ICO)
 * 
 * 
 **/
contract WeightMgrVotes is WeightMgr{
    
    using SafeMath for uint256;
    
    struct Proposal{
        address target;
        bool isGov;
        uint256 votes;
        address[] voters;
        address creator;
    }
    
    
    /**
     * Fields
     **/
    //use  66 to represent 66%
    uint256 private rate;
    uint256 public governSize;
    Proposal public proposal;    
    

    
    /**
     * Modifers
     **/
    modifier onlyGovs(){
        require(weights[msg.sender] != 0, "You are not governors");
        _;
    }
    
    /**
     * Events
     **/
    event RequestSet(address indexed target, address indexed by, bool isGov);
    event Agree(address indexed target, address by);
    event CleanProposal(address indexed target, address by);
    event SetGovernor(address indexed target, bool isGov);
    /**
     * Functions
     * 
     **/
    constructor(uint256 _rate) public{ 
        require(_rate <= 100, "Rate not in 100");
        weights[msg.sender] = 1;
        governSize = 1;
    }
    

    
    function requestSet(address _target, bool _isGov) public onlyGovs{
        require(_target != address(0), "invalid target address");
        if(governSize == 1){
            _execute(_target, _isGov);
            return;
        }
        
        require(proposal.target == address(0), "A proposal alrady exists");
        proposal.target = _target;
        proposal.isGov = _isGov;
        proposal.votes = 0;
        proposal.creator = msg.sender;
        emit RequestSet(_target, msg.sender, _isGov);
        _agree();  
    } 
    
        
    function agree() public onlyGovs{
        require(proposal.target != address(0), "Proposal not exist");

        for(uint i=0;i<proposal.voters.length;i++){
            require(msg.sender != proposal.voters[i], "Already voted");
        }
        _agree();
         
    }
    
    function cleanProposal() public onlyGovs{
        require(proposal.target != address(0), "Already a proposal");
        require(proposal.creator == msg.sender, "Not proposal creator");
        _cleanProposal();
    }
    
    function getProposal() public view returns(address _target, bool _isGov, uint256 _votes, address creator ){
        return (proposal.target, proposal.isGov, proposal.votes, proposal.creator);
    } 
    
    function _agree() internal{
        proposal.votes = proposal.votes.add(1);
        proposal.voters.push(msg.sender);
        if(proposal.votes.mul(100) >= rate.mul(governSize)){
            _execute(proposal.target, proposal.isGov);
        }
        emit Agree(proposal.target, msg.sender);
         
    }
    
    function _execute(address _target, bool _isGov) internal {
        if(_isGov){
            governSize = governSize.add(1);
            weights[_target] = 1;
        }
        else{
            governSize = governSize.sub(1);
            weights[_target] = 0;
        }
        cleanProposal();
        emit SetGovernor(_target, _isGov);
    }
    
    function _cleanProposal() internal{
        proposal.target = address(0);
        proposal.votes = 0;
        proposal.voters.length = 0;
        emit CleanProposal(proposal.target, msg.sender);
    }

}







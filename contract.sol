pragma solidity ^0.8.0;

contract Crowdfunding {
    address payable public owner;
    mapping(address => uint) public contributions;
    uint public totalContributions;
    uint public goal;
    uint public deadline;
    bool public closed;
    bool public goalReached;
    
    constructor(uint _goal, uint _durationDays) payable {
        owner = payable(msg.sender);
        goal = _goal;
        deadline = block.timestamp + (_durationDays * 1 days);
        closed = false;
        goalReached = false;
    }
    
    function contribute() public payable {
        require(!closed, "The funding campaign is closed");
        require(block.timestamp <= deadline, "The funding campaign deadline has passed");
        contributions[msg.sender] += msg.value;
        totalContributions += msg.value;
        if (totalContributions >= goal) {
            goalReached = true;
            closed = true;
        }
    }
    
    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw the funds");
        require(closed, "The funding campaign is still open");
        require(goalReached, "The funding campaign goal was not reached");
        owner.transfer(totalContributions);
    }
    
    function closeCampaign() public {
        require(msg.sender == owner, "Only the owner can close the funding campaign");
        require(!closed, "The funding campaign is already closed");
        closed = true;
    }
}

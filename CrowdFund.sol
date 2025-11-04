// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract CrowdFund{
    struct Campaign {
        address owner;
        string title;
        string description;
        uint goal;
        uint amountRaised;
        bool completed;
}
mapping (uint => Campaign) public campaigns;
uint public campaignCount = 0;
function createCampaign(string memory _title, string memory _description, uint _goal) public {
    campaigns[campaignCount] = Campaign({
        owner: msg.sender,
        title: _title,
        description: _description,
        goal: _goal,
        amountRaised: 0,
        completed: false
    });
    campaignCount++;
}
function fundCampaign(uint _id) public payable {
    Campaign storage campaign = campaigns[_id];
    require(_id < campaignCount, "Campaign doesnot exist");
require(!campaign.completed, "Campaign already completed");
require(msg.value > 0, "You must send some ETH");
campaign.amountRaised +=msg.value;
if(campaign.amountRaised >= campaign.goal) {
    campaign.completed = true;
}
}
function withdraw(uint _id) public {
    Campaign storage campaign = campaigns[_id];
    require(msg.sender == campaign.owner, "Not campaign owner");
    require(campaign.amountRaised > 0, "No funds to withdraw");
    uint amount = campaign.amountRaised;
    campaign.amountRaised = 0;
    (bool success,) = campaign.owner.call{value:amount}("");
    require(success, "Transfer failed");
}
}
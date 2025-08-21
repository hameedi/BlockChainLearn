pragma solidity ^0.4.0; 

contract Bidder {
    
     string public name;
     uint public bidAmount = 20000;
     bool public  eligible;
     uint constant minBid = 1000;

     function setName(string _name) public {
          name = _name;
     }

     function setBidAmount(uint _bidAmount) public {
          bidAmount = _bidAmount;
     }

     function determineEligibility() public {
          if (bidAmount >= minBid) eligible = true;
          else eligible = false;
     } 
     
     
}
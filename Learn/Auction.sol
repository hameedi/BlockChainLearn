// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

contract Auction {
    struct Person {
        uint256 personId;
        address addr;
        uint256 remainingTokens;
    }

    struct Item {
        uint256 itemId;
        uint256 tokens;
    }

    enum Stage {
        Init,
        Reg,
        Bid,
        Done
    }

    mapping(address => Person) public people;
    mapping(address => Item) public items;
    Stage stage;
    address organizer;

    modifier hasTokens(address bidder) {
        require(people[bidder].remainingTokens > 0);
        _;
    }

    modifier validStage(Stage _stage) {
        require(stage == _stage);
        _;
    }

    function Auction() public {
        stage = Stage.Init;
        createPerson(1, 0x8438332974105367073911348732759344745833, 5);
        createPerson(2, 0x8438332974105367073911348732759344745, 5);
    }

    function createPerson(
        uint256 personId,
        address addr,
        uint256 remainingTokens
    ) public {
        Person memory p = Person(personId, addr, remainingTokens);
        people[addr] = p;
    }

    function ProceedToNextStage() public {
        if (stage == Stage.Init) {
            stage = Stage.Reg;
            return;
        }
        if (stage == Stage.Reg) {
            stage = Stage.Bid;
            return;
        }
        if (stage == Stage.Bid) {
            stage = Stage.Done;
            return;
        }
    }

    function register(address bidder)
        public
        validStage(Stage.Reg)
        hasTokens(bidder)
    {
        people[bidder].remainingTokens -= 1;
    }
}

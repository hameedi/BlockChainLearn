pragma solidity ^0.4.10;

contract Ballot {
    struct Voter {
        uint256 weight;
        bool voted;
        uint8 vote;
    }
    struct Proposal {
        uint256 voteCount;
    }
    enum Stage {
        Init,
        Reg,
        Vote,
        Done
    }
    Stage public stage = Stage.Init;

    address chairperson;
    mapping(address => Voter) voters;
    Proposal[] proposals;

    uint256 startTime;
    uint256 public timeNow;
    event votingCompleted();

    modifier validStage(Stage reqStage) {
        require(stage == reqStage);
        _;
    }

    /// Create a new ballot with $(_numProposals) different proposals.
    function Ballot(uint8 _numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2; // weight is 2 for testing purposes
        proposals.length = _numProposals;
        stage = Stage.Init;
        startTime = now;
    }

    function advanceState() public {
        timeNow = now;
        if (timeNow > (startTime + 10 seconds)) {
            startTime = timeNow;
            if (stage == Stage.Init) {
                stage = Stage.Reg;
                return;
            }
            if (stage == Stage.Reg) {
                stage = Stage.Vote;
                return;
            }
            if (stage == Stage.Vote) {
                stage = Stage.Done;
                return;
            }
            return;
        }
    }

    /// Give $(toVoter) the right to vote on this ballot.
    /// May only be called by $(chairperson).
    function register(address toVoter) public validStage(Stage.Reg) {
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
        if (now > (startTime + 20 seconds)) {
            stage = Stage.Vote;
            startTime = now;
        }
    }

    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public validStage(Stage.Vote) {
        // if (stage != Stage.Vote) {
        //     return;
        // }
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
        if (now > (startTime + 10 seconds)) {
            stage = Stage.Done;
            // votingCompleted();
        }
    }

    function winningProposal()
        public validStage(Stage.Done)
        constant
        returns (uint8 _winningProposal)
    {
        // if (stage != Stage.Done) {
        //     return;
        // }
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
        assert(winningVoteCount > 0);
    }
}

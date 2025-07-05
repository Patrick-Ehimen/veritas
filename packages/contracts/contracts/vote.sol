// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Ballot Voting Contract
/// @author
/// @notice This contract allows an admin to manage a simple approval/rejection poll with permissioned voters.
/// @dev All function calls are currently implemented without side effects except for state-changing functions.

contract Voting {
    /// @notice The address of the contract admin
    address public admin;
    /// @notice Indicates if the poll is currently open
    bool public pollOpen;
    /// @notice Mapping of addresses permitted to vote
    mapping(address => bool) public permittedVoters;
    /// @notice Mapping of addresses that have already voted
    mapping(address => bool) public voted;

    /// @notice Number of approval votes
    uint256 public approvals;
    /// @notice Number of rejection votes
    uint256 public rejections;

    /// @dev Restricts function to only the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    /// @dev Restricts function to only permitted voters
    modifier onlyPermitted() {
        require(permittedVoters[msg.sender], "Not permitted to participate");
        _;
    }

    /// @dev Restricts function to when the poll is open
    modifier pollIsOpen() {
        require(pollOpen, "Poll is not open");
        _;
    }

    /// @notice Emitted when the poll is opened
    event PollOpened();
    /// @notice Emitted when the poll is closed
    /// @param approvals Number of approvals at close
    /// @param rejections Number of rejections at close
    event PollClosed(uint256 approvals, uint256 rejections);
    /// @notice Emitted when a vote is cast
    /// @param voter Address of the voter
    /// @param choice The choice made by the voter (true = approve, false = reject)
    event VoteCast(address voter, bool choice);

    /// @notice Initializes the contract, setting the deployer as admin
    constructor() {
        admin = msg.sender;
        pollOpen = false;
    }

    /// @notice Grants voting permission to an address
    /// @dev Only callable by admin
    /// @param _voter The address to permit
    function grantPermission(address _voter) external onlyAdmin {
        permittedVoters[_voter] = true;
    }

    /// @notice Opens the poll for voting and resets previous results
    /// @dev Only callable by admin. Emits PollOpened.
    function openPoll() external onlyAdmin {
        require(!pollOpen, "Poll is already open");
        pollOpen = true;

        // Reset previous poll results
        approvals = 0;
        rejections = 0;

        emit PollOpened();
    }

    /// @notice Closes the poll for voting
    /// @dev Only callable by admin. Emits PollClosed.
    function closePoll() external onlyAdmin pollIsOpen {
        pollOpen = false;
        emit PollClosed(approvals, rejections);
    }

    /// @notice Submit a vote for the current poll
    /// @dev Only permitted voters can call this while poll is open. Emits VoteCast.
    /// @param _choice The vote choice (true = approve, false = reject)
    function submitVote(bool _choice) external onlyPermitted pollIsOpen {
        require(!voted[msg.sender], "Already voted");

        if (_choice) {
            approvals += 1;
        } else {
            rejections += 1;
        }

        voted[msg.sender] = true;
        emit VoteCast(msg.sender, _choice);
    }

    /// @notice Retrieve the current vote tallies
    /// @return _approvals The number of approvals
    /// @return _rejections The number of rejections
    function fetchResults()
        external
        view
        returns (uint256 _approvals, uint256 _rejections)
    {
        return (approvals, rejections);
    }
}

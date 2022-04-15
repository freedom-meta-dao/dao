//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @notice Data structure for Community-based polls and proposals.
 */
struct CommunityPoll {
	bytes32 id;
	address creator;
	bytes32 url;
	string name;
	string description;
	bool active;
	bool openVoting;
}

struct PollVote {
	address voter;
	string optionValue;

}

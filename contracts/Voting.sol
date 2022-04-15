//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Community/Poll.sol";

/**
 * @title
 */
contract Voting {
	mapping(bytes32 => CommunityPoll) private _polls;
	mapping(bytes32 => mapping(address => PollVote)) private _pollVotes;

	function voteStatus(bytes32 pollId, address voter) external view returns (bool) {
		CommunityPoll memory poll = _polls[pollId];
		require(poll.id > 0, "No poll matches provided pollId");

		bool canSeeVote = poll.openVoting == true || msg.sender == voter;
		require(canSeeVote == true, "Only your own vote status can be checked for closed polls");
	}

	function communityVoteCast(bytes32 pollId) external {
		address voter = msg.sender;

		CommunityPoll memory poll = _polls[pollId];
	}

	function pollFetch(bytes32 id)
		external
		view
		returns (
			address,
			bytes32,
			bool,
			bool
		)
	{
		require(_polls[id].id > 0, "No poll found with provided pollId");

		return (_polls[id].creator, _polls[id].url, _polls[id].active, _polls[id].openVoting);
	}

	function communityPollCreate(bytes32 id, string calldata url) external {
		CommunityPoll storage poll;
	}
}

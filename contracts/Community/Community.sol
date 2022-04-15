//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Community Member Data
 * @notice Data record stored once for each member in a community. The same wallet in
 * multiple communities will have one member record for each community they join.
 */
struct CommunityMember {
	bytes32 id;
	address addr;
	string[] roles;
	uint joinBlock;
	uint joinTimestamp;
}

/**
 * @title Status for community.
 * @notice Community Status for each community which limits available actions.
 */
enum CommunityStatus {
	ACTIVE,
	ABANDONED,
	SUSPENDED,
	INACTIVE,
	NOT_FOUND
}

/**
 * @title Community data format
 * @notice
 */
struct Community {
	bytes32 id;
	CommunityStatus status;
	string name;
	mapping(address => CommunityMember) _members;
	uint createBlock;
	uint createTimestamp;
	address creator;
}

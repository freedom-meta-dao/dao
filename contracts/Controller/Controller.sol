//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Voting} from "../Voting.sol";
import {CommunityMember, Community, CommunityStatus} from "../Community/Community.sol";

import {Initializable, OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title DAO Controller
 * @author Michael Brich
 * @notice Primary controller handling DAO calls.
 */
contract Controller is Initializable, UUPSUpgradeable, OwnableUpgradeable {
	event EvtControllerUpgrade();
	event EvtControllerTreasuryUpdate();
	event EvtControllerRoleAdd();
	event EvtControllerRoleRemove();
	event EvtControllerRoleUpdate();
	event EvtCommunityCreate();
	event EvtCommunityMemberJoin();
	event EvtCommunityMemberApply();
	event EvtCommunityMemberLeave();
	event EvtCommunityMemberRemove();
	event EvtCommunitDelete();
	event EvtCommunitySuspend();
	event EvtCommunityUnsuspend();
	event EvtCommunityPollCreate();
	event EvtCommunityPollDelete();
	event EvtCommunityPollUpdate();
	event EvtCommunityPollStart();
	event EvtCommunityPollStop();
	event EvtCommunityMemberApplyError();
	event EvtCommunityMemberJoinError();
	event EvtCommunityMemberRemoveError();
	event EvtCommunityCreateError();
	event EvtCommunityDeleteError();

	mapping(bytes32 => Community) private _communities;
	/**
	 * @notice Address of the Proxy contract which delegates calls to this contract.
	 */
	address private _controllerProxy;
	/**
	 * @notice Flag indicating whether this contract is actively used by the Proxy Contract.
	 * Set to false after the Proxy Contract successfully completes an upgrade call and targets
	 * a new proxied contract.
	 */
	bool private _active;

	/**
	 * @notice Called once by the DAO Proxy contract to initialize contract values
	 * and properties. Only callable once during init.
	 */
	function initialize(uint256 initialValue) public initializer {
		setControllerProxy(msg.sender);
	}

	function _authorizeUpgrade(address) internal override onlyOwner {}

	function activate() external onlyInitializing {
		_active = true;
	}

	function deactivate() external {
		_active = false;
	}

	function fetchAssertCommunity(bytes32 id, string memory errorMsg) internal returns (Community storage) {
		Community storage comm = fetchCommunity(id);
		require(comm.id > 0, string(abi.encodePacked("Community Not Found - ", errorMsg)));

		return comm;
	}

	/**
	 * @notice Retrieve data for target community if it exists. Used internally by various calls to validate
	 * community status, permissions, etc.
	 */
	function fetchCommunity(bytes32 id) internal returns (Community storage) {
		Community storage comm = _communities[id];
		if (comm.createBlock < 1) {
			return comm;
		}

		return comm;
	}

	function assertMember(Community storage community, address target) internal {
		CommunityMember storage member = community._members[target];

		require(member.id > 0, "Member not found in community.");
	}

	/**
	 * @notice Set the proxy contract address which will call this contract. Can only be
	 * set once during contract initialization.
	 * @param target	-	Address of proxy contract using this contract. Should only be set
	 *						once during contract init.
	 */
	function setControllerProxy(address target) internal initializer returns (bool) {
		_controllerProxy = target;

		return true;
	}

	/**
	 * @notice Suspend target community if it exists and is not already suspended. Only DAO admins can
	 * perform this action.
	 */
	function communitySuspend(bytes32 id, string memory reason) external onlyProxy returns (bool) {
		Community storage comm = fetchAssertCommunity(id, "Cannot unsuspend suspend community");

		return false;
	}

	/**
	 * @notice Unsuspend target community if it exists and is currently suspended. Only DAO admins can
	 * perform this action.
	 */
	function communityUnsuspend(bytes32 id) external onlyProxy returns (bool) {
		Community storage comm = fetchAssertCommunity(id, "Cannot unsuspend target community");

		return false;
	}

	/**
	 * @notice Create a Freedom MetaDAO Community using the provided parameters. Caller becomes
	 * the first member and admin automatically if the action succeeds.
	 */
	function communityCreate(string memory name) external onlyProxy returns (bool) {
		return false;
	}

	/**
	 * @notice Change community properties. Only members of target community with sufficient
	 * permissions can perform this action.
	 */
	function communityEdit(bytes32 id) external onlyProxy returns (bool) {
		Community storage comm = fetchAssertCommunity(id, "Cannot edit target community.");

		return false;
	}

	/**
	 * @notice Delete target community. Only community members with sufficient permissions
	 * can perform this action.
	 */
	function communityDelete(bytes32 id) external onlyProxy returns (bool) {
		Community storage comm = fetchAssertCommunity(id, "Cannot delete target community.");

		return false;
	}

	/**
	 * @notice Remove member from target community. Only community members with sufficient
	 * permissions can perform this action.
	 */
	function communityMemberRemove(bytes32 id, address member) external onlyProxy returns (bool) {
		Community storage comm = fetchAssertCommunity(id, "Cannot remove target member.");

		return false;
	}

	/**
	 * @notice Apply to join community using the currently connected wallet address.
	 */
	function communityApply(bytes32 id) external onlyProxy returns (bool) {
		Community storage comm = fetchAssertCommunity(id, "Cannot complete member application.");

		return false;
	}

	/**
	 * @notice Join community using the currently connected wallet address.
	 */
	function communityJoin(bytes32 id) external onlyProxy returns (bool) {
		Community storage comm = fetchAssertCommunity(id, "Cannot join community that does not exist.");

		return false;
	}

	/**
	 * @notice Leave target community on your currently connected wallet. No effect when target community does
	 * not exist, or caller's address is not a community member.
	 */
	function communityLeave(bytes32 id) external onlyProxy returns (bool) {
		Community storage comm = fetchAssertCommunity(id, "Cannot leave community that does not exist.");

		return false;
	}
}

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * This is a mock sanctions list contract modeled after the Chainalysis sanctions list.
 * The intent of this mock contract is to be deployed to testnets to enable testing.
 *
 * You can experiment my adding an address you control to the sanctions list. Removal is also supported.
 */

contract SanctionsList is AccessControl {
    bytes32 constant SANCTION_LIST_ADMIN = keccak256("SANCTION_LIST_ADMIN");
    constructor(address _sanctionListAdmin) {
        _grantRole(SANCTION_LIST_ADMIN, _sanctionListAdmin);
        _setRoleAdmin(SANCTION_LIST_ADMIN, SANCTION_LIST_ADMIN);
    }

    mapping(address => bool) private sanctionedAddresses;

    event SanctionedAddress(address indexed addr);
    event NonSanctionedAddress(address indexed addr);
    event SanctionedAddressAdded(address addr);
    event SanctionedAddressesAdded(address[] addrs);
    event SanctionedAddressRemoved(address addr);

    function name() external pure returns (string memory) {
        return "Chainalysis Sanctions Oracle - Mock for Testnets";
    }

    function addToSanctionsList(address newSanctionAddress) public {
        require(
            newSanctionAddress == msg.sender,
            "This mock sanctions list only allows adding msg.sender"
        );

        sanctionedAddresses[newSanctionAddress] = true;

        emit SanctionedAddressAdded(newSanctionAddress);
    }

    function addToSanctionsListArr(
        address[] memory newSanctions
    ) public onlyRole(SANCTION_LIST_ADMIN) {
        for (uint256 i = 0; i < newSanctions.length; i++) {
            sanctionedAddresses[newSanctions[i]] = true;
        }
        emit SanctionedAddressesAdded(newSanctions);
    }

    function removeFromSanctionsList(address removeSanctionAddress) public {
        require(
            removeSanctionAddress == msg.sender,
            "This mock sanctions list only allows removing msg.sender"
        );

        sanctionedAddresses[removeSanctionAddress] = false;

        emit SanctionedAddressRemoved(removeSanctionAddress);
    }

    function isSanctioned(address addr) public view returns (bool) {
        return sanctionedAddresses[addr] == true;
    }

    function isSanctionedVerbose(address addr) public returns (bool) {
        if (isSanctioned(addr)) {
            emit SanctionedAddress(addr);
            return true;
        } else {
            emit NonSanctionedAddress(addr);
            return false;
        }
    }
}

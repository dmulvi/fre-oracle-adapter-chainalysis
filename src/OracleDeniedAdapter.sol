// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.24;
import {IOracleEvents} from "@thrackle-io/forte-rules-engine/src/common/IEvents.sol";

/**
 * @title Denied-List Oracle Adapter that connects to Chainalysis Santions contract
 * @author @dmulvi
 * @notice This is an example on-chain oracle adapter to be used with the Forte Rules Engine.
 */
interface ISanctionsList {
    function isSanctioned(address addr) external view returns (bool);
    function isSanctionedVerbose(address addr) external returns (bool);
}

contract OracleDeniedAdapter is IOracleEvents {
    ISanctionsList public immutable chainalysisSanctions;
    
    /**
     * @dev Constructor that notifyies the indexer of its creation via event and setups up SanctionsList caller with provided address.
     */
    constructor(address _chainalysisAddress) {
        chainalysisSanctions = ISanctionsList(_chainalysisAddress);
        emit AD1467_DeniedListOracleDeployed();
    }

    /**
     * @dev Return the contract name
     * @return name of the contract
     */
    function name() external pure returns (string memory) {
        return "Oracle Denied Adapter - Chainalysis Sanctions";
    }

    /**
     * @dev Check to see if address is in sanctions list
     * @param addr the address to check
     * @return denied returns true if in the sanctions list, false if not.
     */
    function isDenied(address addr) public view returns (bool) {
        return chainalysisSanctions.isSanctioned(addr);
    }

    /**
     * @dev Check to see if address is in sanctions list. Also emits events based on the results
     * @param addr the address to check
     * @return denied returns true if in the sanctions list, false if not.
     */
    function isDeniedVerbose(address addr) public returns (bool) {
        bool isAddressDenied = chainalysisSanctions.isSanctionedVerbose(addr);
        emit AD1467_DeniedAddress(addr, isAddressDenied);
        return isAddressDenied;
    }
}